// /2 - named test_* suite; main aggregates → exit 0.
using core;
import std/testing;

fn test_assert_true() -> Result<i32, core_Err> effects { io } {
    return testing.assert_true(1 == 1);
}

fn test_assert_eq() -> Result<i32, core_Err> effects { io } {
    return testing.assert_eq_i32(2 + 2, 4);
}

fn test_fail_msg() -> Result<i32, core_Err> effects { io } {
    // Diagnostics path: fail() writes stderr; we do not call it on success.
    return testing.assert_true(true);
}

fn main() -> Result<i32, core_Err> effects { io } {
    let _a = test_assert_true()?;
    let _b = test_assert_eq()?;
    let _c = test_fail_msg()?;
    return Ok(0);
}
