/* FX-DYN — FsCap / OutCap + Phase B.1 guest session (stdio). */
#include "fx_cap_runtime.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *g_last_text = NULL;

static void clear_last_text(void) {
    free(g_last_text);
    g_last_text = NULL;
}

static int mint_root(char *dst, size_t dst_sz, const char *root_dir) {
    size_t n;

    if (root_dir == NULL || root_dir[0] == '\0') {
        return 0;
    }
    n = strlen(root_dir);
    if (n >= dst_sz) {
        return 0;
    }
    memcpy(dst, root_dir, n + 1);
    return 1;
}

FxFsCap *fx_fscap_mint(const char *root_dir) {
    FxFsCap *cap;

    cap = (FxFsCap *)calloc(1, sizeof(FxFsCap));
    if (cap == NULL) {
        return NULL;
    }
    if (!mint_root(cap->root, sizeof(cap->root), root_dir)) {
        free(cap);
        return NULL;
    }
    cap->live = 1;
    return cap;
}

void fx_fscap_free(FxFsCap *cap) {
    if (cap == NULL) {
        return;
    }
    cap->live = 0;
    free(cap);
    clear_last_text();
}

FxOutCap *fx_outcap_mint(const char *root_dir) {
    FxOutCap *cap;

    cap = (FxOutCap *)calloc(1, sizeof(FxOutCap));
    if (cap == NULL) {
        return NULL;
    }
    if (!mint_root(cap->root, sizeof(cap->root), root_dir)) {
        free(cap);
        return NULL;
    }
    cap->live = 1;
    return cap;
}

void fx_outcap_free(FxOutCap *cap) {
    if (cap == NULL) {
        return;
    }
    cap->live = 0;
    free(cap);
}

int64_t fx_fscap_to_handle(FxFsCap *cap) {
    return (int64_t)(intptr_t)cap;
}

FxFsCap *fx_fscap_from_handle(int64_t handle) {
    return (FxFsCap *)(intptr_t)handle;
}

int64_t fx_outcap_to_handle(FxOutCap *cap) {
    return (int64_t)(intptr_t)cap;
}

FxOutCap *fx_outcap_from_handle(int64_t handle) {
    return (FxOutCap *)(intptr_t)handle;
}

static int has_dotdot(const char *path) {
    size_t i;
    for (i = 0; path[i] != '\0'; i++) {
        if (path[i] == '.' && path[i + 1] == '.') {
            return 1;
        }
    }
    return 0;
}

static int path_allowed(const char *root, int live, const char *path) {
    size_t root_len;
    char sep;

    if (!live || root == NULL || path == NULL || path[0] == '\0') {
        return 0;
    }
    if (path[0] == '/' || path[0] == '\\') {
        return 0;
    }
    if (path[0] != '\0' && path[1] == ':') {
        return 0; /* Windows drive — require relative under root */
    }
    if (has_dotdot(path)) {
        return 0;
    }
    root_len = strlen(root);
    if (strncmp(path, root, root_len) != 0) {
        return 0;
    }
    if (path[root_len] == '\0') {
        return 0; /* path == root only — need a file under root */
    }
    sep = path[root_len];
    if (sep != '/' && sep != '\\') {
        /* allow root without trailing slash: "fixtures" + "fixtures/ok.txt" */
        if (root_len > 0) {
            char last = root[root_len - 1];
            if (last != '/' && last != '\\') {
                return 0;
            }
        }
    }
    return 1;
}

int fx_fscap_path_allowed(const FxFsCap *cap, const char *path) {
    if (cap == NULL) {
        return 0;
    }
    return path_allowed(cap->root, cap->live, path);
}

int fx_outcap_path_allowed(const FxOutCap *cap, const char *path) {
    if (cap == NULL) {
        return 0;
    }
    return path_allowed(cap->root, cap->live, path);
}

static char *read_all(const char *path, size_t *out_len) {
    FILE *f;
    long sz;
    char *buf;
    size_t n;

    f = fopen(path, "rb");
    if (f == NULL) {
        return NULL;
    }
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        return NULL;
    }
    sz = ftell(f);
    if (sz < 0) {
        fclose(f);
        return NULL;
    }
    if (fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        return NULL;
    }
    buf = (char *)malloc((size_t)sz + 1);
    if (buf == NULL) {
        fclose(f);
        return NULL;
    }
    n = fread(buf, 1, (size_t)sz, f);
    fclose(f);
    buf[n] = '\0';
    if (out_len != NULL) {
        *out_len = n;
    }
    return buf;
}

