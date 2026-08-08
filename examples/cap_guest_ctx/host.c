/* FX-DYN Phase B.1 — guest context host.
 *
 * Flow: guest_begin(root) → mint FsCap → guest run → guest_end
 *       → second io_cap call with stale handle denies (exit 5).
 *
 * Usage: prog                 — full session + teardown deny probe
 *        prog fixtures/ok.txt — single run under live context (exit 0)
 * Exit: 0 success · 1 usage/internal · 2 io · 3 guest reject · 5 denied
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>
#include <string.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_ctx", "denied (cap)", FX_CAP_DENIED);
    }
    if (r.err_val == FX_CAP_IO_ERR) {
        return fx_cli_fail("cap_guest_ctx", "io error", FX_CAP_IO_ERR);
    }
    return fx_cli_fail("cap_guest_ctx", "guest rejected payload", (int)r.err_val);
}

static int run_under_ctx(const char *path) {
    int64_t ctx;
    int64_t fs_h;
    int64_t scratch;
    fx_std_cap_FsCap fs;
    fx_guest_lib_Result_i32 r;

    ctx = fx_guest_begin("fixtures", 0);
    if (ctx == 0) {
        return fx_cli_fail("cap_guest_ctx", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_ctx", "mint_fscap failed", 1);
    }
    scratch = fx_guest_alloc(ctx, 64);
    if (scratch == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_ctx", "guest_alloc failed", 1);
    }
    (void)scratch;

    fs.handle = fs_h;
    r = fx_guest_lib_run(fs, path);
    (void)fx_guest_end(ctx);

    if (r.tag != FX_RESULT_TAG_OK) {
        return fail_guest(r);
    }
    if (r.ok_val != 42) {
        return fx_cli_fail("cap_guest_ctx", "unexpected score", 1);
    }
    return 0;
}

/* Default: prove begin → run → end → stale handle deny. */
static int run_teardown_probe(void) {
    int64_t ctx;
    int64_t fs_h;
    fx_std_cap_FsCap fs;
    fx_guest_lib_Result_i32 r;
    int st;

    ctx = fx_guest_begin("fixtures", 4096);
    if (ctx == 0) {
        return fx_cli_fail("cap_guest_ctx", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("cap_guest_ctx", "mint_fscap failed", 1);
    }

    fs.handle = fs_h;
    r = fx_guest_lib_run(fs, "fixtures/ok.txt");
    if (r.tag != FX_RESULT_TAG_OK || r.ok_val != 42) {
        (void)fx_guest_end(ctx);
        return fail_guest(r);
    }

    (void)fx_guest_end(ctx);

    /* Stale FsCap after end: host io_cap path must deny (tombstone live==0). */
    st = fx_io_cap_read_file(fs_h, "fixtures/ok.txt");
    if (st != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_ctx", "post-end read expected deny(5)", 1);
    }

    /* Guest entry with revoked handle must also surface Err(5). */
    r = fx_guest_lib_run(fs, "fixtures/ok.txt");
    if (r.tag == FX_RESULT_TAG_OK) {
        return fx_cli_fail("cap_guest_ctx", "post-end guest run expected Err", 1);
    }
    if (r.err_val != FX_CAP_DENIED) {
        return fail_guest(r);
    }
    return 0;
}

int main(int argc, char **argv) {
    if (argc == 1) {
        return run_teardown_probe();
    }
    if (argc == 2) {
        return run_under_ctx(argv[1]);
    }
    return fx_cli_usage("usage: cap_guest_ctx [file]");
}
