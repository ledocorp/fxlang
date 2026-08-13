#ifndef FX_STD_MAP_H
#define FX_STD_MAP_H

#include <stdint.h>

#include "../fx_vec.h"

#include "zspec/core.h"

#define FX_RESULT_TAG_OK 0
#define FX_RESULT_TAG_ERR 1

typedef struct {
    int32_t tag;
    int32_t ok_val;
    core_Err err_val;
} fx_std_map_Result_i32;

/* fx: effects: alloc */
/* fx: fn new() -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_new(core_Allocator* __fx_heap);

/* fx: effects: alloc, mut */
/* fx: fn insert(m: Map<string, i32>, key: string, value: i32) -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_insert(core_Allocator* __fx_heap, fx_Map_string_i32 m, const char* key, int32_t value);

/* fx: effects: alloc, mut */
/* fx: fn add_i32(m: Map<string, i32>, key: string, delta: i32) -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_add_i32(core_Allocator* __fx_heap, fx_Map_string_i32 m, const char* key, int32_t delta);

/* fx: effects: alloc, mut */
/* fx: fn remove(m: Map<string, i32>, key: string) -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_remove(core_Allocator* __fx_heap, fx_Map_string_i32 m, const char* key);

/* fx: fn get(m: Map<string, i32>, key: string) -> Result<i32, core_Err> */
fx_std_map_Result_i32 fx_std_map_get(fx_Map_string_i32 m, const char* key);

/* fx: fn contains(m: Map<string, i32>, key: string) -> bool */
int32_t fx_std_map_contains(fx_Map_string_i32 m, const char* key);

/* fx: fn len(m: Map<string, i32>) -> i32 */
int32_t fx_std_map_len(fx_Map_string_i32 m);

/* fx: fn nth_key(m: Map<string, i32>, i: i32) -> string */
const char* fx_std_map_nth_key(fx_Map_string_i32 m, int32_t i);

/* fx: fn nth_value(m: Map<string, i32>, i: i32) -> i32 */
int32_t fx_std_map_nth_value(fx_Map_string_i32 m, int32_t i);


#endif /* FX_STD_MAP_H */
