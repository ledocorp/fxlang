/* Bridge: i64 handles for std/nursery + chan/select/mailbox/supervise facades. */
#include "fx_task_nursery.h"
#include "fx_chan.h"
#include "fx_select.h"
#include "fx_mailbox.h"
#include "fx_supervise.h"

#include <stdint.h>
#include <stdlib.h>

typedef struct {
    int64_t value;
} FxAsyncSlot;

typedef struct {
    FxAsyncSlot *slot;
    int32_t value;
} FxAsyncStoreArg;

typedef struct {
    FxChan *chan;
    int32_t value;
} FxAsyncSendArg;

typedef struct {
    FxMailbox *mb;
    int32_t value;
} FxAsyncMbSendArg;

static void fx_async_store_task(void *p) {
    FxAsyncStoreArg *a = (FxAsyncStoreArg *)p;
    if (a && a->slot) {
        a->slot->value = (int64_t)a->value;
    }
    free(a);
}

static void fx_async_send_task(void *p) {
    FxAsyncSendArg *a = (FxAsyncSendArg *)p;
    if (a && a->chan) {
        (void)fx_chan_send(a->chan, a->value);
    }
    free(a);
}

static void fx_async_mb_send_task(void *p) {
    FxAsyncMbSendArg *a = (FxAsyncMbSendArg *)p;
    if (a && a->mb) {
        (void)fx_mb_send(a->mb, a->value);
    }
    free(a);
}

int64_t fx_async_nursery_create(void) {
    return (int64_t)(intptr_t)fx_nursery_create();
}

int64_t fx_async_nursery_create_sized(int32_t max_tasks) {
    return (int64_t)(intptr_t)fx_nursery_create_sized((int)max_tasks);
}

int64_t fx_async_slot_new(void) {
    FxAsyncSlot *s = (FxAsyncSlot *)calloc(1, sizeof(FxAsyncSlot));
    return (int64_t)(intptr_t)s;
}

int32_t fx_async_nursery_spawn_add(int64_t n_h, int64_t slot_h, int32_t value) {
    FxNursery *n = (FxNursery *)(intptr_t)n_h;
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    FxAsyncStoreArg *arg;
    if (!n || !s) {
        return FX_NURSERY_ERR;
    }
    arg = (FxAsyncStoreArg *)malloc(sizeof(FxAsyncStoreArg));
    if (!arg) {
        return FX_NURSERY_ERR;
    }
    arg->slot = s;
    arg->value = value;
    return fx_nursery_spawn(n, fx_async_store_task, arg);
}

int32_t fx_async_nursery_spawn_send(int64_t n_h, int64_t chan_h, int32_t value) {
    FxNursery *n = (FxNursery *)(intptr_t)n_h;
    FxChan *c = (FxChan *)(intptr_t)chan_h;
    FxAsyncSendArg *arg;
    if (!n || !c) {
        return FX_NURSERY_ERR;
    }
    arg = (FxAsyncSendArg *)malloc(sizeof(FxAsyncSendArg));
    if (!arg) {
        return FX_NURSERY_ERR;
    }
    arg->chan = c;
    arg->value = value;
    return fx_nursery_spawn(n, fx_async_send_task, arg);
}

int32_t fx_async_nursery_spawn_mb_send(int64_t n_h, int64_t mb_h, int32_t value) {
    FxNursery *n = (FxNursery *)(intptr_t)n_h;
    FxMailbox *m = (FxMailbox *)(intptr_t)mb_h;
    FxAsyncMbSendArg *arg;
    if (!n || !m) {
        return FX_NURSERY_ERR;
    }
    arg = (FxAsyncMbSendArg *)malloc(sizeof(FxAsyncMbSendArg));
    if (!arg) {
        return FX_NURSERY_ERR;
    }
    arg->mb = m;
    arg->value = value;
    return fx_nursery_spawn(n, fx_async_mb_send_task, arg);
}

int32_t fx_async_nursery_join_all(int64_t n_h) {
    return fx_nursery_join_all((FxNursery *)(intptr_t)n_h);
}

int32_t fx_async_nursery_join_all_timeout(int64_t n_h, int32_t timeout_ms) {
    return fx_nursery_join_all_timeout((FxNursery *)(intptr_t)n_h, (uint32_t)timeout_ms);
}

int32_t fx_async_nursery_request_cancel(int64_t n_h) {
    return fx_nursery_request_cancel((FxNursery *)(intptr_t)n_h);
}

int32_t fx_async_nursery_shutdown(int64_t n_h) {
    return fx_nursery_shutdown((FxNursery *)(intptr_t)n_h);
}

