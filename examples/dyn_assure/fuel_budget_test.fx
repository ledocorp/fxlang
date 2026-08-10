// FuelCap burn + over-fuel deny.
using core;
import std/testing;
import std/guest;
import std/cap;

fn test_fuel() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin(".", 4096)?;
    let f = guest.mint_fuel(g, 3 as i64)?;
    let ok1 = guest.burn_ok(f, 2 as i64);
    let ok2 = guest.burn_ok(f, 2 as i64);
    let _e = guest.end(g)?;
    let _a = testing.assert_true(ok1 != 0)?;
    return testing.assert_eq_i32(ok2, 0);
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let _a = test_fuel()?;
    return Ok(0);
}
