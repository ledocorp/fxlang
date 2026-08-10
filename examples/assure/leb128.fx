// Verification campaign / Wave B - LEB128 variable-length integers.
// A full fx rewrite of the Rust `leb128` crate's core: unsigned encode/decode over
// a byte `Vec<i32>`, plus signed <-> unsigned via zigzag. A genuine self-hosting
// primitive (varints for any bytecode/IR a self-hosted fx would emit) and the
// campaign's designated Rust-rewrite target.
//
// Values are `i32` because the builtin `Vec` element type is currently `i32`
// (widening the byte buffer to `Vec<i64>` is the tracked follow-up VEC-I64); the
// algorithm is width-agnostic. Canonical: unsigned(624485) -> [0xE5, 0x8E, 0x26].
// All shifts are applied only to non-negative values (zigzag guards the sign), so
// the emitted C is free of signed-shift/overflow UB. Round-trip is proven in fx
// (programs/p2_leb128.fx), emitted C, OCaml, Haskell, and a Rust proptest.
module leb128;

// Encode a non-negative value as LEB128 bytes (7 data bits per byte, high bit =
// "more follow"). Always emits at least one byte (0 -> [0x00]). The growable
// byte buffer lives in the caller's arena, threaded via the `alloc` effect.
fn encode_u(value: i32) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let v: i32 = value;
    let more: bool = true;
    while (more) {
        let byte: i32 = v & 0x7F;
        v = v >> 7;
        if (v != 0) {
            byte = byte | 0x80;
        } else {
            more = false;
        }
        out = vec_push(out, byte);
    }
    return out;
}

// Decode a byte vector holding exactly one LEB128 unsigned value.
fn decode_u(bytes: Vec<i32>) -> i32 effects { alloc } {
    let result: i32 = 0;
    let shift: i32 = 0;
    let i: i32 = 0;
    let n: i32 = bytes.len;
    while (i < n) {
        let b: i32 = vec_get(bytes, i);
        let low: i32 = b & 0x7F;
        result = result | (low << shift);
        shift = shift + 7;
        i = i + 1;
    }
    return result;
}

// Map a signed value to an unsigned zigzag code (small |n| -> small code).
// Shifts only non-negative operands, so no signed-shift UB.
fn zigzag(n: i32) -> i32 {
    if (n >= 0) {
        return n << 1;
    }
    return ((-n) << 1) - 1;
}

// Inverse of `zigzag`.
fn unzigzag(z: i32) -> i32 {
    if ((z & 1) == 0) {
        return z >> 1;
    }
    return -((z >> 1) + 1);
}
