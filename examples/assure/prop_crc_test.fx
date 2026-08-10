// CRC-32 (SoT: validation/reference/crc32_corpus.tsv).
using core;
import std/testing;
import crc32;

fn test_crc_123456789() -> Result<i32, core_Err> effects { io } {
    let crc: i64 = crc32.init();
    crc = crc32.update(crc, 0x31);
    crc = crc32.update(crc, 0x32);
    crc = crc32.update(crc, 0x33);
    crc = crc32.update(crc, 0x34);
    crc = crc32.update(crc, 0x35);
    crc = crc32.update(crc, 0x36);
    crc = crc32.update(crc, 0x37);
    crc = crc32.update(crc, 0x38);
    crc = crc32.update(crc, 0x39);
    let out: i64 = crc32.finish(crc);
    return testing.assert_eq_i64(out, 0xCBF43926);
}

fn test_crc_a() -> Result<i32, core_Err> effects { io } {
    let crc: i64 = crc32.init();
    crc = crc32.update(crc, 0x61);
    let out: i64 = crc32.finish(crc);
    return testing.assert_eq_i64(out, 0xE8B7BE43);
}

fn main() -> Result<i32, core_Err> effects { io } {
    let _a = test_crc_123456789()?;
    let _b = test_crc_a()?;
    return Ok(0);
}
