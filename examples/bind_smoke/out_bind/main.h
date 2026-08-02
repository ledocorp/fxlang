#ifndef FX_MAIN_H
#define FX_MAIN_H

#include <stdint.h>

/* extern "c" */
/* fx: extern fn smoke_add(a: i32, b: i32) -> i32 */
int32_t smoke_add(int32_t a, int32_t b);


/* fx: fn main() -> i32 */
int32_t fx_main_main(void);


#endif /* FX_MAIN_H */
