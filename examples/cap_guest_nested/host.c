/* Nested guest session graph (host TCB).
 *
 * Flow: begin → begin_nested → mint → read ok
 *        → end child → stale deny
 *        → begin_nested again → mint → end parent → child caps deny
 *
 * Exit: 0 success · 1 internal · 5 denied (unexpected on live path)
 */
#include "../../host/cli/fx_cli_host.h"
#include "../../host/cap/fx_cap_runtime.h"

#include <stdio.h>

static int expect_ok_read(int64_t fs_h, const char *path) {
    int st = fx_io_cap_read_file(fs_h, path);
    if (st != FX_CAP_OK) {
        return fx_cli_fail("cap_guest_nested", "expected live read OK", st == 0 ? 1 : st);
    }
    return 0;
}

static int expect_deny_read(int64_t fs_h, const char *path) {
    int st = fx_io_cap_read_file(fs_h, path);
    if (st != FX_CAP_DENIED) {
        return fx_cli_fail("cap_guest_nested", "expected stale deny", 1);
    }
    return 0;
}

static int run_nested_probe(void) {
    int64_t parent;
    int64_t child;
    int64_t fs_h;
    int64_t fs_h2;
    int rc;

    parent = fx_guest_begin("fixtures", 4096);
    if (parent == 0) {
        return fx_cli_fail("cap_guest_nested", "guest_begin failed", 1);
    }

    child = fx_guest_begin_nested(parent, "", 2048);
    if (child == 0) {
        (void)fx_guest_end(parent);
        return fx_cli_fail("cap_guest_nested", "begin_nested failed", 1);
    }
    if (!fx_guest_is_live(child)) {
        (void)fx_guest_end(parent);
        return fx_cli_fail("cap_guest_nested", "child not live", 1);
    }

    fs_h = fx_guest_mint_fscap(child, "");
    if (fs_h == 0) {
        (void)fx_guest_end(parent);
        return fx_cli_fail("cap_guest_nested", "mint_fscap on child failed", 1);
    }

    rc = expect_ok_read(fs_h, "fixtures/ok.txt");
    if (rc != 0) {
        (void)fx_guest_end(parent);
        return rc;
    }

    /* End child only - parent stays live; child caps become deny tombstones. */
    (void)fx_guest_end(child);
    if (fx_guest_is_live(child)) {
        (void)fx_guest_end(parent);
        return fx_cli_fail("cap_guest_nested", "child still live after end", 1);
    }
    rc = expect_deny_read(fs_h, "fixtures/ok.txt");
    if (rc != 0) {
        (void)fx_guest_end(parent);
        return rc;
    }

    /* Fresh nested child; end parent while child still live → cascade revoke. */
    child = fx_guest_begin_nested(parent, "", 2048);
    if (child == 0) {
        (void)fx_guest_end(parent);
        return fx_cli_fail("cap_guest_nested", "second begin_nested failed", 1);
    }
    fs_h2 = fx_guest_mint_fscap(child, "");
    if (fs_h2 == 0) {
        (void)fx_guest_end(parent);
        return fx_cli_fail("cap_guest_nested", "second mint_fscap failed", 1);
    }
    rc = expect_ok_read(fs_h2, "fixtures/ok.txt");
    if (rc != 0) {
        (void)fx_guest_end(parent);
        return rc;
    }

    (void)fx_guest_end(parent);
    if (fx_guest_is_live(parent) || fx_guest_is_live(child)) {
        return fx_cli_fail("cap_guest_nested", "parent/child still live after parent end", 1);
    }
    rc = expect_deny_read(fs_h2, "fixtures/ok.txt");
    if (rc != 0) {
        return rc;
    }

    /* Dead parent cannot nest. */
    if (fx_guest_begin_nested(parent, "", 0) != 0) {
        return fx_cli_fail("cap_guest_nested", "nested under dead parent should fail", 1);
    }

    /* SPINE-2b - NetCap mint + allow check + revoke (no dial). */
    {
        int64_t ctx;
        int64_t net_h;

        ctx = fx_guest_begin("", 4096);
        if (ctx == 0) {
            return fx_cli_fail("cap_guest_nested", "netcap begin failed", 1);
        }
        net_h = fx_guest_mint_netcap(ctx, "127.0.0.1", 8080, 8080);
        if (net_h == 0) {
            (void)fx_guest_end(ctx);
            return fx_cli_fail("cap_guest_nested", "mint_netcap failed", 1);
        }
        if (fx_netcap_allows(net_h, "127.0.0.1", 8080) != 1) {
            (void)fx_guest_end(ctx);
            return fx_cli_fail("cap_guest_nested", "netcap allow expected", 1);
        }
        if (fx_netcap_allows(net_h, "127.0.0.1", 8081) != 0) {
            (void)fx_guest_end(ctx);
            return fx_cli_fail("cap_guest_nested", "netcap port deny expected", 1);
        }
        if (fx_netcap_allows(net_h, "evil.example", 8080) != 0) {
            (void)fx_guest_end(ctx);
            return fx_cli_fail("cap_guest_nested", "netcap host deny expected", 1);
        }
        (void)fx_guest_end(ctx);
        if (fx_netcap_allows(net_h, "127.0.0.1", 8080) != 0) {
            return fx_cli_fail("cap_guest_nested", "netcap stale deny expected", 1);
        }
        if (fx_guest_mint_netcap(ctx, "127.0.0.1", 1, 1) != 0) {
            return fx_cli_fail("cap_guest_nested", "mint on dead guest should fail", 1);
        }
    }

    return 0;
}

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    return run_nested_probe();
}
