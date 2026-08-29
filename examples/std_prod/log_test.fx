// FX-PROD-STD-5 — log helpers return Ok.
using core;
import std/testing;
import std/log;

fn test_log_ok() -> Result<i32, core_Err> effects { io, alloc } {
    let _a = log.info("ok")?;
    let _b = log.warn("w")?;
    let _c = log.info_i32("n=", 1)?;
    return testing.assert_true(true);
}

fn main() -> Result<i32, core_Err> effects { io, alloc } {
    let _a = test_log_ok()?;
    return Ok(0);
}
