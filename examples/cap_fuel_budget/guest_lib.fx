// guest burns units only through a minted FuelCap.
// Soft-fx refused: same physics; authority = fuel token.
using core;
import std/cap;
import std/guest;

/// Burn `units` under FuelCap. Err(5) = denied / over-fuel / revoked.
fn try_burn(f: FuelCap, units: i64) -> Result<i32, core_Err> effects { alloc } {
    let _z: i32 = guest.burn(f, units)?;
    return Ok(42);
}
