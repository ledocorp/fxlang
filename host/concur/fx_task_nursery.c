/* Structured task nursery - Win32 threads / pthreads (CONCUR-1 + 1b/1c). */
#if defined(__linux__)
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#endif
#include "fx_task_nursery.h"

#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#else
#include <pthread.h>
#include <time.h>
#include <errno.h>
#endif

typedef struct FxNurserySlot {
    FxTaskFn fn;
    void *arg;
#ifdef _WIN32
    HANDLE thr;
#else
    pthread_t thr;
#endif
    int used;
    int joined;
} FxNurserySlot;

struct FxNursery {
    int live;
    int cancel;
    int n;
    int cap;
    FxNurserySlot *slots;
#ifdef _WIN32
    CRITICAL_SECTION lock;
#else
    pthread_mutex_t lock;
#endif
};

#ifdef _WIN32
static DWORD WINAPI fx_nursery_tramp(void *p) {
    FxNurserySlot *s = (FxNurserySlot *)p;
    s->fn(s->arg);
    return 0;
}
#else
static void *fx_nursery_tramp(void *p) {
    FxNurserySlot *s = (FxNurserySlot *)p;
    s->fn(s->arg);
    return NULL;
}
#endif

static void fx_nursery_lock(FxNursery *n) {
#ifdef _WIN32
    EnterCriticalSection(&n->lock);
#else
    (void)pthread_mutex_lock(&n->lock);
#endif
}

static void fx_nursery_unlock(FxNursery *n) {
#ifdef _WIN32
    LeaveCriticalSection(&n->lock);
#else
    (void)pthread_mutex_unlock(&n->lock);
#endif
}

FxNursery *fx_nursery_create_sized(int max_tasks) {
    FxNursery *n;
    if (max_tasks < 1 || max_tasks > FX_NURSERY_HARD_MAX) {
        return NULL;
    }
    n = (FxNursery *)calloc(1, sizeof(FxNursery));
    if (!n) {
        return NULL;
    }
    n->slots = (FxNurserySlot *)calloc((size_t)max_tasks, sizeof(FxNurserySlot));
    if (!n->slots) {
        free(n);
        return NULL;
    }
#ifdef _WIN32
    InitializeCriticalSection(&n->lock);
#else
    if (pthread_mutex_init(&n->lock, NULL) != 0) {
        free(n->slots);
        free(n);
        return NULL;
    }
#endif
    n->live = 1;
    n->cap = max_tasks;
    return n;
}

FxNursery *fx_nursery_create(void) {
    return fx_nursery_create_sized(FX_NURSERY_DEFAULT_MAX);
}

int fx_nursery_capacity(const FxNursery *n) {
    return n ? n->cap : 0;
}

int fx_nursery_is_live(const FxNursery *n) {
    return n && n->live;
}

int fx_nursery_cancel_requested(const FxNursery *n) {
    return n && n->cancel;
}

int fx_nursery_pending(const FxNursery *n) {
    int i;
    int p = 0;
    if (!n) {
        return 0;
    }
    for (i = 0; i < n->n; i++) {
        if (n->slots[i].used && !n->slots[i].joined) {
            p++;
        }
    }
    return p;
}

int fx_nursery_request_cancel(FxNursery *n) {
    if (!n) {
        return FX_NURSERY_ERR;
    }
    fx_nursery_lock(n);
    if (!n->live) {
        fx_nursery_unlock(n);
        return FX_NURSERY_DEAD;
    }
    n->cancel = 1;
    fx_nursery_unlock(n);
    return FX_NURSERY_OK;
}

int fx_nursery_spawn(FxNursery *n, FxTaskFn fn, void *arg) {
    FxNurserySlot *s;
    int rc = FX_NURSERY_ERR;

    if (!n || !fn) {
        return FX_NURSERY_ERR;
    }

    fx_nursery_lock(n);
    if (!n->live) {
        fx_nursery_unlock(n);
        return FX_NURSERY_DEAD;
    }
    if (n->n >= n->cap) {
        fx_nursery_unlock(n);
        return FX_NURSERY_FULL;
    }

    s = &n->slots[n->n];
    memset(s, 0, sizeof(*s));
    s->fn = fn;
    s->arg = arg;
    s->used = 1;
    s->joined = 0;

#ifdef _WIN32
    s->thr = CreateThread(NULL, 0, fx_nursery_tramp, s, 0, NULL);
    if (!s->thr) {
        s->used = 0;
        fx_nursery_unlock(n);
        return FX_NURSERY_ERR;
    }
#else
    if (pthread_create(&s->thr, NULL, fx_nursery_tramp, s) != 0) {
        s->used = 0;
        fx_nursery_unlock(n);
        return FX_NURSERY_ERR;
    }
#endif

    n->n++;
    rc = FX_NURSERY_OK;
    fx_nursery_unlock(n);
    return rc;
}

