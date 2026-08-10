// std/encoding - hex + base64 over Vec<i32> byte codes.
// Corpora: validation/reference/{hexcodec,base64}_corpus.tsv
module encoding;

using core;

fn nibble_to_hex(n: i32) -> i32 {
    if (n < 10) {
        return 0x30 + n;
    }
    return 0x61 + (n - 10);
}

fn hex_to_nibble(c: i32) -> i32 {
    if (c <= 0x39) {
        return c - 0x30;
    }
    return (c - 0x61) + 10;
}

fn hex_encode(bytes: Vec<i32>) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let i: i32 = 0;
    let n: i32 = bytes.len;
    while (i < n) {
        let b: i32 = vec_get(bytes, i);
        out = vec_push(out, nibble_to_hex((b >> 4) & 0xF));
        out = vec_push(out, nibble_to_hex(b & 0xF));
        i = i + 1;
    }
    return out;
}

fn hex_decode(hex: Vec<i32>) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let i: i32 = 0;
    let n: i32 = hex.len;
    while (i + 1 < n) {
        let hi: i32 = hex_to_nibble(vec_get(hex, i));
        let lo: i32 = hex_to_nibble(vec_get(hex, i + 1));
        out = vec_push(out, (hi << 4) | lo);
        i = i + 2;
    }
    return out;
}

fn b64_enc_char(v: i32) -> i32 {
    if (v < 26) {
        return 0x41 + v;
    }
    if (v < 52) {
        return 0x61 + (v - 26);
    }
    if (v < 62) {
        return 0x30 + (v - 52);
    }
    if (v == 62) {
        return 0x2B;
    }
    return 0x2F;
}

fn b64_dec_val(c: i32) -> i32 {
    if (c == 0x2B) {
        return 62;
    }
    if (c == 0x2F) {
        return 63;
    }
    if (c <= 0x39) {
        return (c - 0x30) + 52;
    }
    if (c <= 0x5A) {
        return c - 0x41;
    }
    return (c - 0x61) + 26;
}

fn base64_encode(bytes: Vec<i32>) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let n: i32 = bytes.len;
    let i: i32 = 0;
    while (i + 3 <= n) {
        let b0: i32 = vec_get(bytes, i);
        let b1: i32 = vec_get(bytes, i + 1);
        let b2: i32 = vec_get(bytes, i + 2);
        out = vec_push(out, b64_enc_char(b0 >> 2));
        out = vec_push(out, b64_enc_char(((b0 & 0x3) << 4) | (b1 >> 4)));
        out = vec_push(out, b64_enc_char(((b1 & 0xF) << 2) | (b2 >> 6)));
        out = vec_push(out, b64_enc_char(b2 & 0x3F));
        i = i + 3;
    }
    let rem: i32 = n - i;
    if (rem == 1) {
        let b0: i32 = vec_get(bytes, i);
        out = vec_push(out, b64_enc_char(b0 >> 2));
        out = vec_push(out, b64_enc_char((b0 & 0x3) << 4));
        out = vec_push(out, 0x3D);
        out = vec_push(out, 0x3D);
    } else {
        if (rem == 2) {
            let b0: i32 = vec_get(bytes, i);
            let b1: i32 = vec_get(bytes, i + 1);
            out = vec_push(out, b64_enc_char(b0 >> 2));
            out = vec_push(out, b64_enc_char(((b0 & 0x3) << 4) | (b1 >> 4)));
            out = vec_push(out, b64_enc_char((b1 & 0xF) << 2));
            out = vec_push(out, 0x3D);
        }
    }
    return out;
}

fn base64_decode(text: Vec<i32>) -> Vec<i32> effects { alloc, mut } {
    let out: Vec<i32> = vec_new(0);
    let n: i32 = text.len;
    let i: i32 = 0;
    while (i + 4 <= n) {
        let c0: i32 = vec_get(text, i);
        let c1: i32 = vec_get(text, i + 1);
        let c2: i32 = vec_get(text, i + 2);
        let c3: i32 = vec_get(text, i + 3);
        let v0: i32 = b64_dec_val(c0);
        let v1: i32 = b64_dec_val(c1);
        out = vec_push(out, ((v0 << 2) | (v1 >> 4)) & 0xFF);
        if (c2 != 0x3D) {
            let v2: i32 = b64_dec_val(c2);
            out = vec_push(out, (((v1 & 0xF) << 4) | (v2 >> 2)) & 0xFF);
            if (c3 != 0x3D) {
                let v3: i32 = b64_dec_val(c3);
                out = vec_push(out, (((v2 & 0x3) << 6) | v3) & 0xFF);
            }
        }
        i = i + 4;
    }
    return out;
}
