// deny + successful TLS GET against loopback fixture.
// Env: FX_TLS_TEST_PORT (required), FX_TLS_CA_FILE (required).
using core;
import std/guest;
import std/cap;
import std/net;
import std/env;

extern "c" {
    effects { alloc, io } fn fx_net_tls_http_get_smoke(sock_handle: i64) -> i32;
    effects { alloc, io } fn fx_netcap_dial(
        net_handle: i64,
        host: string,
        port: i32,
        want_tls: i32
    ) -> i64;
    effects { alloc, io } fn fx_netcap_last_error() -> i32;
}

fn parse_port(s: string) -> i32 {
    let nlen = str_len(s);
    let i: i32 = 0;
    let n: i32 = 0;
    while (i < nlen) {
        let c: i32 = str_byte_at(s, i);
        if (c < 48) {
            break;
        }
        if (c > 57) {
            break;
        }
        n = n * 10 + (c - 48);
        i = i + 1;
    }
    return n;
}

fn main() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let port_s = env.get("FX_TLS_TEST_PORT")?;
    let ca = env.get("FX_TLS_CA_FILE")?;
    let port = parse_port(port_s);
    if (port <= 0) {
        return Err(1);
    }
    let _caset = net.set_ca_file(ca)?;

    let g = guest.begin("", 4096)?;
    let netc = guest.mint_net(g, "localhost", port, port)?;

    // Deny: wrong host → last_error 5, handle 0
    let bad = fx_netcap_dial(cap.net_handle(netc), "example.com", port, 1);
    if (bad != 0) {
        let _e = guest.end(g)?;
        return Err(2);
    }
    if (fx_netcap_last_error() != 5) {
        let _e = guest.end(g)?;
        return Err(3);
    }

    let sock = net.dial_tls(netc, "localhost", port)?;
    let smoke = fx_net_tls_http_get_smoke(sock);
    let _cl = net.close(sock)?;
    if (smoke != 42) {
        let _e = guest.end(g)?;
        return Err(4);
    }

    let _e = guest.end(g)?;
    return Ok(42);
}
