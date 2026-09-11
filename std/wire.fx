// std/wire - endian load/store over Vec<i32> byte codes.
// Protocol tables: little/big u16/u32; short buffer → Err. Not a full codec kit.
module wire;

using core;

fn load_u16_le(bytes: Vec<i32>, off: i32) -> Result<i32, core_Err> {
    if (off < 0) {
        return Err(1);
    }
    if (off + 1 >= bytes.len) {
        return Err(2);
    }
    let lo: i32 = vec_get(bytes, off) & 0xFF;
    let hi: i32 = vec_get(bytes, off + 1) & 0xFF;
    return Ok(lo | (hi << 8));
}

fn load_u16_be(bytes: Vec<i32>, off: i32) -> Result<i32, core_Err> {
    if (off < 0) {
        return Err(1);
    }
    if (off + 1 >= bytes.len) {
        return Err(2);
    }
    let hi: i32 = vec_get(bytes, off) & 0xFF;
    let lo: i32 = vec_get(bytes, off + 1) & 0xFF;
    return Ok(lo | (hi << 8));
}

fn load_u32_le(bytes: Vec<i32>, off: i32) -> Result<i32, core_Err> {
    if (off < 0) {
        return Err(1);
    }
    if (off + 3 >= bytes.len) {
        return Err(2);
    }
    let b0: i32 = vec_get(bytes, off) & 0xFF;
    let b1: i32 = vec_get(bytes, off + 1) & 0xFF;
    let b2: i32 = vec_get(bytes, off + 2) & 0xFF;
    let b3: i32 = vec_get(bytes, off + 3) & 0xFF;
    return Ok(b0 | (b1 << 8) | (b2 << 16) | (b3 << 24));
}

fn store_u16_le(bytes: Vec<i32>, off: i32, v: i32) -> Result<Vec<i32>, core_Err> effects { mut } {
    if (off < 0) {
        return Err(1);
    }
    if (off + 1 >= bytes.len) {
        return Err(2);
    }
    let out0: Vec<i32> = vec_set(bytes, off, v & 0xFF);
    let out1: Vec<i32> = vec_set(out0, off + 1, (v >> 8) & 0xFF);
    return Ok(out1);
}

fn consume_u16_le(bytes: Vec<i32>, off: i32) -> Result<i32, core_Err> {
    return load_u16_le(bytes, off);
}
