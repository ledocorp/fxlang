/* Host mints read authority; guest never calls fopen.
 *
 * Usage: prog <file>
 * Exit: 0 success (guest Ok) · 1 usage · 3 guest reject · 5 denied (cap)
 *
 * Cap today = rooted allowlist + host-owned read. Typed FsCap in-language = later.
 */
#include "guest_lib.h"
#include "../cli_host/fx_cli_host.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CAP_DENIED 5

/* Allow only relative paths under fixtures/ with no ".." segments. */
static int path_allowed(const char *path) {
    size_t i;
    if (path == NULL || path[0] == '\0') {
        return 0;
    }
    if (path[0] == '/' || path[0] == '\\') {
        return 0;
    }
    if (path[0] != '\0' && path[1] == ':') {
        return 0; /* Windows drive */
    }
    if (strncmp(path, "fixtures/", 9) != 0 && strncmp(path, "fixtures\\", 9) != 0) {
        return 0;
    }
    for (i = 0; path[i] != '\0'; i++) {
        if (path[i] == '.' && path[i + 1] == '.') {
            return 0;
        }
    }
    return 1;
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

int main(int argc, char **argv) {
    const char *file;
    char *bytes;
    fx_guest_lib_Result_i32 r;

    if (argc != 2) {
        return fx_cli_usage("usage: cap_host_smoke <file>");
    }
    file = argv[1];
    if (!path_allowed(file)) {
        return fx_cli_fail("cap_host_smoke", "denied (cap)", CAP_DENIED);
    }

    bytes = read_all(file, NULL);
    if (bytes == NULL) {
        return fx_cli_fail("cap_host_smoke", "io error", 2);
    }

    /* Mint: guest receives bytes only — no path, no ambient io. */
    r = fx_guest_lib_run(bytes);
    free(bytes);

    if (r.tag != FX_RESULT_TAG_OK) {
        return fx_cli_fail("cap_host_smoke", "guest rejected payload", (int)r.err_val);
    }
    if (r.ok_val != 42) {
        return fx_cli_fail("cap_host_smoke", "unexpected score", 1);
    }
    return 0;
}
