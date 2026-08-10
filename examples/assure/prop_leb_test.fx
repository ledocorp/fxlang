// LEB128 (SoT: validation/reference/leb128_corpus.tsv).
using core;
import std/testing;
import std/vec;
import leb128;

fn test_leb_0() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(64 * 1024);
    let enc = leb128.encode_u(0);
    let _a = testing.assert_eq_i32(vec.len(enc), 1)?;
    let _b = testing.assert_eq_i32(enc[0], 0)?;
    let d = leb128.decode_u(enc);
    return testing.assert_eq_i32(d, 0);
}

fn test_leb_624485() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(64 * 1024);
    let enc = leb128.encode_u(624485);
    let _a = testing.assert_eq_i32(vec.len(enc), 3)?;
    let _b = testing.assert_eq_i32(enc[0], 0xE5)?;
    let _c = testing.assert_eq_i32(enc[1], 0x8E)?;
    let _d = testing.assert_eq_i32(enc[2], 0x26)?;
    let got = leb128.decode_u(enc);
    return testing.assert_eq_i32(got, 624485);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_leb_0()?;
    let _b = test_leb_624485()?;
    return Ok(0);
}
