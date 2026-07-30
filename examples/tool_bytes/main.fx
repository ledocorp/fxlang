// Week-two tool: Buf / Bytes checksum-style sum → exit 42
// Message bytes: 'f','x','_','2' = 102+120+95+50 = 367; fold to 42 via checks.
import std/buf;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(8192);
    let b: Buf = buf.new();
    b = buf.push(b, 102);
    b = buf.push(b, 120);
    b = buf.push(b, 95);
    b = buf.push(b, 50);
    if (buf.len(b) != 4) {
        return 1;
    }
    let view = buf.finish(b);
    if (buf.view_len(view) != 4) {
        return 2;
    }
    let sum: i32 = 0;
    let i: i32 = 0;
    while (i < buf.view_len(view)) {
        sum = sum + (buf.view_get(view, i) as i32);
        i = i + 1;
    }
    if (sum != 367) {
        return 3;
    }
    // Tool-shaped exit: prove payload then return success code.
    return 42;
}
