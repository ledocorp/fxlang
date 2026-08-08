/* FX-DYN-4 — compose FsCap + AllocCap; reload sessions under budget.
 *
 * Per session:
 *   begin → mint_fs + mint_alloc(64) → run(ok) → try_alloc(48) deny
 *   → end → stale fs + alloc deny
 * Two sessions prove reload independence.
 *
 * Exit: 0 success · 1 internal · 3 guest reject · 5 denied
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_compose", "denied (cap)", FX_CAP_DENIED);
    }
    if (r.err_val == FX_CAP_IO_ERR) {
        return fx_cli_fail("cap_guest_compose", "io error", FX_CAP_IO_ERR);
    }
    return fx_cli_fail("cap_guest_compose", "guest rejected payload", (int)r.err_val);
}

static int one_session(const char *label, const char *path) {
    int64_t ctx;
    int64_t fs_h;
    int64_t alloc_h;
    fx_std_cap_FsCap fs;
    fx_std_cap_AllocCap a;
    fx_guest_lib_Result_i32 r;
    int st;

    ctx = fx_guest_begin("fixtures", 4096);
    if (ctx == 0) {
        return fx_cli_fail("cap_guest_compose", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_compose", "mint_fscap failed", 1);
    }
    alloc_h = fx_guest_mint_alloccap(ctx, 64);
    if (alloc_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_compose", "mint_alloccap failed", 1);
    }

    fs.handle = fs_h;
    a.handle = alloc_h;

    r = fx_guest_lib_run(fs, a, path);
    if (r.tag != FX_RESULT_TAG_OK || r.ok_val != 42) {
        (void)fx_guest_end(ctx);
        fprintf(stderr, "cap_guest_compose: %s run failed\n", label);
        return fail_guest(r);
    }

    /* 16 used in run; 48 > remaining 48? remaining=48, ask 48 ok actually.
     * Budget 64, used 16, remaining 48. Ask 49 to force deny. */
    r = fx_guest_lib_try_alloc(a, (int64_t)49);
    if (r.tag == FX_RESULT_TAG_OK) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_compose", "over-budget expected Err", 1);
    }
    if (r.err_val != FX_CAP_DENIED) {
        (void)fx_guest_end(ctx);
        return fail_guest(r);
    }

    (void)fx_guest_end(ctx);

    st = fx_io_cap_read_file(fs_h, path);
    if (st != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_compose", "post-end fs read expected deny(5)", 1);
    }
    r = fx_guest_lib_try_alloc(a, (int64_t)8);
    if (r.tag == FX_RESULT_TAG_OK || r.err_val != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_compose", "post-end alloc expected Err(5)", 1);
    }
    r = fx_guest_lib_run(fs, a, path);
    if (r.tag == FX_RESULT_TAG_OK || r.err_val != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_compose", "post-end compose run expected Err(5)", 1);
    }
    return 0;
}

int main(int argc, char **argv) {
    int rc;
    (void)argc;
    (void)argv;

    rc = one_session("session-a", "fixtures/ok.txt");
    if (rc != 0) {
        return rc;
    }
    rc = one_session("session-b", "fixtures/ok.txt");
    if (rc != 0) {
        return rc;
    }
    return 0;
}
