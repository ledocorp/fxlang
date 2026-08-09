// Guest has no ambient io; host minted the bytes.
// Same region physics; authority stays at the C host boundary.
using core;

/// Pure score: 42 for "ok…", else 3 (guest reject code).
/// No `effects { io }` - guest cannot open files.
fn score(src: string) -> i32 {
    if (str_len(src) < 2) {
        return 3;
    }
    // 'o' == 111, 'k' == 107
    if (str_byte_at(src, 0) != 111) {
        return 3;
    }
    if (str_byte_at(src, 1) != 107) {
        return 3;
    }
    return 42;
}

/// Host-facing Result wrapper (emit-C ABI).
fn run(src: string) -> Result<i32, core_Err> {
    let s: i32 = score(src);
    if (s == 42) {
        return Ok(42);
    }
    return Err(s);
}
