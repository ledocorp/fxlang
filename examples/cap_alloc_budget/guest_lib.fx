// FX-DYN-3 — guest allocates only through a minted AllocCap.
// Soft-fx refused: same bump arena; authority = budget token.
using core;
import std/cap;
import std/guest;

/// Bump-alloc `nbytes` under AllocCap. Err(5) = denied / over-budget / revoked.
fn try_alloc(a: AllocCap, nbytes: i64) -> Result<i32, core_Err> effects { alloc } {
    let _p: i64 = guest.alloc(a, nbytes)?;
    return Ok(42);
}
