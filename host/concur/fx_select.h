/* Wait-any on two channels or timeout (CONCUR-4 foothold). */
#ifndef FX_SELECT_H
#define FX_SELECT_H

#include "fx_chan.h"
#include <stdint.h>

#define FX_SEL_OK 0
#define FX_SEL_ERR 1
#define FX_SEL_TIMEOUT 5

/* Try recv from a then b without blocking forever; timeout_ms for poll loop. */
int fx_select_recv2(FxChan *a, FxChan *b, int32_t *out, int *which, uint32_t timeout_ms);

#endif
