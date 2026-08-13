/* Shared argv storage for --cli auto-host.
 * Linked by the compiler when --cli is set; not author-written per tool.
 */
#include "fx_cli_host.h"

#include <stdint.h>

static int fx_cli_g_argc = 0;
static char **fx_cli_g_argv = 0;

void fx_cli_set_args(int argc, char **argv) {
    fx_cli_g_argc = argc;
    fx_cli_g_argv = argv;
}

int32_t fx_cli_argc(void) {
    return (int32_t)fx_cli_g_argc;
}

const char *fx_cli_arg(int32_t i) {
    if (i < 0 || i >= fx_cli_g_argc || fx_cli_g_argv == 0) {
        return "";
    }
    if (fx_cli_g_argv[i] == 0) {
        return "";
    }
    return fx_cli_g_argv[i];
}
