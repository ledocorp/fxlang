// /2 - NetCap allowlist (no dial).
using core;
import std/testing;
import std/guest;
import std/cap;

fn test_net_allow_deny() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin(".", 4096)?;
    let n = guest.mint_net(g, "example.com", 80, 443)?;
    let allowed = guest.net_allows(n, "example.com", 443);
    let denied = guest.net_allows(n, "evil.com", 443);
    let bad_port = guest.net_allows(n, "example.com", 22);
    let _e = guest.end(g)?;
    let _a = testing.assert_eq_i32(allowed, 1)?;
    let _b = testing.assert_eq_i32(denied, 0)?;
    return testing.assert_eq_i32(bad_port, 0);
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let _a = test_net_allow_deny()?;
    return Ok(0);
}
