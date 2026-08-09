/* extension host: mint FsCap + OutCap; guest performs cap I/O.
 *
 * Usage: prog <file>         - read/score + write status under fixtures
 *        prog --write-deny   - write outside root → exit 5
 * Exit: 0 success · 1 usage · 2 io · 3 guest reject · 5 denied
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>
#include <string.h>

static int fail_guest(fx_guest_lib_Result_i32 r) {
    if (r.err_val == FX_CAP_DENIED) {
        return fx_cli_fail("cap_regions_ext", "denied (cap)", FX_CAP_DENIED);
    }
    if (r.err_val == FX_CAP_IO_ERR) {
        return fx_cli_fail("cap_regions_ext", "io error", FX_CAP_IO_ERR);
    }
    return fx_cli_fail("cap_regions_ext", "guest rejected payload", (int)r.err_val);
}

int main(int argc, char **argv) {
    FxFsCap *fs_cap;
    FxOutCap *out_cap;
    fx_std_cap_FsCap fs;
    fx_std_cap_OutCap out;
    fx_guest_lib_Result_i32 r;

    if (argc != 2) {
        return fx_cli_usage("usage: cap_regions_ext <file>|--write-deny");
    }

    fs_cap = fx_fscap_mint("fixtures");
    out_cap = fx_outcap_mint("fixtures");
    if (fs_cap == NULL || out_cap == NULL) {
        fx_fscap_free(fs_cap);
        fx_outcap_free(out_cap);
        return fx_cli_fail("cap_regions_ext", "mint failed", 1);
    }
    fs.handle = fx_fscap_to_handle(fs_cap);
    out.handle = fx_outcap_to_handle(out_cap);

    if (strcmp(argv[1], "--write-deny") == 0) {
        r = fx_guest_lib_probe_write(out, "../secret_out.txt", "x");
        fx_fscap_free(fs_cap);
        fx_outcap_free(out_cap);
        if (r.tag != FX_RESULT_TAG_OK) {
            if (r.err_val == FX_CAP_DENIED) {
                return FX_CAP_DENIED;
            }
            return fail_guest(r);
        }
        return fx_cli_fail("cap_regions_ext", "write-deny expected Err(5)", 1);
    }

    /* Extension pattern: guest calls io_cap through the handles. */
    r = fx_guest_lib_run(fs, out, argv[1]);
    fx_fscap_free(fs_cap);
    fx_outcap_free(out_cap);

    if (r.tag != FX_RESULT_TAG_OK) {
        return fail_guest(r);
    }
    if (r.ok_val != 42) {
        return fx_cli_fail("cap_regions_ext", "unexpected score", 1);
    }
    return 0;
}
