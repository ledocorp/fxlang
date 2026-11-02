// std/wire foothold smoke (T0 teaching; prefer --emit-c).
// Expect exit 42 on emit-C (and Auto when IR ambient region works).
import std/wire;

fn main() -> Result<i32, core_Err> effects { alloc, mut } {
    region r = arena(2048);
    let b: Vec<i32> = vec_new(0);
    let b1: Vec<i32> = vec_push(b, 0x2A);
    let b2: Vec<i32> = vec_push(b1, 0x00);
    let b3: Vec<i32> = vec_push(b2, 0x00);
    let b4: Vec<i32> = vec_push(b3, 0x00);
    let v: i32 = wire.load_u16_le(b4, 0)?;
    if (v != 42) {
        return Err(3);
    }
    let w: i32 = wire.load_u32_le(b4, 0)?;
    if (w != 42) {
        return Err(4);
    }
    let b5: Vec<i32> = wire.store_u16_le(b4, 0, 42)?;
    let v2: i32 = wire.consume_u16_le(b5, 0)?;
    if (v2 != 42) {
        return Err(5);
    }
    return Ok(42);
}
