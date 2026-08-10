/* TCP dial under NetCap allowlist (no TLS). */
#if !defined(_WIN32)
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200112L
#endif
#endif

#include "fx_cap_runtime.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>
#include <ws2tcpip.h>
#pragma comment(lib, "ws2_32.lib")
typedef SOCKET fx_sock_t;
#define FX_SOCK_INVALID INVALID_SOCKET
#else
#include <arpa/inet.h>
#include <errno.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
typedef int fx_sock_t;
#define FX_SOCK_INVALID (-1)
#endif

static int g_wsa_ready = 0;

static int ensure_net(void) {
#if defined(_WIN32)
    WSADATA wsa;
    if (g_wsa_ready) {
        return 1;
    }
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        return 0;
    }
    g_wsa_ready = 1;
    return 1;
#else
    (void)g_wsa_ready;
    return 1;
#endif
}

/* Returns socket handle bits, or 0 on deny/fail. TLS not supported (always 0 if tls!=0). */
int64_t fx_netcap_dial(int64_t net_handle, const char *host, int32_t port, int32_t want_tls) {
    char portbuf[16];
    struct addrinfo hints;
    struct addrinfo *res = NULL;
    struct addrinfo *rp;
    fx_sock_t sock = FX_SOCK_INVALID;
    int rc;

    if (want_tls != 0) {
        /* TLS bar: not in this land - allowlist TCP only. */
        return 0;
    }
    if (host == NULL || host[0] == '\0' || port <= 0 || port > 65535) {
        return 0;
    }
    if (!fx_netcap_allows(net_handle, host, (int)port)) {
        return 0;
    }
    if (!ensure_net()) {
        return 0;
    }

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    snprintf(portbuf, sizeof(portbuf), "%d", (int)port);
    rc = getaddrinfo(host, portbuf, &hints, &res);
    if (rc != 0 || res == NULL) {
        return 0;
    }
    for (rp = res; rp != NULL; rp = rp->ai_next) {
        sock = (fx_sock_t)socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (sock == FX_SOCK_INVALID) {
            continue;
        }
        if (connect(sock, rp->ai_addr, (int)rp->ai_addrlen) == 0) {
            break;
        }
#if defined(_WIN32)
        closesocket(sock);
#else
        close(sock);
#endif
        sock = FX_SOCK_INVALID;
    }
    freeaddrinfo(res);
    if (sock == FX_SOCK_INVALID) {
        return 0;
    }
    return (int64_t)(intptr_t)sock;
}

int32_t fx_netcap_close(int64_t sock_handle) {
    fx_sock_t s;
    if (sock_handle == 0) {
        return 1;
    }
    s = (fx_sock_t)(intptr_t)sock_handle;
#if defined(_WIN32)
    if (closesocket(s) != 0) {
        return 1;
    }
#else
    if (close(s) != 0) {
        return 1;
    }
#endif
    return 0;
}
