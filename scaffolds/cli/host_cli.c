/* thin argv host.
 * Usage: prog <arg>
 * Exit: 0 ok · 1 usage / Err
 *
 * Build:
 *   fx build tool_lib.fx -o out --emit-c --host host_cli.c --link-include .
 */
#include "tool_lib.h"
#include "fx_cli_host.h"

int main(int argc, char **argv) {
    if (argc != 2) {
        return fx_cli_usage("usage: tool <arg>");
    }
    fx_tool_lib_Result_i32 r = fx_tool_lib_run(argv[1]);
    FX_CLI_RETURN_RESULT_I32(r, "tool");
}
