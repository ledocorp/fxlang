/* FX-DYN — host-side FsCap / OutCap + Phase B.1 guest session helpers.
 *
 * Language ABI: fx_std_cap_FsCap / OutCap { int64_t handle } holds (intptr_t)cap*.
 * GuestCtx: fx_guest_begin / mint_* / end (std/guest.fx).
 * Link with examples that import std/io_cap or std/guest.
 */
#ifndef FX_CAP_RUNTIME_H
#define FX_CAP_RUNTIME_H

#include <stdint.h>
#include <stddef.h>

#define FX_CAP_OK 0
#define FX_CAP_IO_ERR 2
#define FX_CAP_DENIED 5

typedef struct FxFsCap {
    char root[512]; /* allowlisted directory prefix (relative or absolute) */
    int live;       /* 0 after teardown — copies of the handle become deny */
} FxFsCap;

/* OutCap: write-rooted allowlist (same layout as FsCap; separate type for ABI clarity). */
typedef struct FxOutCap {
    char root[512];
    int live;
} FxOutCap;

/* Mint a rooted FsCap. Returns NULL on failure. Caller owns until fx_fscap_free. */
FxFsCap *fx_fscap_mint(const char *root_dir);

void fx_fscap_free(FxFsCap *cap);

/* Mint a rooted OutCap for writes. Returns NULL on failure. */
FxOutCap *fx_outcap_mint(const char *root_dir);

void fx_outcap_free(FxOutCap *cap);

/* 1 if path is under cap->root and has no ".." escape; else 0. */
int fx_fscap_path_allowed(const FxFsCap *cap, const char *path);
int fx_outcap_path_allowed(const FxOutCap *cap, const char *path);

/* Bit-pattern for fx_std_cap_* .handle / io_cap externs. */
int64_t fx_fscap_to_handle(FxFsCap *cap);
FxFsCap *fx_fscap_from_handle(int64_t handle);

int64_t fx_outcap_to_handle(FxOutCap *cap);
FxOutCap *fx_outcap_from_handle(int64_t handle);

/*
 * Cap-required read used by std/io_cap externs.
 * Returns FX_CAP_OK and stashes NUL-terminated text for fx_io_cap_last_text();
 * FX_CAP_DENIED (5) or FX_CAP_IO_ERR (2) otherwise.
 */
int fx_io_cap_read_file(int64_t fs_handle, const char *path);
const char *fx_io_cap_last_text(void);

/*
 * Cap-required write used by std/io_cap.write_file_cap.
 * Returns FX_CAP_OK, FX_CAP_DENIED (5), or FX_CAP_IO_ERR (2).
 */
int fx_io_cap_write_file(int64_t out_handle, const char *path, const char *data);

/* -------------------------------------------------------------------------- */
/* Phase B.1 — independent guest context (host session; no `dynamic region` kw) */
/* -------------------------------------------------------------------------- */

#define FX_GUEST_MAX_CAPS 16
#define FX_GUEST_DEFAULT_ARENA (64 * 1024)

typedef struct FxGuestCtx {
    char root[512]; /* default mint root (empty = mint must pass explicit root) */
    char *arena;
    size_t arena_size;
    size_t arena_used;
    FxFsCap *fs[FX_GUEST_MAX_CAPS];
    int fs_n;
    FxOutCap *out[FX_GUEST_MAX_CAPS];
    int out_n;
    int live;
} FxGuestCtx;

/*
 * Begin a guest session: owns a bump arena + cap set.
 * `root` may be NULL/"" (mint with explicit roots) or a default allowlist prefix.
 * `arena_bytes` <= 0 → FX_GUEST_DEFAULT_ARENA.
 * Returns handle bit-pattern, or 0 on failure.
 * ABI matches std/guest.fx externs.
 */
int64_t fx_guest_begin(const char *root, int64_t arena_bytes);

/* Revoke all minted caps (live=0 tombstones), free arena + ctx. Returns 0. */
int fx_guest_end(int64_t ctx_handle);

/* Mint FsCap/OutCap owned by the session (revoked on fx_guest_end). 0 = fail. */
int64_t fx_guest_mint_fscap(int64_t ctx_handle, const char *root);
int64_t fx_guest_mint_outcap(int64_t ctx_handle, const char *root);

/* Bump-alloc from the guest arena. 0 if dead / OOM. Pointer as i64. */
int64_t fx_guest_alloc(int64_t ctx_handle, int64_t nbytes);

int fx_guest_is_live(int64_t ctx_handle);

FxGuestCtx *fx_guest_from_handle(int64_t handle);
int64_t fx_guest_to_handle(FxGuestCtx *ctx);

#endif /* FX_CAP_RUNTIME_H */
