// Poison fixture for FX-DYN-4 harness scan (must NOT be linked as guest entry).
// Guest libs must use AllocCap (guest.alloc), not session bump.
using core;
import std/guest;

fn bad(g: GuestCtx) -> Result<i64, core_Err> effects { alloc } {
    return guest.alloc_bytes(g, 16);
}
