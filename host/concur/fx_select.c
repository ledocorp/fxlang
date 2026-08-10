/* Feature macros must precede all includes under gcc -std=c11 (WSL IR COVER). */
#if !defined(_WIN32)
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200809L
#endif
#endif

#include "fx_select.h"

#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#else
#include <time.h>
#endif

int fx_select_recv2(FxChan *a, FxChan *b, int32_t *out, int *which, uint32_t timeout_ms) {
    uint32_t waited = 0;
    if (!out || !which) {
        return FX_SEL_ERR;
    }
    while (waited <= timeout_ms) {
        if (a) {
            int rc = fx_chan_try_recv(a, out);
            if (rc == FX_CHAN_OK) {
                *which = 0;
                return FX_SEL_OK;
            }
        }
        if (b) {
            int rc = fx_chan_try_recv(b, out);
            if (rc == FX_CHAN_OK) {
                *which = 1;
                return FX_SEL_OK;
            }
        }
        if (timeout_ms == 0) {
            break;
        }
#ifdef _WIN32
        Sleep(1);
#else
        {
            struct timespec ts;
            ts.tv_sec = 0;
            ts.tv_nsec = 1000000L; /* 1 ms */
            (void)nanosleep(&ts, NULL);
        }
#endif
        waited += 1;
    }
    return FX_SEL_TIMEOUT;
}
