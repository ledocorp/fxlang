// std/testing - production asserts + stderr diagnostics.
module testing;

using core;
import std/io;

fn assert_true(cond: bool) -> Result<i32, core_Err> effects { io } {
    if (!cond) {
        let _w = io.write_err("testing: assert_true failed");
        return Err(1);
    }
    return Ok(0);
}

fn assert_eq_i32(a: i32, b: i32) -> Result<i32, core_Err> effects { io } {
    if (a != b) {
        let _w = io.write_err("testing: assert_eq_i32 failed");
        return Err(2);
    }
    return Ok(0);
}

fn assert_eq_i64(a: i64, b: i64) -> Result<i32, core_Err> effects { io } {
    if (a != b) {
        let _w = io.write_err("testing: assert_eq_i64 failed");
        return Err(3);
    }
    return Ok(0);
}

fn expect_ok_i32(r: Result<i32, core_Err>) -> Result<i32, core_Err> effects { io } {
    // Propagate; callers should use ? - on Err print once here if needed.
    return r;
}

fn fail(msg: string) -> Result<i32, core_Err> effects { io } {
    let _w = io.write_err(msg);
    return Err(9);
}
