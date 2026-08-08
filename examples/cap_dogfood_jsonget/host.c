/* FX-DYN-6 — App 2 (jsonget) under guest FsCap session.
 *
 * Flow: begin → mint_fs(fixtures) → run(sample.json) → 42
 *       → escape path deny(5) → end → stale deny(5)
 *       → second session proves reload independence.
 *
 * Exit: 0 success · 1 internal · 3 guest reject · 5 denied
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_dogfood_jsonget", "denied (cap)", FX_CAP_DENIED);
    }
    if (r.err_val == FX_CAP_IO_ERR) {
        return fx_cli_fail("cap_dogfood_jsonget", "io error", FX_CAP_IO_ERR);
    }
    return fx_cli_fail("cap_dogfood_jsonget", "guest rejected payload", (int)r.err_val);
}

static int one_session(const char *label) {
    int64_t ctx;
    int64_t fs_h;
    fx_std_cap_FsCap fs;
    fx_guest_lib_Result_i32 r;
    int st;

    ctx = fx_guest_begin("fixtures", 65536);
    if (ctx == 0) {
        return fx_cli_fail("cap_dogfood_jsonget", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_dogfood_jsonget", "mint_fscap failed", 1);
    }
    fs.handle = fs_h;

    r = fx_guest_lib_run(fs, "fixtures/sample.json");
    if (r.tag != FX_RESULT_TAG_OK || r.ok_val != 42) {
        (void)fx_guest_end(ctx);
        fprintf(stderr, "cap_dogfood_jsonget: %s run failed\n", label);
        return fail_guest(r);
    }

    /* Escape root — must deny before guest sees bytes. */
    r = fx_guest_lib_run(fs, "../secret.json");
    if (r.tag == FX_RESULT_TAG_OK || r.err_val != FX_CAP_DENIED) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_dogfood_jsonget", "escape path expected Err(5)", 1);
    }

    (void)fx_guest_end(ctx);

    st = fx_io_cap_read_file(fs_h, "fixtures/sample.json");
    if (st != FX_CAP_DENIED) {
        return fx_cli_fail("cap_dogfood_jsonget", "post-end read expected deny(5)", 1);
    }
    r = fx_guest_lib_run(fs, "fixtures/sample.json");
    if (r.tag == FX_RESULT_TAG_OK || r.err_val != FX_CAP_DENIED) {
        return fx_cli_fail("cap_dogfood_jsonget", "post-end run expected Err(5)", 1);
    }
    return 0;
}

int main(int argc, char **argv) {
    int rc;
    (void)argc;
    (void)argv;

    rc = one_session("session-a");
    if (rc != 0) {
        return rc;
    }
    rc = one_session("session-b");
    if (rc != 0) {
        return rc;
    }
    return 0;
}
