/* fx-owned std_map module */
#include "map.h"
#include <string.h>
#include <stddef.h>

static inline size_t fx_std_map_map_hash(const char* s) {
    size_t h = (size_t)1469598103934665603ULL;
    while (*s) { h ^= (size_t)(unsigned char)(*s); h *= (size_t)1099511628211ULL; s++; }
    return h;
}

static inline size_t fx_std_map_map_slot(const char** keys, size_t cap, const char* key) {
    size_t mask = cap - 1;
    size_t i = fx_std_map_map_hash(key) & mask;
    while (keys[i] != NULL && strcmp(keys[i], key) != 0) { i = (i + 1) & mask; }
    return i;
}

static inline fx_Map_string_i32 fx_std_map_map_new(core_Allocator* a) {
    size_t cap = 16;
    const char** keys = (const char**)core_mem_alloc(a, cap * sizeof(const char*));
    int32_t* vals = (int32_t*)core_mem_alloc(a, cap * sizeof(int32_t));
    if (keys != NULL) { for (size_t i = 0; i < cap; i++) { keys[i] = NULL; } }
    return (fx_Map_string_i32){ .keys = keys, .vals = vals, .cap = cap, .len = 0 };
}

static inline fx_Map_string_i32 fx_std_map_map_insert(core_Allocator* a, fx_Map_string_i32 map, const char* key, int32_t value) {
    if ((map.len + 1) * 4 >= map.cap * 3) {
        size_t ncap = map.cap ? map.cap * 2 : 16;
        const char** nk = (const char**)core_mem_alloc(a, ncap * sizeof(const char*));
        int32_t* nv = (int32_t*)core_mem_alloc(a, ncap * sizeof(int32_t));
        if (nk == NULL || nv == NULL) { return map; }
        for (size_t i = 0; i < ncap; i++) { nk[i] = NULL; }
        for (size_t i = 0; i < map.cap; i++) {
            if (map.keys[i] != NULL) {
                size_t j = fx_std_map_map_slot(nk, ncap, map.keys[i]);
                nk[j] = map.keys[i];
                nv[j] = map.vals[i];
            }
        }
        map.keys = nk; map.vals = nv; map.cap = ncap;
    }
    size_t slot = fx_std_map_map_slot(map.keys, map.cap, key);
    if (map.keys[slot] == NULL) { map.keys[slot] = key; map.len = map.len + 1; }
    map.vals[slot] = value;
    return map;
}

/* FX-0.7.5-A2 - accumulate: existing key = slot add; miss = insert(delta). */
static inline fx_Map_string_i32 fx_std_map_map_add_i32(core_Allocator* a, fx_Map_string_i32 map, const char* key, int32_t delta) {
    if (map.cap != 0 && map.keys != NULL) {
        size_t slot = fx_std_map_map_slot(map.keys, map.cap, key);
        if (map.keys[slot] != NULL) {
            map.vals[slot] = map.vals[slot] + delta;
            return map;
        }
    }
    return fx_std_map_map_insert(a, map, key, delta);
}

static inline fx_std_map_Result_i32 fx_std_map_map_get(fx_Map_string_i32 map, const char* key) {
    if (map.cap != 0 && map.keys != NULL) {
        size_t slot = fx_std_map_map_slot(map.keys, map.cap, key);
        if (map.keys[slot] != NULL) {
            return (fx_std_map_Result_i32){ .tag = FX_RESULT_TAG_OK, .ok_val = map.vals[slot], .err_val = CORE_OK };
        }
    }
    return (fx_std_map_Result_i32){ .tag = FX_RESULT_TAG_ERR, .ok_val = 0, .err_val = CORE_ERR_INVALID_ARG };
}

static inline int32_t fx_std_map_map_contains(fx_Map_string_i32 map, const char* key) {
    if (map.cap == 0 || map.keys == NULL) { return 0; }
    size_t slot = fx_std_map_map_slot(map.keys, map.cap, key);
    return (map.keys[slot] != NULL) ? 1 : 0;
}

