/* Structured task nursery smoke (host TCB) - CONCUR-1 + 1b/1c.
 *
 * Sum 42 · FULL/DEAD · sized capacity · double join · cancel poll · timeout
 * Exit: 0 success · 1 failure
 */
#include "../../host/cli/fx_cli_host.h"
#include "../../host/concur/fx_task_nursery.h"

#include <stdio.h>
#include <string.h>

#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#else
#include <unistd.h>
#endif

typedef struct {
    int *slot;
    int value;
} AddArg;

typedef struct {
    FxNursery *n;
    int *out;
} CancelArg;

static void task_store(void *p) {
    AddArg *a = (AddArg *)p;
    *a->slot = a->value;
}

static void task_spin_until_cancel(void *p) {
    CancelArg *a = (CancelArg *)p;
    while (!fx_nursery_cancel_requested(a->n)) {
#ifdef _WIN32
        Sleep(1);
#else
        usleep(1000);
#endif
    }
    *a->out = 42;
}

static void task_sleep_long(void *p) {
    (void)p;
#ifdef _WIN32
    Sleep(2000);
#else
    sleep(2);
#endif
}

static int run_sum_probe(void) {
    FxNursery *n;
    int parts[2];
    AddArg a0;
    AddArg a1;
    int sum;

    memset(parts, 0, sizeof(parts));
    a0.slot = &parts[0];
    a0.value = 20;
    a1.slot = &parts[1];
    a1.value = 22;

    n = fx_nursery_create();
    if (!n || !fx_nursery_is_live(n)) {
        return fx_cli_fail("concur_nursery", "create failed", 1);
    }
    if (fx_nursery_capacity(n) != FX_NURSERY_DEFAULT_MAX) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "default capacity", 1);
    }

    if (fx_nursery_spawn(n, task_store, &a0) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "spawn0 failed", 1);
    }
    if (fx_nursery_spawn(n, task_store, &a1) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "spawn1 failed", 1);
    }
    if (fx_nursery_pending(n) != 2) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "pending expected 2", 1);
    }
    if (fx_nursery_join_all(n) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "join_all failed", 1);
    }
    /* Idempotent double-join while live (CONCUR-1b). */
    if (fx_nursery_join_all(n) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "double join failed", 1);
    }
    if (fx_nursery_pending(n) != 0) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "pending after join", 1);
    }

    sum = parts[0] + parts[1];
    if (sum != 42) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "sum expected 42", 1);
    }

    fx_nursery_destroy(n);
    return 0;
}

static int run_sized_and_full(void) {
    FxNursery *n;
    int sink = 0;
    AddArg a;
    int i;
    int rc;

    a.slot = &sink;
    a.value = 1;

    n = fx_nursery_create_sized(4);
    if (!n || fx_nursery_capacity(n) != 4) {
        return fx_cli_fail("concur_nursery", "create_sized 4 failed", 1);
    }
    for (i = 0; i < 4; i++) {
        if (fx_nursery_spawn(n, task_store, &a) != FX_NURSERY_OK) {
            fx_nursery_destroy(n);
            return fx_cli_fail("concur_nursery", "sized fill failed", 1);
        }
    }
    if (fx_nursery_spawn(n, task_store, &a) != FX_NURSERY_FULL) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "sized expected FULL", 1);
    }
    fx_nursery_destroy(n);

    if (fx_nursery_create_sized(0) != NULL || fx_nursery_create_sized(100) != NULL) {
        return fx_cli_fail("concur_nursery", "invalid size should NULL", 1);
    }

    n = fx_nursery_create();
    if (!n) {
        return fx_cli_fail("concur_nursery", "create2 failed", 1);
    }
    for (i = 0; i < FX_NURSERY_DEFAULT_MAX; i++) {
        rc = fx_nursery_spawn(n, task_store, &a);
        if (rc != FX_NURSERY_OK) {
            fx_nursery_destroy(n);
            return fx_cli_fail("concur_nursery", "fill spawn failed early", 1);
        }
    }
    rc = fx_nursery_spawn(n, task_store, &a);
    if (rc != FX_NURSERY_FULL) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "expected FULL", 1);
    }

    if (fx_nursery_shutdown(n) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "shutdown failed", 1);
    }
    if (fx_nursery_is_live(n)) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "expected not live", 1);
    }
    if (fx_nursery_spawn(n, task_store, &a) != FX_NURSERY_DEAD) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "expected DEAD after shutdown", 1);
    }
    if (fx_nursery_join_all(n) != FX_NURSERY_DEAD) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "join after shutdown expected DEAD", 1);
    }
    if (fx_nursery_shutdown(n) != FX_NURSERY_DEAD) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "second shutdown expected DEAD", 1);
    }

    fx_nursery_destroy(n);
    return 0;
}