int32_t fx_async_nursery_destroy(int64_t n_h) {
    FxNursery *n = (FxNursery *)(intptr_t)n_h;
    fx_nursery_destroy(n);
    return 0;
}

int32_t fx_async_nursery_pending(int64_t n_h) {
    return fx_nursery_pending((FxNursery *)(intptr_t)n_h);
}

int32_t fx_async_slot_get(int64_t slot_h) {
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    if (!s) {
        return 0;
    }
    return (int32_t)s->value;
}

int64_t fx_async_slot_get_i64(int64_t slot_h) {
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    if (!s) {
        return 0;
    }
    return s->value;
}

int32_t fx_async_slot_set(int64_t slot_h, int32_t v) {
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    if (!s) {
        return FX_NURSERY_ERR;
    }
    s->value = (int64_t)v;
    return 0;
}

/* ---- channels ---- */

int64_t fx_async_chan_create(int32_t capacity) {
    return (int64_t)(intptr_t)fx_chan_create((int)capacity);
}

int32_t fx_async_chan_destroy(int64_t h) {
    fx_chan_destroy((FxChan *)(intptr_t)h);
    return 0;
}

int32_t fx_async_chan_send(int64_t h, int32_t v) {
    return fx_chan_send((FxChan *)(intptr_t)h, v);
}

int32_t fx_async_chan_send_i64(int64_t h, int64_t v) {
    return fx_chan_send_i64((FxChan *)(intptr_t)h, v);
}

int32_t fx_async_chan_recv_slot(int64_t h, int64_t slot_h) {
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    int32_t v = 0;
    int st;
    if (!s) {
        return FX_CHAN_ERR;
    }
    st = fx_chan_recv((FxChan *)(intptr_t)h, &v);
    if (st == FX_CHAN_OK) {
        s->value = (int64_t)v;
    }
    return st;
}

int32_t fx_async_chan_recv_i64_slot(int64_t h, int64_t slot_h) {
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    int64_t v = 0;
    int st;
    if (!s) {
        return FX_CHAN_ERR;
    }
    st = fx_chan_recv_i64((FxChan *)(intptr_t)h, &v);
    if (st == FX_CHAN_OK) {
        s->value = v;
    }
    return st;
}

int32_t fx_async_chan_close(int64_t h) {
    return fx_chan_close((FxChan *)(intptr_t)h);
}

/* ---- select ---- */

int32_t fx_async_select_recv2_slots(
    int64_t a_h,
    int64_t b_h,
    int64_t value_slot,
    int64_t which_slot,
    int32_t timeout_ms) {
    FxAsyncSlot *vs = (FxAsyncSlot *)(intptr_t)value_slot;
    FxAsyncSlot *ws = (FxAsyncSlot *)(intptr_t)which_slot;
    int32_t v = 0;
    int which = -1;
    int st;
    if (!vs || !ws) {
        return FX_SEL_ERR;
    }
    st = fx_select_recv2(
        (FxChan *)(intptr_t)a_h,
        (FxChan *)(intptr_t)b_h,
        &v,
        &which,
        (uint32_t)timeout_ms);
    if (st == FX_SEL_OK) {
        vs->value = (int64_t)v;
        ws->value = (int64_t)which;
    }
    return (int32_t)st;
}

/* ---- mailbox ---- */

int64_t fx_async_mb_create(int32_t capacity) {
    return (int64_t)(intptr_t)fx_mb_create((int)capacity);
}

int32_t fx_async_mb_destroy(int64_t h) {
    fx_mb_destroy((FxMailbox *)(intptr_t)h);
    return 0;
}

int32_t fx_async_mb_send(int64_t h, int32_t v) {
    return fx_mb_send((FxMailbox *)(intptr_t)h, v);
}

int32_t fx_async_mb_recv_slot(int64_t h, int64_t slot_h) {
    FxAsyncSlot *s = (FxAsyncSlot *)(intptr_t)slot_h;
    int32_t v = 0;
    int st;
    if (!s) {
        return FX_MB_ERR;
    }
    st = fx_mb_recv((FxMailbox *)(intptr_t)h, &v);
    if (st == FX_MB_OK) {
        s->value = (int64_t)v;
    }
    return st;
}

int32_t fx_async_mb_close(int64_t h) {
    return fx_mb_close((FxMailbox *)(intptr_t)h);
}

/* ---- supervise ---- */

int32_t fx_async_supervise_normalize(int32_t policy) {
    return fx_supervise_normalize_policy((int)policy);
}

int32_t fx_async_supervise_apply(int64_t n_h, int32_t policy, int32_t child_ok) {
    return fx_supervise_apply((FxNursery *)(intptr_t)n_h, (int)policy, (int)child_ok);
}
