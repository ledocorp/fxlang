#include "../../host/concur/fx_task_nursery.h"

#include <stdint.h>
#include <stdio.h>

int64_t fx_async_nursery_create(void);
int64_t fx_async_slot_new(void);
int32_t fx_async_nursery_spawn_add(int64_t n, int64_t slot, int32_t value);
int32_t fx_async_nursery_join_all(int64_t n);
int32_t fx_async_slot_get(int64_t slot);
int32_t fx_async_nursery_destroy(int64_t n);

int main(void) {
    int64_t n = fx_async_nursery_create();
    int64_t s0 = fx_async_slot_new();
    int64_t s1 = fx_async_slot_new();
    int32_t rc;
    printf("n=%lld\n", (long long)n);
    rc = fx_async_nursery_spawn_add(n, s0, 20);
    printf("spawn0=%d\n", rc);
    rc = fx_async_nursery_spawn_add(n, s1, 22);
    printf("spawn1=%d\n", rc);
    rc = fx_async_nursery_join_all(n);
    printf("join=%d sum=%d\n", rc, fx_async_slot_get(s0) + fx_async_slot_get(s1));
    fx_async_nursery_destroy(n);
    return 0;
}
