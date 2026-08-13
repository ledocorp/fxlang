/* HTTP GET smoke over an already-open TLS FxNetConn handle. */
#include "fx_cap_runtime.h"

#include <stdint.h>
#include <string.h>

/* Returns 42 if response looks like HTTP; else 0. */
int32_t fx_net_tls_http_get_smoke(int64_t sock_handle) {
    static const char req[] = "GET / HTTP/1.0\r\nHost: localhost\r\n\r\n";
    char buf[512];
    int32_t n;
    int32_t got = 0;

    n = fx_netcap_write(sock_handle, req, (int32_t)(sizeof(req) - 1));
    if (n != (int32_t)(sizeof(req) - 1)) {
        return 0;
    }
    memset(buf, 0, sizeof(buf));
    while (got < (int32_t)sizeof(buf) - 1) {
        n = fx_netcap_read(sock_handle, buf + got, (int32_t)sizeof(buf) - 1 - got);
        if (n < 0) {
            return 0;
        }
        if (n == 0) {
            break;
        }
        got += n;
        if (got >= 4 && memcmp(buf, "HTTP", 4) == 0) {
            return 42;
        }
    }
    if (got >= 4 && memcmp(buf, "HTTP", 4) == 0) {
        return 42;
    }
    return 0;
}
