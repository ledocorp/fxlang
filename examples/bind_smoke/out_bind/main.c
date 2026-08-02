/* fx bootstrap emit: main body_len=1 */
#include <stdint.h>

int32_t smoke_add(int32_t a, int32_t b);

int32_t fx_main_main(void) {
    return smoke_add(10, 32);
}
