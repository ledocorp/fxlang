// AllocCap budget + over-budget deny (0 pointer).
using core;
import std/testing;
import std/guest;
import std/cap;

fn test_alloc_budget() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin(".", 4096)?;
    let a = guest.mint_alloc(g, 8 as i64)?;
    let p1 = guest.alloc_ptr(a, 8 as i64);
    let p2 = guest.alloc_ptr(a, 1 as i64);
    let _e = guest.end(g)?;
    let _ok = testing.assert_true(p1 != 0)?;
    return testing.assert_eq_i64(p2, 0 as i64);
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let _a = test_alloc_budget()?;
    return Ok(0);
}
