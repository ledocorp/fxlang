/* Optional NetCap allow + llhttp parse (host/cap + host/cli).
 *
 * Usage: prog
 * Exit: 0 success · 1 internal
 *
 * Flow: mint NetCap(example.com:443) → allows → parse Content-Length 42.
 * No dial/sockets (parse-only WRAP + NetCap allowlist).
 */
#include "../../host/cli/fx_cli_host.h"
#include "../../host/cap/fx_cap_runtime.h"

#include <stdint.h>
#include <stdio.h>

int32_t fx_llhttp_req_content_length(const char *req);
int32_t fx_llhttp_req_ok(const char *req);

static const char *kReq =
    "GET /x HTTP/1.1\r\nHost: example.com\r\nContent-Length: 42\r\n\r\n";

static int run_probe(void) {
    int64_t ctx;
    int64_t net;
    int32_t n;

    ctx = fx_guest_begin("", 4096);
    if (ctx == 0) {
        return fx_cli_fail("wrap_llhttp", "guest_begin failed", 1);
    }
    net = fx_guest_mint_netcap(ctx, "example.com", 443, 443);
    if (net == 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_llhttp", "mint_netcap failed", 1);
    }
    if (fx_netcap_allows(net, "example.com", 443) != 1) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_llhttp", "netcap allow expected", 1);
    }
    if (fx_netcap_allows(net, "evil.example", 443) != 0) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_llhttp", "netcap host deny expected", 1);
    }

    if (fx_llhttp_req_ok(kReq) != 1) {
        (void)fx_guest_end(ctx);
        return fx_cli_fail("wrap_llhttp", "req_ok failed", 1);
    }
    n = fx_llhttp_req_content_length(kReq);
    (void)fx_guest_end(ctx);
    if (n != 42) {
        return fx_cli_fail("wrap_llhttp", "content-length expected 42", 1);
    }
    return 0;
}

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    return run_probe();
}