static inline fx_Map_string_i32 fx_std_map_map_remove(core_Allocator* a, fx_Map_string_i32 map, const char* key) {
    if (map.cap == 0 || map.keys == NULL) { return map; }
    size_t slot = fx_std_map_map_slot(map.keys, map.cap, key);
    if (map.keys[slot] == NULL) { return map; }
    size_t ncap = map.cap;
    const char** nk = (const char**)core_mem_alloc(a, ncap * sizeof(const char*));
    int32_t* nv = (int32_t*)core_mem_alloc(a, ncap * sizeof(int32_t));
    if (nk == NULL || nv == NULL) { return map; }
    for (size_t i = 0; i < ncap; i++) { nk[i] = NULL; }
    size_t nlen = 0;
    for (size_t i = 0; i < map.cap; i++) {
        if (map.keys[i] != NULL && i != slot) {
            size_t j = fx_std_map_map_slot(nk, ncap, map.keys[i]);
            nk[j] = map.keys[i];
            nv[j] = map.vals[i];
            nlen = nlen + 1;
        }
    }
    map.keys = nk; map.vals = nv; map.cap = ncap; map.len = nlen;
    return map;
}

/* FX-0.72-STD-1 - dense entry walk (occupied slots only; order = table order). */
static inline const char* fx_std_map_map_nth_key(fx_Map_string_i32 map, int32_t n) {
    if (n < 0 || map.keys == NULL || map.cap == 0) { return ""; }
    int32_t seen = 0;
    for (size_t i = 0; i < map.cap; i++) {
        if (map.keys[i] != NULL) {
            if (seen == n) { return map.keys[i]; }
            seen = seen + 1;
        }
    }
    return "";
}

static inline int32_t fx_std_map_map_nth_value(fx_Map_string_i32 map, int32_t n) {
    if (n < 0 || map.keys == NULL || map.cap == 0) { return 0; }
    int32_t seen = 0;
    for (size_t i = 0; i < map.cap; i++) {
        if (map.keys[i] != NULL) {
            if (seen == n) { return map.vals[i]; }
            seen = seen + 1;
        }
    }
    return 0;
}

/* fx: effects: alloc */
/* fx: fn new() -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_new(core_Allocator* __fx_heap) {
    /* fx: return ...; */
    return fx_std_map_map_new(__fx_heap);
}

/* fx: effects: alloc, mut */
/* fx: fn insert(m: Map<string, i32>, key: string, value: i32) -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_insert(core_Allocator* __fx_heap, fx_Map_string_i32 m, const char* key, int32_t value) {
    /* fx: return ...; */
    return fx_std_map_map_insert(__fx_heap, m, key, value);
}

/* fx: effects: alloc, mut */
/* fx: fn add_i32(m: Map<string, i32>, key: string, delta: i32) -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_add_i32(core_Allocator* __fx_heap, fx_Map_string_i32 m, const char* key, int32_t delta) {
    /* fx: return ...; */
    return fx_std_map_map_add_i32(__fx_heap, m, key, delta);
}

/* fx: effects: alloc, mut */
/* fx: fn remove(m: Map<string, i32>, key: string) -> Map<string, i32> */
fx_Map_string_i32 fx_std_map_remove(core_Allocator* __fx_heap, fx_Map_string_i32 m, const char* key) {
    /* fx: return ...; */
    return fx_std_map_map_remove(__fx_heap, m, key);
}

/* fx: fn get(m: Map<string, i32>, key: string) -> Result<i32, core_Err> */
fx_std_map_Result_i32 fx_std_map_get(fx_Map_string_i32 m, const char* key) {
    /* fx: return ...; */
    return fx_std_map_map_get(m, key);
}

/* fx: fn contains(m: Map<string, i32>, key: string) -> bool */
int32_t fx_std_map_contains(fx_Map_string_i32 m, const char* key) {
    /* fx: return ...; */
    return fx_std_map_map_contains(m, key);
}

/* fx: fn len(m: Map<string, i32>) -> i32 */
int32_t fx_std_map_len(fx_Map_string_i32 m) {
    /* fx: return ...; */
    return ((int32_t)(m).len);
}

/* fx: fn nth_key(m: Map<string, i32>, i: i32) -> string */
const char* fx_std_map_nth_key(fx_Map_string_i32 m, int32_t i) {
    /* fx: return ...; */
    return fx_std_map_map_nth_key(m, i);
}

/* fx: fn nth_value(m: Map<string, i32>, i: i32) -> i32 */
int32_t fx_std_map_nth_value(fx_Map_string_i32 m, int32_t i) {
    /* fx: return ...; */
    return fx_std_map_map_nth_value(m, i);
}

