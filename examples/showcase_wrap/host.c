/* C host over fx compute (score → 42). */
#include "compute.h"

int main(void) {
    int32_t s = fx_compute_score(20, 2);
    int32_t c = fx_compute_clamp01(s);
    if (c != 42) {
        return 1;
    }
    return (int)c;
}
