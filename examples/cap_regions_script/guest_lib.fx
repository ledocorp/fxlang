// FX-DYN-1 scripting surface: guest takes FsCap + bytes (no ambient io).
// Host minted the cap and performed the rooted read.
using core;
import std/cap;

/// Pure score: 42 for "ok…", else 3 (guest reject).
fn score(src: string) -> i32 {
    if (str_len(src) < 2) {
        return 3;
    }
    if (str_byte_at(src, 0) != 111) {
        return 3;
    }
    if (str_byte_at(src, 1) != 107) {
        return 3;
    }
    return 42;
}

/// Host-facing entry: FsCap is present on the ABI (copyable handle); bytes already minted.
fn run(fs: FsCap, src: string) -> Result<i32, core_Err> {
    let _h: i64 = cap.fs_handle(fs);
    let s: i32 = score(src);
    if (s == 42) {
        return Ok(42);
    }
    return Err(s);
}
