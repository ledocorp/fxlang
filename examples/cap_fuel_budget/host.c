/* FuelCap unit budget dogfood.
 *
 * Flow: guest_begin → mint_fuelcap(10) → try_burn(4) ok
 *       → try_burn(8) deny(5) → guest_end → stale try_burn deny(5).
 *
 * Exit: 0 success · 1 internal · 5 denied (via Result on over-fuel probes)
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_fuel_budget", "denied (fuel cap)", FX_CAP_DENIED);
    }
    return fx_cli_fail("cap_fuel_budget", "guest error", (int)r.err_val);
}

static int run_fuel_probe(void) {
    int64_t ctx;
    int64_t fuel_h;
    fx_std_cap_FuelCap f;
    fx_guest_lib_Result_i32 r;

    ctx = fx_guest_begin("fixtures", 4096);
    if (ctx == 0) {
        return fx_cli_fail("cap_fuel_budget", "guest_begin failed", 1);
    }
    fuel_h = fx_guest_mint_fuelcap(ctx, 10);
    if (fuel_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_fuel_budget", "mint_fuelcap failed", 1);
    }
    f.handle = fuel_h;

    /* Within budget. */
    r = fx_guest_lib_try_burn(f, (int64_t)4);
    if (r.tag != FX_RESULT_TAG_OK || r.ok_val != 42) {
        (void)fx_guest_end(ctx);
        return fail_guest(r);
    }

    /* Over remaining (6 left, ask 8). */
    r = fx_guest_lib_try_burn(f, (int64_t)8);
    if (r.tag == FX_RESULT_TAG_OK) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_fuel_budget", "over-fuel expected Err", 1);
    }
    if (r.err_val != FX_CAP_DENIED) {
        (void)fx_guest_end(ctx);
        return fail_guest(r);
    }

    (void)fx_guest_end(ctx);

    /* Stale FuelCap after end. */
    r = fx_guest_lib_try_burn(f, (int64_t)1);
    if (r.tag == FX_RESULT_TAG_OK) {
        return fx_cli_fail("cap_fuel_budget", "post-end burn expected Err", 1);
    }
    if (r.err_val != FX_CAP_DENIED) {
        return fail_guest(r);
    }

    if (fx_fuelcap_burn(fuel_h, 1) != 0) {
        return fx_cli_fail("cap_fuel_budget", "post-end C burn expected 0", 1);
    }

    return 0;
}

int main(int argc, char **argv) {
    (void)argv;
    if (argc != 1) {
        return fx_cli_usage("usage: cap_fuel_budget");
    }
    return run_fuel_probe();
}
