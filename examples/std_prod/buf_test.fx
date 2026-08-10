// buf smoke.
using core;
import std/testing;
import std/buf;

fn test_buf() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(4096);
    let b0 = buf.new();
    let b1 = buf.push(b0, 1 as u8);
    let b2 = buf.push(b1, 2 as u8);
    return testing.assert_eq_i32(buf.len(b2), 2);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_buf()?;
    return Ok(0);
}
