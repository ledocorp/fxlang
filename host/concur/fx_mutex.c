/* process-local mutex substrate (i32 slots; emit-C i64 trunc). */
#include "fx_mutex.h"

#include <stdlib.h>
#include <string.h>

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <pthread.h>
#endif

#define FX_MUTEX_SLOTS 64

typedef struct fx_mutex_body {
#if defined(_WIN32)
    CRITICAL_SECTION cs;
#else
    pthread_mutex_t mu;
#endif
    int alive;
} fx_mutex_body;

static fx_mutex_body g_slots[FX_MUTEX_SLOTS];
static int g_used[FX_MUTEX_SLOTS];

static fx_mutex_body *slot_mut(int32_t id) {
    int idx;
    if (id < 1 || id > FX_MUTEX_SLOTS) {
        return NULL;
    }
    idx = id - 1;
    if (!g_used[idx] || !g_slots[idx].alive) {
        return NULL;
    }
    return &g_slots[idx];
}

int32_t fx_mutex_create(void) {
    int i;
    for (i = 0; i < FX_MUTEX_SLOTS; i++) {
        if (!g_used[i]) {
#if defined(_WIN32)
            InitializeCriticalSection(&g_slots[i].cs);
#else
            if (pthread_mutex_init(&g_slots[i].mu, NULL) != 0) {
                return 0;
            }
#endif
            g_slots[i].alive = 1;
            g_used[i] = 1;
            return (int32_t)(i + 1);
        }
    }
    return 0;
}

int32_t fx_mutex_lock(int32_t handle) {
    fx_mutex_body *m = slot_mut(handle);
    if (m == NULL) {
        return 1;
    }
#if defined(_WIN32)
    EnterCriticalSection(&m->cs);
#else
    if (pthread_mutex_lock(&m->mu) != 0) {
        return 1;
    }
#endif
    return 0;
}

int32_t fx_mutex_unlock(int32_t handle) {
    fx_mutex_body *m = slot_mut(handle);
    if (m == NULL) {
        return 1;
    }
#if defined(_WIN32)
    LeaveCriticalSection(&m->cs);
#else
    if (pthread_mutex_unlock(&m->mu) != 0) {
        return 1;
    }
#endif
    return 0;
}

int32_t fx_mutex_destroy(int32_t handle) {
    fx_mutex_body *m;
    int idx;
    if (handle < 1 || handle > FX_MUTEX_SLOTS) {
        return 1;
    }
    idx = handle - 1;
    if (!g_used[idx]) {
        return 1;
    }
    m = &g_slots[idx];
    m->alive = 0;
#if defined(_WIN32)
    DeleteCriticalSection(&m->cs);
#else
    (void)pthread_mutex_destroy(&m->mu);
#endif
    memset(m, 0, sizeof(*m));
    g_used[idx] = 0;
    return 0;
}
