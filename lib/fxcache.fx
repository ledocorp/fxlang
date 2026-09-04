// lib/fxcache.fx - fingerprint mix helpers for build cache dogfood.
// Product scratch/FXCACHE orchestration stays in foundry CLI (`fx_cache.rs`).
module fxcache;

fn seed() -> i32 {
    return 17;
}

fn mix_byte(h: i32, byte: i32) -> i32 {
    return h + (byte * 31);
}

fn mix_i32(h: i32, v: i32) -> i32 {
    return mix_byte(h, v);
}

fn mix_tag2(h: i32, a: i32, b: i32) -> i32 {
    return mix_byte(mix_byte(h, a), b);
}

fn digests(h: i32) -> i32 {
    return h;
}
