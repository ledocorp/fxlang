/* Mailbox = channel with same substrate (CONCUR-5 foothold). */
#include "fx_mailbox.h"
#include "fx_chan.h"

#include <stdlib.h>

struct FxMailbox {
    FxChan *ch;
};

FxMailbox *fx_mb_create(int capacity) {
    FxMailbox *m = (FxMailbox *)calloc(1, sizeof(FxMailbox));
    if (!m) {
        return NULL;
    }
    m->ch = fx_chan_create(capacity);
    if (!m->ch) {
        free(m);
        return NULL;
    }
    return m;
}

void fx_mb_destroy(FxMailbox *m) {
    if (!m) {
        return;
    }
    fx_chan_destroy(m->ch);
    free(m);
}

int fx_mb_send(FxMailbox *m, int32_t v) {
    if (!m) {
        return FX_MB_ERR;
    }
    return fx_chan_send(m->ch, v);
}

int fx_mb_recv(FxMailbox *m, int32_t *out) {
    if (!m) {
        return FX_MB_ERR;
    }
    return fx_chan_recv(m->ch, out);
}

int fx_mb_close(FxMailbox *m) {
    if (!m) {
        return FX_MB_ERR;
    }
    return fx_chan_close(m->ch);
}
