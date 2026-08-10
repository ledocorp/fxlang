// Verification campaign / Wave B - hex encode/decode (lowercase, base16).
// Bytes <-> ASCII hex character codes over `Vec<i32>`. A small, ubiquitous codec
// (debug dumps, literal tooling) and a self-hosting primitive. Exercises nibble
// shifts/masks and a two-output-per-input encode loop (heap-threaded via `alloc`).
// Canonical: [0xDE,0xAD,0xBE,0xEF] <-> "deadbeef". Round-trip cross-checked by
// OCaml + Haskell over validation/reference/hexcodec_corpus.tsv.
module hexcodec;

// Nibble value (0..15) -> lowercase hex ASCII code ('0'..'9','a'..'f').
fn nibble_to_hex(n: i32) -> i32 {
    if (n < 10) {
        return 0x30 + n;
    }
    return 0x61 + (n - 10);
}

// Hex ASCII code -> nibble value (0..15); assumes a valid digit or 'a'..'f'.
fn hex_to_nibble(c: i32) -> i32 {
    if (c <= 0x39) {
        return c - 0x30;
    }
    return (c - 0x61) + 10;
}

// Encode a byte vector to a vector of lowercase hex character codes (2 per byte).
fn encode(bytes: Vec<i32>) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let i: i32 = 0;
    let n: i32 = bytes.len;
    while (i < n) {
        let b: i32 = vec_get(bytes, i);
        let hi: i32 = (b >> 4) & 0xF;
        let lo: i32 = b & 0xF;
        out = vec_push(out, nibble_to_hex(hi));
        out = vec_push(out, nibble_to_hex(lo));
        i = i + 1;
    }
    return out;
}

// Decode a vector of hex character codes back to bytes (2 chars per byte).
fn decode(hex: Vec<i32>) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let i: i32 = 0;
    let n: i32 = hex.len;
    while (i + 1 < n) {
        let hi: i32 = hex_to_nibble(vec_get(hex, i));
        let lo: i32 = hex_to_nibble(vec_get(hex, i + 1));
        let b: i32 = (hi << 4) | lo;
        out = vec_push(out, b);
        i = i + 2;
    }
    return out;
}