int fx_io_cap_read_file(int64_t fs_handle, const char *path) {
    FxFsCap *cap;
    char *bytes;

    clear_last_text();
    cap = fx_fscap_from_handle(fs_handle);
    if (!fx_fscap_path_allowed(cap, path)) {
        return FX_CAP_DENIED;
    }
    bytes = read_all(path, NULL);
    if (bytes == NULL) {
        return FX_CAP_IO_ERR;
    }
    g_last_text = bytes;
    return FX_CAP_OK;
}

const char *fx_io_cap_last_text(void) {
    if (g_last_text == NULL) {
        return "";
    }
    return g_last_text;
}

int fx_io_cap_write_file(int64_t out_handle, const char *path, const char *data) {
    FxOutCap *cap;
    FILE *f;
    size_t n;
    size_t wrote;

    cap = fx_outcap_from_handle(out_handle);
    if (!fx_outcap_path_allowed(cap, path)) {
        return FX_CAP_DENIED;
    }
    if (data == NULL) {
        data = "";
    }
    f = fopen(path, "wb");
    if (f == NULL) {
        return FX_CAP_IO_ERR;
    }
    n = strlen(data);
    wrote = fwrite(data, 1, n, f);
    if (fclose(f) != 0 || wrote != n) {
        return FX_CAP_IO_ERR;
    }
    return FX_CAP_OK;
}

/* --- Phase B.1 guest context ------------------------------------------------ */

int64_t fx_guest_to_handle(FxGuestCtx *ctx) {
    return (int64_t)(intptr_t)ctx;
}

FxGuestCtx *fx_guest_from_handle(int64_t handle) {
    return (FxGuestCtx *)(intptr_t)handle;
}

int fx_guest_is_live(int64_t ctx_handle) {
    FxGuestCtx *g = fx_guest_from_handle(ctx_handle);
    return (g != NULL && g->live) ? 1 : 0;
}

static const char *mint_root_or_default(FxGuestCtx *g, const char *root) {
    if (root != NULL && root[0] != '\0') {
        return root;
    }
    if (g != NULL && g->root[0] != '\0') {
        return g->root;
    }
    return NULL;
}

int64_t fx_guest_begin(const char *root, int64_t arena_bytes) {
    FxGuestCtx *g;
    size_t nbytes;

    g = (FxGuestCtx *)calloc(1, sizeof(FxGuestCtx));
    if (g == NULL) {
        return 0;
    }
    if (root != NULL && root[0] != '\0') {
        if (!mint_root(g->root, sizeof(g->root), root)) {
            free(g);
            return 0;
        }
    }
    nbytes = (arena_bytes > 0) ? (size_t)arena_bytes : (size_t)FX_GUEST_DEFAULT_ARENA;
    g->arena = (char *)calloc(1, nbytes);
    if (g->arena == NULL) {
        free(g);
        return 0;
    }
    g->arena_size = nbytes;
    g->arena_used = 0;
    g->live = 1;
    return fx_guest_to_handle(g);
}

int fx_guest_end(int64_t ctx_handle) {
    FxGuestCtx *g;
    int i;

    g = fx_guest_from_handle(ctx_handle);
    if (g == NULL) {
        return 0;
    }
    /* Revoke first: copyable handles become deny tombstones (structs kept). */
    for (i = 0; i < g->fs_n; i++) {
        if (g->fs[i] != NULL) {
            g->fs[i]->live = 0;
        }
    }
    for (i = 0; i < g->out_n; i++) {
        if (g->out[i] != NULL) {
            g->out[i]->live = 0;
        }
    }
    for (i = 0; i < g->alloc_n; i++) {
        if (g->alloc[i] != NULL) {
            g->alloc[i]->live = 0;
            g->alloc[i]->ctx = NULL; /* never deref after end */
            g->alloc[i]->budget_remaining = 0;
        }
    }
    for (i = 0; i < g->fuel_n; i++) {
        if (g->fuel[i] != NULL) {
            g->fuel[i]->live = 0;
            g->fuel[i]->ctx = NULL;
            g->fuel[i]->units_remaining = 0;
        }
    }
    if (g->arena != NULL) {
        free(g->arena);
        g->arena = NULL;
    }
    g->arena_size = 0;
    g->arena_used = 0;
    g->live = 0;
    /* Cap structs remain as live==0 tombstones so stale handles deny safely.
     * Context record is freed; callers must not use ctx_handle after end. */
    free(g);
    clear_last_text();
    return 0;
}

int64_t fx_guest_mint_fscap(int64_t ctx_handle, const char *root) {
    FxGuestCtx *g;
    const char *use_root;
    FxFsCap *cap;

    g = fx_guest_from_handle(ctx_handle);
    if (g == NULL || !g->live) {
        return 0;
    }
    if (g->fs_n >= FX_GUEST_MAX_CAPS) {
        return 0;
    }
    use_root = mint_root_or_default(g, root);
    if (use_root == NULL) {
        return 0;
    }
    cap = fx_fscap_mint(use_root);
    if (cap == NULL) {
        return 0;
    }
    g->fs[g->fs_n++] = cap;
    return fx_fscap_to_handle(cap);
}

