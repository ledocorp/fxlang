// Caps-shaped guest library (host mints FsCap).
// No ambient std/io. Build with --host host.c --link host/cap/fx_cap_runtime.c
module guest_lib;

using core;
import std/cap;

/// Guest entry under a host-minted FsCap (sandbox authority).
fn run(_fs: FsCap) -> Result<i32, core_Err> {
    return Ok(42);
}
