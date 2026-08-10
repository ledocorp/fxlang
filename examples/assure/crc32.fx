// Verification campaign / Wave A - CRC-32/ISO-HDLC (IEEE 802.3), bitwise (no
// table). Canonical known-answer: CRC32("123456789") == 0xCBF43926.
//
// A pure, no-alloc Tier 1 kernel that is also a self-hosting primitive (framing,
// integrity). Exercises the new shift (`<<`/`>>`) and hex-literal primitives plus
// i64 arithmetic. Reference implementations in Haskell/OCaml (see
// `validation/crc32/`) and the emitted C are diffed against these vectors.
module crc32;

// Initial CRC register: all ones (0xFFFFFFFF).
fn init() -> i64 {
    return 0xFFFFFFFF;
}

// Fold one input byte into the running CRC (reflected polynomial 0xEDB88320).
fn update(crc: i64, byte: i32) -> i64 {
    let c: i64 = crc ^ byte;
    let i: i32 = 0;
    while (i < 8) {
        if ((c & 1) == 1) {
            c = (c >> 1) ^ 0xEDB88320;
        } else {
            c = c >> 1;
        }
        i = i + 1;
    }
    return c;
}

// Final reflection: XOR the register with all ones.
fn finish(crc: i64) -> i64 {
    return crc ^ 0xFFFFFFFF;
}