int64_t fx_guest_mint_outcap(int64_t ctx_handle, const char *root) {
    FxGuestCtx *g;
    const char *use_root;
    FxOutCap *cap;

    g = fx_guest_from_handle(ctx_handle);
    if (g == NULL || !g->live) {
        return 0;
    }
    if (g->out_n >= FX_GUEST_MAX_CAPS) {
        return 0;
    }
    use_root = mint_root_or_default(g, root);
    if (use_root == NULL) {
        return 0;
    }
    cap = fx_outcap_mint(use_root);
    if (cap == NULL) {
        return 0;
    }
    g->out[g->out_n++] = cap;
    return fx_outcap_to_handle(cap);
}

static int64_t guest_bump_alloc(FxGuestCtx *g, int64_t nbytes) {
    size_t n;
    size_t align;
    size_t padded;
    char *p;

    if (g == NULL || !g->live || g->arena == NULL) {
        return 0;
    }
    if (nbytes <= 0) {
        return 0;
    }
    n = (size_t)nbytes;
    align = sizeof(void *);
    padded = (g->arena_used + (align - 1)) & ~(align - 1);
    if (padded > g->arena_size || n > g->arena_size - padded) {
        return 0;
    }
    p = g->arena + padded;
    g->arena_used = padded + n;
    return (int64_t)(intptr_t)p;
}

int64_t fx_guest_alloc(int64_t ctx_handle, int64_t nbytes) {
    return guest_bump_alloc(fx_guest_from_handle(ctx_handle), nbytes);
}

int64_t fx_alloccap_to_handle(FxAllocCap *cap) {
    return (int64_t)(intptr_t)cap;
}

FxAllocCap *fx_alloccap_from_handle(int64_t handle) {
    return (FxAllocCap *)(intptr_t)handle;
}

int64_t fx_guest_mint_alloccap(int64_t ctx_handle, int64_t budget_bytes) {
    FxGuestCtx *g;
    FxAllocCap *cap;

    g = fx_guest_from_handle(ctx_handle);
    if (g == NULL || !g->live) {
        return 0;
    }
    if (budget_bytes <= 0) {
        return 0;
    }
    if (g->alloc_n >= FX_GUEST_MAX_CAPS) {
        return 0;
    }
    cap = (FxAllocCap *)calloc(1, sizeof(FxAllocCap));
    if (cap == NULL) {
        return 0;
    }
    cap->ctx = g;
    cap->budget_remaining = budget_bytes;
    cap->live = 1;
    g->alloc[g->alloc_n++] = cap;
    return fx_alloccap_to_handle(cap);
}

int64_t fx_alloccap_alloc(int64_t alloc_handle, int64_t nbytes) {
    FxAllocCap *cap;
    int64_t p;

    cap = fx_alloccap_from_handle(alloc_handle);
    /* Check live before touching ctx (tombstones after guest_end). */
    if (cap == NULL || !cap->live) {
        return 0;
    }
    if (nbytes <= 0 || nbytes > cap->budget_remaining) {
        return 0;
    }
    p = guest_bump_alloc(cap->ctx, nbytes);
    if (p == 0) {
        return 0;
    }
    cap->budget_remaining -= nbytes;
    return p;
}

int64_t fx_fuelcap_to_handle(FxFuelCap *cap) {
    return (int64_t)(intptr_t)cap;
}

FxFuelCap *fx_fuelcap_from_handle(int64_t handle) {
    return (FxFuelCap *)(intptr_t)handle;
}

int64_t fx_guest_mint_fuelcap(int64_t ctx_handle, int64_t units) {
    FxGuestCtx *g;
    FxFuelCap *cap;

    g = fx_guest_from_handle(ctx_handle);
    if (g == NULL || !g->live) {
        return 0;
    }
    if (units <= 0) {
        return 0;
    }
    if (g->fuel_n >= FX_GUEST_MAX_CAPS) {
        return 0;
    }
    cap = (FxFuelCap *)calloc(1, sizeof(FxFuelCap));
    if (cap == NULL) {
        return 0;
    }
    cap->ctx = g;
    cap->units_remaining = units;
    cap->live = 1;
    g->fuel[g->fuel_n++] = cap;
    return fx_fuelcap_to_handle(cap);
}

int fx_fuelcap_burn(int64_t fuel_handle, int64_t units) {
    FxFuelCap *cap;

    cap = fx_fuelcap_from_handle(fuel_handle);
    if (cap == NULL || !cap->live) {
        return 0;
    }
    if (units <= 0 || units > cap->units_remaining) {
        return 0;
    }
    cap->units_remaining -= units;
    return 1;
}
