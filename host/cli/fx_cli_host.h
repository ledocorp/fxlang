/* Shared CLI host helpers (C owns process edge).
 *
 * Contract:
 *   - fx owns program logic (parse / path / diff / …) and returns Result<i32, core_Err>
 *   - C owns argv, usage text, stderr labels, and process exit codes
 *   - Product path: `fx build|run lib.fx --cli` auto-links this spine + argv accessors
 *     so tools do not author a per-project host.c
 *
 * SoT: host/cli/fx_cli_host.h + fx_cli_argv.c
 * Compat: examples/cli_host/fx_cli_host.h redirects here.
 */
#ifndef FX_CLI_HOST_H
#define FX_CLI_HOST_H

#include <stdio.h>
#include <stdint.h>

#ifndef FX_RESULT_TAG_OK
#define FX_RESULT_TAG_OK 0
#endif

#ifdef __cplusplus
extern "C" {
#endif

/** Install process argc/argv for fx_cli_argc / fx_cli_arg (auto-host calls this). */
void fx_cli_set_args(int argc, char **argv);

/** Process argc (includes argv[0]). */
int32_t fx_cli_argc(void);

/** argv[i] as C string; "" if out of range. */
const char *fx_cli_arg(int32_t i);

/** Print `usage_line` to stderr; return process code 1 (usage). */
static inline int fx_cli_usage(const char *usage_line) {
    fprintf(stderr, "%s\n", usage_line);
    return 1;
}

/** Print `<tool>: <msg>` to stderr; return `code`. */
static inline int fx_cli_fail(const char *tool, const char *msg, int code) {
    fprintf(stderr, "%s: %s\n", tool, msg);
    return code;
}

/**
 * Unwrap an emit-C `Result_i32` (fields: tag, ok_val, err_val).
 * On Err: print `<tool>: error <n>` and return err_val.
 * On Ok: return ok_val.
 */
#define FX_CLI_RETURN_RESULT_I32(r, tool)                                         \
    do {                                                                          \
        if ((r).tag != FX_RESULT_TAG_OK) {                                        \
            fprintf(stderr, "%s: error %d\n", (tool), (int)(r).err_val);          \
            return (int)(r).err_val;                                               \
        }                                                                         \
        return (int)(r).ok_val;                                                    \
    } while (0)

#ifdef __cplusplus
}
#endif

#endif /* FX_CLI_HOST_H */
