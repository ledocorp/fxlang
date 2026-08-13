/* Shared OS process edge for product CLIs (not Minimal Core).
 *
 * Contract:
 *   - fx owns tool logic; C owns spawn / cwd / mkdir / small alloc helpers
 *   - argv / usage / Result unwrap stay in host/cli/fx_cli_host.h
 *   - Tool-specific discovery (e.g. fxrun.toml walk-up) stays in the tool host
 *
 * SoT: host/process/fx_process.{h,c}
 * Link: --link host/process/fx_process.c --link-include host/process
 *        (+ zspec include + libzspec when using slice / i32_dec)
 */
#ifndef FX_PROCESS_H
#define FX_PROCESS_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/** Run one shell command; return process exit code (127 = spawn fail). */
int fx_proc_run_cmd(const char *cmd);

/** Create directory if missing; 0 = ok, 1 = fail. */
int fx_proc_ensure_dir(const char *path);

/** Regular file exists? 1 = yes, 0 = no. */
int fx_proc_file_exists(const char *path);

/** Change working directory; 0 = ok, 1 = fail. */
int fx_proc_chdir(const char *path);

/** Copy cwd into buf; NULL on failure (same contract as getcwd). */
char *fx_proc_getcwd(char *buf, size_t buflen);

/**
 * Allocate substring [lo, hi) via core_default_allocator.
 * Returns "" on bad args / OOM (never NULL).
 */
const char *fx_proc_slice(const char *s, int32_t lo, int32_t hi);

/** Decimal string for stamp files (alloc); never NULL. */
const char *fx_proc_i32_dec(int32_t n);

/** Allocated copy of cwd via core_default_allocator; "" on failure (never NULL). */
const char *fx_proc_getcwd_alloc(void);

#ifdef __cplusplus
}
#endif

#endif /* FX_PROCESS_H */
