/* AllocCap budget dogfood.
 *
 * Flow: guest_begin → mint_alloccap(64) → try_alloc(32) ok
 *       → try_alloc(48) deny(5) → guest_end → stale try_alloc deny(5).
 *
 * Exit: 0 success · 1 internal · 5 denied (expected on over-budget probes via Result)
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_alloc_budget", "denied (alloc cap)", FX_CAP_DENIED);
    }
    return fx_cli_fail("cap_alloc_budget", "guest error", (int)r.err_val);
}

static int run_budget_probe(void) {
    int64_t ctx;
    int64_t alloc_h;
    fx_std_cap_AllocCap a;
    fx_guest_lib_Result_i32 r;

    ctx = fx_guest_begin("fixtures", 4096);
    if (ctx == 0) {
        return fx_cli_fail("cap_alloc_budget", "guest_begin failed", 1);
    }
    alloc_h = fx_guest_mint_alloccap(ctx, 64);
    if (alloc_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_alloc_budget", "mint_alloccap failed", 1);
    }
    a.handle = alloc_h;

    /* Within budget. */
    r = fx_guest_lib_try_alloc(a, (int64_t)32);
    if (r.tag != FX_RESULT_TAG_OK || r.ok_val != 42) {
        (void)fx_guest_end(ctx);
        return fail_guest(r);
    }

    /* Over remaining budget (32 left, ask 48). */
    r = fx_guest_lib_try_alloc(a, (int64_t)48);
    if (r.tag == FX_RESULT_TAG_OK) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_alloc_budget", "over-budget expected Err", 1);
    }
    if (r.err_val != FX_CAP_DENIED) {
        (void)fx_guest_end(ctx);
        return fail_guest(r);
    }

    (void)fx_guest_end(ctx);

    /* Stale AllocCap after end. */
    r = fx_guest_lib_try_alloc(a, (int64_t)8);
    if (r.tag == FX_RESULT_TAG_OK) {
        return fx_cli_fail("cap_alloc_budget", "post-end alloc expected Err", 1);
    }
    if (r.err_val != FX_CAP_DENIED) {
        return fail_guest(r);
    }

    /* Direct C path also denies on tombstone. */
    if (fx_alloccap_alloc(alloc_h, 8) != 0) {
        return fx_cli_fail("cap_alloc_budget", "post-end C alloc expected 0", 1);
    }

    return 0;
}

int main(int argc, char **argv) {
    (void)argv;
    if (argc != 1) {
        return fx_cli_usage("usage: cap_alloc_budget");
    }
    return run_budget_probe();
}
