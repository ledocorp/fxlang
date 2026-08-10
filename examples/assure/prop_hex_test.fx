// hex round-trip (SoT: validation/reference/hexcodec_corpus.tsv).
using core;
import std/testing;
import std/vec;
import hexcodec;

fn test_deadbeef_roundtrip() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(64 * 1024);
    let b: Vec<i32> = vec.new(0);
    b = vec.push(b, 0xDE);
    b = vec.push(b, 0xAD);
    b = vec.push(b, 0xBE);
    b = vec.push(b, 0xEF);
    let h = hexcodec.encode(b);
    let back = hexcodec.decode(h);
    let _a = testing.assert_eq_i32(vec.len(back), 4)?;
    let _b = testing.assert_eq_i32(back[0], 0xDE)?;
    let _c = testing.assert_eq_i32(back[3], 0xEF)?;
    return Ok(0);
}

fn test_ff_roundtrip() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(64 * 1024);
    let b: Vec<i32> = vec.new(0);
    b = vec.push(b, 0xFF);
    let h = hexcodec.encode(b);
    let back = hexcodec.decode(h);
    return testing.assert_eq_i32(back[0], 0xFF);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_deadbeef_roundtrip()?;
    let _b = test_ff_roundtrip()?;
    return Ok(0);
}
