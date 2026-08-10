/* Per-task i32 mailbox foothold (CONCUR-5). */
#ifndef FX_MAILBOX_H
#define FX_MAILBOX_H

#include <stdint.h>

#define FX_MB_OK 0
#define FX_MB_ERR 1
#define FX_MB_CLOSED 7

typedef struct FxMailbox FxMailbox;

FxMailbox *fx_mb_create(int capacity);
void fx_mb_destroy(FxMailbox *m);
int fx_mb_send(FxMailbox *m, int32_t v);
int fx_mb_recv(FxMailbox *m, int32_t *out);
int fx_mb_close(FxMailbox *m);

#endif
