/* Typed channel substrate - i32 + i64 payloads. */
#ifndef FX_CHAN_H
#define FX_CHAN_H

#include <stdint.h>

#define FX_CHAN_OK 0
#define FX_CHAN_ERR 1
#define FX_CHAN_CLOSED 7
#define FX_CHAN_FULL 8
#define FX_CHAN_EMPTY 9

typedef struct FxChan FxChan;

FxChan *fx_chan_create(int capacity);
void fx_chan_destroy(FxChan *c);
int fx_chan_send(FxChan *c, int32_t v);
int fx_chan_recv(FxChan *c, int32_t *out);
int fx_chan_send_i64(FxChan *c, int64_t v);
int fx_chan_recv_i64(FxChan *c, int64_t *out);
/* Non-blocking: OK, EMPTY, or CLOSED. */
int fx_chan_try_recv(FxChan *c, int32_t *out);
int fx_chan_close(FxChan *c);

#endif
