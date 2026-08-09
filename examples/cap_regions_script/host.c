/* scripting host: mint FsCap, rooted read, pass handle + bytes to guest.
 *
 * Usage: prog <file>
 * Exit: 0 success · 1 usage · 2 io · 3 guest reject · 5 denied
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"
#include "../cap_runtime/fx_cap_runtime.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    const char *file;
    FxFsCap *cap;
    fx_std_cap_FsCap fs;
    char *bytes;
    fx_guest_lib_Result_i32 r;
    int st;

    if (argc != 2) {
        return fx_cli_usage("usage: cap_regions_script <file>");
    }
    file = argv[1];

    cap = fx_fscap_mint("fixtures");
    if (cap == NULL) {
        return fx_cli_fail("cap_regions_script", "mint failed", 1);
    }
    fs.handle = fx_fscap_to_handle(cap);

    /* Scripting pattern: host enforces cap, then hands bytes + FsCap into guest. */
    st = fx_io_cap_read_file(fs.handle, file);
    if (st == FX_CAP_DENIED) {
        fx_fscap_free(cap);
        return fx_cli_fail("cap_regions_script", "denied (cap)", FX_CAP_DENIED);
    }
    if (st != FX_CAP_OK) {
        fx_fscap_free(cap);
        return fx_cli_fail("cap_regions_script", "io error", FX_CAP_IO_ERR);
    }
    bytes = (char *)fx_io_cap_last_text();

    r = fx_guest_lib_run(fs, bytes);
    fx_fscap_free(cap);

    if (r.tag != FX_RESULT_TAG_OK) {
        return fx_cli_fail("cap_regions_script", "guest rejected payload", (int)r.err_val);
    }
    if (r.ok_val != 42) {
        return fx_cli_fail("cap_regions_script", "unexpected score", 1);
    }
    return 0;
}
