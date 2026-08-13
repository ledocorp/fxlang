#ifndef FX_VEC_TYPES_H
#define FX_VEC_TYPES_H

#include <stddef.h>
#include <stdint.h>

typedef struct {
    const char** keys;
    int32_t* vals;
    size_t cap;
    size_t len;
} fx_Map_string_i32;

#endif /* FX_VEC_TYPES_H */
