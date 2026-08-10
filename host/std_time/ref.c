/* thin wall-clock / sleep / seeded rand (host shim). */
#if !defined(_WIN32)
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200809L
#endif
#endif

#include <stdint.h>
#include <stdlib.h>

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <time.h>
#endif

int64_t fx_time_now_ms(void) {
#if defined(_WIN32)
    FILETIME ft;
    ULARGE_INTEGER u;
    GetSystemTimeAsFileTime(&ft);
    u.LowPart = ft.dwLowDateTime;
    u.HighPart = ft.dwHighDateTime;
    /* 100ns ticks since 1601-01-01 → ms since Unix epoch */
    return (int64_t)((u.QuadPart / 10000ULL) - 11644473600000ULL);
#else
    struct timespec ts;
    if (clock_gettime(CLOCK_REALTIME, &ts) != 0) {
        return 0;
    }
    return (int64_t)ts.tv_sec * 1000LL + (int64_t)ts.tv_nsec / 1000000LL;
#endif
}

void fx_time_sleep_ms(int32_t ms) {
    if (ms <= 0) {
        return;
    }
#if defined(_WIN32)
    Sleep((DWORD)ms);
#else
    struct timespec ts;
    ts.tv_sec = (time_t)(ms / 1000);
    ts.tv_nsec = (long)(ms % 1000) * 1000000L;
    (void)nanosleep(&ts, NULL);
#endif
}

/* Deterministic LCG step (not crypto). seed=0 maps to 1. */
int32_t fx_rand_next(int32_t state) {
    uint32_t x = (uint32_t)state;
    if (x == 0u) {
        x = 1u;
    }
    x = x * 1664525u + 1013904223u;
    return (int32_t)(x & 0x7fffffffu);
}
