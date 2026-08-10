/* Argv host over sqlite + FsCap (host/cli + host/cap).
 *
 * Proves: mint FsCap(fixtures) → open file DB → SELECT 42;
 *         escape path denied (-5).
 * Dual-path product proofs: main.fx (:memory:) and file_cap.fx.
 */
#include "../../host/cli/fx_cli_host.h"
#include "../../host/cap/fx_cap_runtime.h"

#include <stdint.h>
#include <stdio.h>

int32_t fx_sqlite_open_memory(void);
int32_t fx_sqlite_open_fscap(int64_t fs_handle, const char *path);
int32_t fx_sqlite_exec(int32_t h, const char *sql);
int32_t fx_sqlite_query_i32(int32_t h, const char *sql);
int32_t fx_sqlite_close(int32_t h);

static int run_memory_smoke(void) {
    int32_t h;
    int32_t n;

    h = fx_sqlite_open_memory();
    if (h < 1) {
        return fx_cli_fail("wrap_sqlite", "open_memory failed", 1);
    }
    if (fx_sqlite_exec(h, "CREATE TABLE t(x INTEGER); INSERT INTO t VALUES(42);") != 0) {
        (void)fx_sqlite_close(h);
        return fx_cli_fail("wrap_sqlite", "exec failed", 1);
    }
    n = fx_sqlite_query_i32(h, "SELECT x FROM t;");
    (void)fx_sqlite_close(h);
    if (n != 42) {
        return fx_cli_fail("wrap_sqlite", "query expected 42", 1);
    }
    return 0;
}

static int run_file_cap_smoke(void) {
    int64_t ctx;
    int64_t fs_h;
    int32_t h;
    int32_t n;
    int32_t denied;

    /* Paths relative to examples/wrap_sqlite (test harness cwd). */
    ctx = fx_guest_begin("fixtures", 65536);
    if (ctx == 0) {
        return fx_cli_fail("wrap_sqlite", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_sqlite", "mint_fs failed", 1);
    }

    denied = fx_sqlite_open_fscap(fs_h, "fixtures/../escape.db");
    if (denied != -5) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_sqlite", "escape deny expected", 1);
    }

    h = fx_sqlite_open_fscap(fs_h, "fixtures/wrap_demo.db");
    if (h < 1) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_sqlite", "open_fscap failed", 1);
    }
    if (fx_sqlite_exec(
            h,
            "CREATE TABLE IF NOT EXISTS t(x INTEGER); DELETE FROM t; INSERT INTO t VALUES(42);"
        ) != 0) {
        (void)fx_sqlite_close(h);
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_sqlite", "file exec failed", 1);
    }
    n = fx_sqlite_query_i32(h, "SELECT x FROM t;");
    (void)fx_sqlite_close(h);
    (void)fx_guest_end(ctx);
    if (n != 42) {
        return fx_cli_fail("wrap_sqlite", "file query expected 42", 1);
    }
    return 0;
}

int main(int argc, char **argv) {
    int rc;
    (void)argc;
    (void)argv;

    rc = run_memory_smoke();
    if (rc != 0) {
        return rc;
    }
    return run_file_cap_smoke();
}
