#ifndef FX_MUTEX_H
#define FX_MUTEX_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Slot ids are 1..N (0 = invalid). i32 avoids emit-C i64 truncation. */
int32_t fx_mutex_create(void);
int32_t fx_mutex_lock(int32_t handle);
int32_t fx_mutex_unlock(int32_t handle);
int32_t fx_mutex_destroy(int32_t handle);

#ifdef __cplusplus
}
#endif

#endif /* FX_MUTEX_H */
