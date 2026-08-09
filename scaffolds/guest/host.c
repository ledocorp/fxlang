/* guest session host (host/cap + host/cli spine).
 * Flow: begin → mint FsCap → guest run → end
 *
 * Build:
 *   fx build guest_lib.fx -o out --emit-c --host host.c \
 *     --link host/cap/fx_cap_runtime.c --link-include . --link-include host/cap
 */
#include "guest_lib.h"
#include "fx_cli_host.h"
#include "fx_cap_runtime.h"

int main(int argc, char **argv) {
    int64_t ctx;
    int64_t fs_h;
    fx_std_cap_FsCap fs;
    fx_guest_lib_Result_i32 r;

    (void)argc;
    (void)argv;

    ctx = fx_guest_begin(".", 4096);
    if (ctx == 0) {
        return fx_cli_fail("guest", "guest_begin failed", 1);
    }
    fs_h = fx_guest_mint_fscap(ctx, "");
    if (fs_h == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("guest", "mint_fscap failed", 1);
    }
    fs.handle = fs_h;
    r = fx_guest_lib_run(fs);
    (void)fx_guest_end(ctx);
    FX_CLI_RETURN_RESULT_I32(r, "guest");
}