static int run_cancel(void) {
    FxNursery *n;
    int out = 0;
    CancelArg ca;

    n = fx_nursery_create();
    if (!n) {
        return fx_cli_fail("concur_nursery", "cancel create failed", 1);
    }
    ca.n = n;
    ca.out = &out;
    if (fx_nursery_spawn(n, task_spin_until_cancel, &ca) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "cancel spawn failed", 1);
    }
    if (fx_nursery_request_cancel(n) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "request_cancel failed", 1);
    }
    if (fx_nursery_join_all(n) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "cancel join failed", 1);
    }
    if (out != 42) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "cancel task did not finish", 1);
    }
    fx_nursery_destroy(n);
    return 0;
}

static int run_timeout(void) {
    FxNursery *n;
    int rc;

    n = fx_nursery_create();
    if (!n) {
        return fx_cli_fail("concur_nursery", "timeout create failed", 1);
    }
    if (fx_nursery_spawn(n, task_sleep_long, NULL) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "timeout spawn failed", 1);
    }
    rc = fx_nursery_join_all_timeout(n, 50);
#ifdef _WIN32
    if (rc != FX_NURSERY_TIMEOUT) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "expected TIMEOUT", 1);
    }
    (void)fx_nursery_request_cancel(n);
    /* Still must join the long sleeper before destroy. */
    if (fx_nursery_join_all(n) != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "post-timeout join failed", 1);
    }
#else
    /* Linux: TIMEOUT; other POSIX: cancel+join fallback may return OK. */
    if (rc != FX_NURSERY_TIMEOUT && rc != FX_NURSERY_OK) {
        fx_nursery_destroy(n);
        return fx_cli_fail("concur_nursery", "timeout path failed", 1);
    }
    if (rc == FX_NURSERY_TIMEOUT) {
        (void)fx_nursery_request_cancel(n);
        if (fx_nursery_join_all(n) != FX_NURSERY_OK) {
            fx_nursery_destroy(n);
            return fx_cli_fail("concur_nursery", "post-timeout join failed", 1);
        }
    }
#endif
    fx_nursery_destroy(n);
    return 0;
}

static int run_null_err(void) {
    if (fx_nursery_spawn(NULL, task_store, NULL) != FX_NURSERY_ERR) {
        return fx_cli_fail("concur_nursery", "null spawn expected ERR", 1);
    }
    if (fx_nursery_join_all(NULL) != FX_NURSERY_ERR) {
        return fx_cli_fail("concur_nursery", "null join expected ERR", 1);
    }
    if (fx_nursery_shutdown(NULL) != FX_NURSERY_ERR) {
        return fx_cli_fail("concur_nursery", "null shutdown expected ERR", 1);
    }
    fx_nursery_destroy(NULL);
    return 0;
}

int main(int argc, char **argv) {
    int rc;
    (void)argc;
    (void)argv;

    rc = run_sum_probe();
    if (rc != 0) {
        return rc;
    }
    rc = run_sized_and_full();
    if (rc != 0) {
        return rc;
    }
    rc = run_cancel();
    if (rc != 0) {
        return rc;
    }
    rc = run_timeout();
    if (rc != 0) {
        return rc;
    }
    rc = run_null_err();
    if (rc != 0) {
        return rc;
    }
    return 0;
}