static int fx_nursery_join_one(FxNursery *n, FxNurserySlot *s, uint32_t timeout_ms, int use_timeout) {
#ifdef _WIN32
    DWORD w;
    DWORD ms = use_timeout ? (DWORD)timeout_ms : INFINITE;
    fx_nursery_unlock(n);
    w = WaitForSingleObject(s->thr, ms);
    if (w == WAIT_TIMEOUT) {
        fx_nursery_lock(n);
        return FX_NURSERY_TIMEOUT;
    }
    if (w == WAIT_OBJECT_0) {
        CloseHandle(s->thr);
        s->thr = NULL;
        fx_nursery_lock(n);
        s->joined = 1;
        return FX_NURSERY_OK;
    }
    fx_nursery_lock(n);
    return FX_NURSERY_ERR;
#else
    (void)timeout_ms;
    if (!use_timeout) {
        fx_nursery_unlock(n);
        (void)pthread_join(s->thr, NULL);
        fx_nursery_lock(n);
        s->joined = 1;
        return FX_NURSERY_OK;
    }
#if defined(__linux__)
    {
        struct timespec ts;
        int jr;
        fx_nursery_unlock(n);
        if (clock_gettime(CLOCK_REALTIME, &ts) != 0) {
            fx_nursery_lock(n);
            return FX_NURSERY_ERR;
        }
        ts.tv_sec += (time_t)(timeout_ms / 1000u);
        ts.tv_nsec += (long)(timeout_ms % 1000u) * 1000000L;
        if (ts.tv_nsec >= 1000000000L) {
            ts.tv_sec += 1;
            ts.tv_nsec -= 1000000000L;
        }
        jr = pthread_timedjoin_np(s->thr, NULL, &ts);
        fx_nursery_lock(n);
        if (jr == 0) {
            s->joined = 1;
            return FX_NURSERY_OK;
        }
        if (jr == ETIMEDOUT) {
            return FX_NURSERY_TIMEOUT;
        }
        return FX_NURSERY_ERR;
    }
#else
    /* Portable fallback: cancel requested + blocking join. */
    n->cancel = 1;
    fx_nursery_unlock(n);
    (void)pthread_join(s->thr, NULL);
    fx_nursery_lock(n);
    s->joined = 1;
    return FX_NURSERY_OK;
#endif
#endif
}

int fx_nursery_join_all(FxNursery *n) {
    int i;

    if (!n) {
        return FX_NURSERY_ERR;
    }

    fx_nursery_lock(n);
    if (!n->live) {
        fx_nursery_unlock(n);
        return FX_NURSERY_DEAD;
    }

    for (i = 0; i < n->n; i++) {
        FxNurserySlot *s = &n->slots[i];
        int rc;
        if (!s->used || s->joined) {
            continue;
        }
        rc = fx_nursery_join_one(n, s, 0, 0);
        if (rc != FX_NURSERY_OK) {
            fx_nursery_unlock(n);
            return rc;
        }
    }
    fx_nursery_unlock(n);
    return FX_NURSERY_OK;
}

int fx_nursery_join_all_timeout(FxNursery *n, uint32_t timeout_ms) {
    int i;

    if (!n) {
        return FX_NURSERY_ERR;
    }

    fx_nursery_lock(n);
    if (!n->live) {
        fx_nursery_unlock(n);
        return FX_NURSERY_DEAD;
    }

    for (i = 0; i < n->n; i++) {
        FxNurserySlot *s = &n->slots[i];
        int rc;
        if (!s->used || s->joined) {
            continue;
        }
        /* Per-slot slice: simple budget - full timeout each remaining join. */
        rc = fx_nursery_join_one(n, s, timeout_ms, 1);
        if (rc != FX_NURSERY_OK) {
            fx_nursery_unlock(n);
            return rc;
        }
    }
    fx_nursery_unlock(n);
    return FX_NURSERY_OK;
}

int fx_nursery_shutdown(FxNursery *n) {
    int rc;

    if (!n) {
        return FX_NURSERY_ERR;
    }
    fx_nursery_lock(n);
    if (!n->live) {
        fx_nursery_unlock(n);
        return FX_NURSERY_DEAD;
    }
    n->cancel = 1;
    fx_nursery_unlock(n);

    rc = fx_nursery_join_all(n);
    if (rc != FX_NURSERY_OK) {
        return rc;
    }

    fx_nursery_lock(n);
    n->live = 0;
    fx_nursery_unlock(n);
    return FX_NURSERY_OK;
}

void fx_nursery_destroy(FxNursery *n) {
    if (!n) {
        return;
    }
    if (n->live) {
        (void)fx_nursery_shutdown(n);
    }
#ifdef _WIN32
    DeleteCriticalSection(&n->lock);
#else
    (void)pthread_mutex_destroy(&n->lock);
#endif
    free(n->slots);
    free(n);
}
