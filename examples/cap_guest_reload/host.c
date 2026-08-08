/* FX-DYN-2 — reload-shaped guest sessions.
 *
 * Two independent sessions:
 *   begin → mint → run → end → stale deny
 *   begin → mint → run → end → stale deny
 * Proves throwaway/reload lifecycle without Soft-fx.
 *
 * Exit: 0 success · 1 internal · 3 guest reject · 5 denied
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>
#include <string.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_reload", "denied (cap)", FX_CAP_DENIED);
    }
    if (r.err_val == FX_CAP_IO_ERR) {
        return fx_cli_fail("cap_guest_reload", "io error", FX_CAP_IO_ERR);
    }
    return fx_cli_fail("cap_guest_reload", "guest rejected payload", (int)r.err_val);
}

static int one_session(const char *label, const char *path) {
    int64_t ctx;
    int64_t fs_h;
    fx_std_cap_FsCap fs;
    fx_guest_lib_Result_i32 r;
    int st;

    ctx = fx_guest_begin("fixtures", 4096);
    if (ctx == 0) {
        return fx_cli_fail("cap_guest_reload", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_reload", "mint_fscap failed", 1);
    }

    fs.handle = fs_h;
    r = fx_guest_lib_run(fs, path);
    if (r.tag != FX_RESULT_TAG_OK || r.ok_val != 42) {
        (void)fx_guest_end(ctx);
        fprintf(stderr, "cap_guest_reload: %s run failed\n", label);
        return fail_guest(r);
    }

    (void)fx_guest_end(ctx);

    st = fx_io_cap_read_file(fs_h, path);
    if (st != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_reload", "post-end read expected deny(5)", 1);
    }
    r = fx_guest_lib_run(fs, path);
    if (r.tag == FX_RESULT_TAG_OK || r.err_val != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_reload", "post-end guest run expected Err(5)", 1);
    }
    return 0;
}

int main(int argc, char **argv) {
    int rc;
    (void)argc;
    (void)argv;

    /* Session A */
    rc = one_session("session-a", "fixtures/ok.txt");
    if (rc != 0) {
        return rc;
    }
    /* Session B — fresh world after A was torn down (reload shape). */
    rc = one_session("session-b", "fixtures/ok.txt");
    if (rc != 0) {
        return rc;
    }
    return 0;
}
