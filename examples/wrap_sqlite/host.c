/* Thin argv host over sqlite_safe (host/cli helpers).
 *
 * Usage: prog           - run :memory: SELECT-42 smoke via linked fx guest
 * Exit: 0 on success (unwraps Result 42 → process 0 via CLI helper pattern)
 *
 * Note: dual-path product proof is main.fx (exit 42). This host proves argv
 * hang for a persistence tool shape.
 */
#include "../../host/cli/fx_cli_host.h"

#include <stdint.h>
#include <stdio.h>

/* Declared by emit-C / linked sqlite_ref + amalgamation when built with fx. */
int32_t fx_sqlite_open_memory(void);
int32_t fx_sqlite_exec(int32_t h, const char *sql);
int32_t fx_sqlite_query_i32(int32_t h, const char *sql);
int32_t fx_sqlite_close(int32_t h);

static int run_memory_smoke(void) {
    int32_t h;
    int32_t n;

    h = fx_sqlite_open_memory();
    if (h < 1) {
        return fx_cli_fail("wrap_sqlite", "open_memory failed", 1);
    }
    if (fx_sqlite_exec(h, "CREATE TABLE t(x INTEGER); INSERT INTO t VALUES(42);") != 0) {
        (void)fx_sqlite_close(h);
        return fx_cli_fail("wrap_sqlite", "exec failed", 1);
    }
    n = fx_sqlite_query_i32(h, "SELECT x FROM t;");
    (void)fx_sqlite_close(h);
    if (n != 42) {
        return fx_cli_fail("wrap_sqlite", "query expected 42", 1);
    }
    return 0;
}

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    return run_memory_smoke();
}
