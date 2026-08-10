// std/net - TCP dial under NetCap. TLS refused for now.
module net;

using core;
import std/cap;

extern "c" {
    effects { alloc, io } fn fx_netcap_dial(
        net_handle: i64,
        host: string,
        port: i32,
        want_tls: i32
    ) -> i64;
    effects { alloc, io } fn fx_netcap_close(sock_handle: i64) -> i32;
}

/// TCP dial under NetCap allowlist. Err(5) deny/fail.
fn dial(n: NetCap, host: string, port: i32) -> Result<i64, core_Err> effects { alloc, io } {
    let h: i64 = fx_netcap_dial(cap.net_handle(n), host, port, 0);
    if (h == 0) {
        return Err(5);
    }
    return Ok(h);
}

/// TLS dial - unsupported (always Err(6)).
fn dial_tls(n: NetCap, host: string, port: i32) -> Result<i64, core_Err> effects { alloc, io } {
    let h: i64 = fx_netcap_dial(cap.net_handle(n), host, port, 1);
    if (h == 0) {
        return Err(6);
    }
    return Ok(h);
}

fn close(sock: i64) -> Result<i32, core_Err> effects { alloc, io } {
    if (fx_netcap_close(sock) != 0) {
        return Err(1);
    }
    return Ok(0);
}
