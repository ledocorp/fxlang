// hex + base64 roundtrip.
using core;
import std/testing;
import std/encoding;

fn test_hex_deadbeef() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(4096);
    let b: Vec<i32> = vec_new(0);
    b = vec_push(b, 0xDE);
    b = vec_push(b, 0xAD);
    b = vec_push(b, 0xBE);
    b = vec_push(b, 0xEF);
    let hex = encoding.hex_encode(b);
    let back = encoding.hex_decode(hex);
    return testing.assert_eq_i32(vec_get(back, 0), 0xDE);
}

fn test_base64_foobar() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(4096);
    // "fo" = 0x66 0x6F
    let b: Vec<i32> = vec_new(0);
    b = vec_push(b, 0x66);
    b = vec_push(b, 0x6F);
    let enc = encoding.base64_encode(b);
    let back = encoding.base64_decode(enc);
    let _a = testing.assert_eq_i32(back.len, 2)?;
    return testing.assert_eq_i32(vec_get(back, 0), 0x66);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_hex_deadbeef()?;
    let _b = test_base64_foobar()?;
    return Ok(0);
}
