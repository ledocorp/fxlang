// TLS unsupported; off-allowlist dial denied.
using core;
import std/guest;
import std/cap;

extern "c" {
    effects { alloc, io } fn fx_netcap_dial(
        net_handle: i64,
        host: string,
        port: i32,
        want_tls: i32
    ) -> i64;
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin("", 4096)?;
    let net = guest.mint_net(g, "example.com", 80, 80)?;
    // TLS always refused.
    if (fx_netcap_dial(cap.net_handle(net), "example.com", 80, 1) != 0) {
        let _e = guest.end(g)?;
        return Err(1);
    }
    // Off-allowlist host denied even for TCP.
    if (fx_netcap_dial(cap.net_handle(net), "127.0.0.1", 80, 0) != 0) {
        let _e = guest.end(g)?;
        return Err(2);
    }
    let _e = guest.end(g)?;
    return Ok(0);
}
