/* Host-side FsCap / OutCap / AllocCap / FuelCap / NetCap + guest session.
 *
 * SoT path: host/cap/ (not inside libzspec.a).
 * Language ABI: fx_std_cap_* { int64_t handle } holds (intptr_t)cap*.
 * GuestCtx: fx_guest_begin / mint_* / end (std/guest.fx).
 * AllocCap / FuelCap: budgeted; over-budget / stale → deny.
 * Nested guest begin (parent ends children). NetCap: allowlist only (no dial).
 */
#ifndef FX_CAP_RUNTIME_H
#define FX_CAP_RUNTIME_H

#include <stdint.h>
#include <stddef.h>

/* Host spine ABI stamp (bump when C layout / mint contracts change). */
#define FX_HOST_SPINE_ABI 3

#define FX_CAP_OK 0
#define FX_CAP_IO_ERR 2
#define FX_CAP_DENIED 5

typedef struct FxFsCap {
    char root[512]; /* allowlisted directory prefix (relative or absolute) */
    int live;       /* 0 after teardown - copies of the handle become deny */
} FxFsCap;

/* OutCap: write-rooted allowlist (same layout as FsCap; separate type for ABI clarity). */
typedef struct FxOutCap {
    char root[512];
    int live;
} FxOutCap;

/* Forward decl - AllocCap points at owning session (check live before deref). */
typedef struct FxGuestCtx FxGuestCtx;

/* AllocCap: budgeted bump-alloc from guest arena. */
typedef struct FxAllocCap {
    FxGuestCtx *ctx;
    int64_t budget_remaining;
    int live; /* 0 after teardown - copies deny */
} FxAllocCap;

/* FuelCap: unit/step budget for guest loops. */
typedef struct FxFuelCap {
    FxGuestCtx *ctx;
    int64_t units_remaining;
    int live; /* 0 after teardown - copies deny */
} FxFuelCap;

/* NetCap: host allowlist + port range (declared early for FxGuestCtx). */
typedef struct FxNetCap {
    char allow_host[256];
    int port_min;
    int port_max;
    int live;
} FxNetCap;

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
/* Independent guest context (host session; no `dynamic region` kw) */
/* -------------------------------------------------------------------------- */

#define FX_GUEST_MAX_CAPS 16
#define FX_GUEST_MAX_CHILDREN 8
#define FX_GUEST_DEFAULT_ARENA (64 * 1024)

struct FxGuestCtx {
    char root[512]; /* default mint root (empty = mint must pass explicit root) */
    char *arena;
    size_t arena_size;
    size_t arena_used;
    FxFsCap *fs[FX_GUEST_MAX_CAPS];
    int fs_n;
    FxOutCap *out[FX_GUEST_MAX_CAPS];
    int out_n;
    FxAllocCap *alloc[FX_GUEST_MAX_CAPS];
    int alloc_n;
    FxFuelCap *fuel[FX_GUEST_MAX_CAPS];
    int fuel_n;
    FxNetCap *net[FX_GUEST_MAX_CAPS];
    int net_n;
    /* Nested session graph (host TCB; not language concurrency). */
    struct FxGuestCtx *parent;
    struct FxGuestCtx *children[FX_GUEST_MAX_CHILDREN];
    int children_n;
    int live;
};

/*
 * Begin a guest session: owns a bump arena + cap set.
 * `root` may be NULL/"" (mint with explicit roots) or a default allowlist prefix.
 * `arena_bytes` <= 0 → FX_GUEST_DEFAULT_ARENA.
 * Returns handle bit-pattern, or 0 on failure.
 * ABI matches std/guest.fx externs.
 */
int64_t fx_guest_begin(const char *root, int64_t arena_bytes);

/* Revoke minted caps + nested children (live=0 tombstones), free arena.
 * Ctx record remains a tombstone (is_live=0; nested under it fails). Returns 0. */
int fx_guest_end(int64_t ctx_handle);

/* Mint FsCap/OutCap owned by the session (revoked on fx_guest_end). 0 = fail. */
int64_t fx_guest_mint_fscap(int64_t ctx_handle, const char *root);
int64_t fx_guest_mint_outcap(int64_t ctx_handle, const char *root);

/* Mint AllocCap with byte budget (revoked on fx_guest_end). 0 = fail. */
int64_t fx_guest_mint_alloccap(int64_t ctx_handle, int64_t budget_bytes);

/* Bump-alloc through AllocCap. 0 if dead / over-budget / OOM. Pointer as i64. */
int64_t fx_alloccap_alloc(int64_t alloc_handle, int64_t nbytes);

int64_t fx_alloccap_to_handle(FxAllocCap *cap);
FxAllocCap *fx_alloccap_from_handle(int64_t handle);

/* Mint FuelCap with unit budget (revoked on fx_guest_end). 0 = fail. */
int64_t fx_guest_mint_fuelcap(int64_t ctx_handle, int64_t units);

/* Burn units through FuelCap. 1 = ok; 0 = dead / over-fuel. */
int fx_fuelcap_burn(int64_t fuel_handle, int64_t units);

int64_t fx_fuelcap_to_handle(FxFuelCap *cap);
FxFuelCap *fx_fuelcap_from_handle(int64_t handle);

/* Bump-alloc from the guest arena (host scratch). 0 if dead / OOM. Pointer as i64. */
int64_t fx_guest_alloc(int64_t ctx_handle, int64_t nbytes);

int fx_guest_is_live(int64_t ctx_handle);

FxGuestCtx *fx_guest_from_handle(int64_t handle);
int64_t fx_guest_to_handle(FxGuestCtx *ctx);

/* -------------------------------------------------------------------------- */
/* NetCap mint (no dial) · nested guest sessions */
/* -------------------------------------------------------------------------- */

int64_t fx_netcap_to_handle(FxNetCap *cap);
FxNetCap *fx_netcap_from_handle(int64_t handle);

/* 1 if host matches allow_host (case-sensitive exact) and port in [min,max]. */
int fx_netcap_host_port_allowed(const FxNetCap *cap, const char *host, int port);
/* Handle form for spokes (0 handle → deny). */
int fx_netcap_allows(int64_t net_handle, const char *host, int port);

/*
 * Mint NetCap owned by the session. Revoked on fx_guest_end.
 * allow_host non-empty; 1 <= port_min <= port_max <= 65535. No dial/sockets.
 * Returns handle, or 0 on failure.
 */
int64_t fx_guest_mint_netcap(int64_t ctx_handle, const char *allow_host, int port_min,
                             int port_max);

/*
 * Begin a nested guest under parent_ctx.
 * Child owns its own arena + caps. Ending parent ends all live children first.
 * Empty/NULL root inherits parent's default root when set.
 * Returns child handle, or 0 on failure (dead parent / full child table / OOM).
 */
int64_t fx_guest_begin_nested(int64_t parent_ctx, const char *root, int64_t arena_bytes);

/*  - TCP dial if allowlisted; want_tls!=0 → always fail (no TLS yet). */
int64_t fx_netcap_dial(int64_t net_handle, const char *host, int32_t port, int32_t want_tls);
int32_t fx_netcap_close(int64_t sock_handle);

#endif /* FX_CAP_RUNTIME_H */
