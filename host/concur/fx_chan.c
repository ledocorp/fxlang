/* Bounded channel (int64 elements) - mutex + cond. */
#include "fx_chan.h"

#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#ifndef WINVER
#define WINVER 0x0600
#endif
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0600
#endif
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
/* MinGW may omit Vista+ condvar protos unless WINVER is high enough at include time. */
#ifndef InitializeConditionVariable
VOID WINAPI InitializeConditionVariable(PCONDITION_VARIABLE ConditionVariable);
BOOL WINAPI SleepConditionVariableCS(PCONDITION_VARIABLE ConditionVariable,
    PCRITICAL_SECTION CriticalSection, DWORD dwMilliseconds);
VOID WINAPI WakeConditionVariable(PCONDITION_VARIABLE ConditionVariable);
VOID WINAPI WakeAllConditionVariable(PCONDITION_VARIABLE ConditionVariable);
#endif
#else
#include <pthread.h>
#endif

struct FxChan {
    int64_t *buf;
    int cap;
    int len;
    int head;
    int closed;
#ifdef _WIN32
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE not_empty;
    CONDITION_VARIABLE not_full;
#else
    pthread_mutex_t lock;
    pthread_cond_t not_empty;
    pthread_cond_t not_full;
#endif
};

FxChan *fx_chan_create(int capacity) {
    FxChan *c;
    if (capacity < 1) {
        capacity = 1;
    }
    c = (FxChan *)calloc(1, sizeof(FxChan));
    if (!c) {
        return NULL;
    }
    c->buf = (int64_t *)calloc((size_t)capacity, sizeof(int64_t));
    if (!c->buf) {
        free(c);
        return NULL;
    }
    c->cap = capacity;
#ifdef _WIN32
    InitializeCriticalSection(&c->lock);
    InitializeConditionVariable(&c->not_empty);
    InitializeConditionVariable(&c->not_full);
#else
    if (pthread_mutex_init(&c->lock, NULL) != 0) {
        free(c->buf);
        free(c);
        return NULL;
    }
    (void)pthread_cond_init(&c->not_empty, NULL);
    (void)pthread_cond_init(&c->not_full, NULL);
#endif
    return c;
}

void fx_chan_destroy(FxChan *c) {
    if (!c) {
        return;
    }
#ifdef _WIN32
    DeleteCriticalSection(&c->lock);
#else
    (void)pthread_mutex_destroy(&c->lock);
    (void)pthread_cond_destroy(&c->not_empty);
    (void)pthread_cond_destroy(&c->not_full);
#endif
    free(c->buf);
    free(c);
}

int fx_chan_send_i64(FxChan *c, int64_t v) {
    if (!c) {
        return FX_CHAN_ERR;
    }
#ifdef _WIN32
    EnterCriticalSection(&c->lock);
    while (c->len >= c->cap && !c->closed) {
        SleepConditionVariableCS(&c->not_full, &c->lock, INFINITE);
    }
    if (c->closed) {
        LeaveCriticalSection(&c->lock);
        return FX_CHAN_CLOSED;
    }
    c->buf[(c->head + c->len) % c->cap] = v;
    c->len++;
    WakeConditionVariable(&c->not_empty);
    LeaveCriticalSection(&c->lock);
#else
    (void)pthread_mutex_lock(&c->lock);
    while (c->len >= c->cap && !c->closed) {
        (void)pthread_cond_wait(&c->not_full, &c->lock);
    }
    if (c->closed) {
        (void)pthread_mutex_unlock(&c->lock);
        return FX_CHAN_CLOSED;
    }
    c->buf[(c->head + c->len) % c->cap] = v;
    c->len++;
    (void)pthread_cond_signal(&c->not_empty);
    (void)pthread_mutex_unlock(&c->lock);
#endif
    return FX_CHAN_OK;
}

int fx_chan_recv_i64(FxChan *c, int64_t *out) {
    int64_t v;
    if (!c || !out) {
        return FX_CHAN_ERR;
    }
#ifdef _WIN32
    EnterCriticalSection(&c->lock);
    while (c->len == 0 && !c->closed) {
        SleepConditionVariableCS(&c->not_empty, &c->lock, INFINITE);
    }
    if (c->len == 0 && c->closed) {
        LeaveCriticalSection(&c->lock);
        return FX_CHAN_CLOSED;
    }
    v = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->len--;
    WakeConditionVariable(&c->not_full);
    LeaveCriticalSection(&c->lock);
#else
    (void)pthread_mutex_lock(&c->lock);
    while (c->len == 0 && !c->closed) {
        (void)pthread_cond_wait(&c->not_empty, &c->lock);
    }
    if (c->len == 0 && c->closed) {
        (void)pthread_mutex_unlock(&c->lock);
        return FX_CHAN_CLOSED;
    }
    v = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->len--;
    (void)pthread_cond_signal(&c->not_full);
    (void)pthread_mutex_unlock(&c->lock);
#endif
    *out = v;
    return FX_CHAN_OK;
}

int fx_chan_send(FxChan *c, int32_t v) {
    return fx_chan_send_i64(c, (int64_t)v);
}

int fx_chan_recv(FxChan *c, int32_t *out) {
    int64_t v = 0;
    int st;
    if (!out) {
        return FX_CHAN_ERR;
    }
    st = fx_chan_recv_i64(c, &v);
    if (st == FX_CHAN_OK) {
        *out = (int32_t)v;
    }
    return st;
}

int fx_chan_try_recv(FxChan *c, int32_t *out) {
    int64_t v;
    if (!c || !out) {
        return FX_CHAN_ERR;
    }
#ifdef _WIN32
    EnterCriticalSection(&c->lock);
    if (c->len == 0) {
        int rc = c->closed ? FX_CHAN_CLOSED : FX_CHAN_EMPTY;
        LeaveCriticalSection(&c->lock);
        return rc;
    }
    v = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->len--;
    WakeConditionVariable(&c->not_full);
    LeaveCriticalSection(&c->lock);
#else
    (void)pthread_mutex_lock(&c->lock);
    if (c->len == 0) {
        int rc = c->closed ? FX_CHAN_CLOSED : FX_CHAN_EMPTY;
        (void)pthread_mutex_unlock(&c->lock);
        return rc;
    }
    v = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->len--;
    (void)pthread_cond_signal(&c->not_full);
    (void)pthread_mutex_unlock(&c->lock);
#endif
    *out = (int32_t)v;
    return FX_CHAN_OK;
}

int fx_chan_close(FxChan *c) {
    if (!c) {
        return FX_CHAN_ERR;
    }
#ifdef _WIN32
    EnterCriticalSection(&c->lock);
    c->closed = 1;
    WakeAllConditionVariable(&c->not_empty);
    WakeAllConditionVariable(&c->not_full);
    LeaveCriticalSection(&c->lock);
#else
    (void)pthread_mutex_lock(&c->lock);
    c->closed = 1;
    (void)pthread_cond_broadcast(&c->not_empty);
    (void)pthread_cond_broadcast(&c->not_full);
    (void)pthread_mutex_unlock(&c->lock);
#endif
    return FX_CHAN_OK;
}
