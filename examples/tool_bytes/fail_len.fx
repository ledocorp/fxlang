// Expect exit 1: empty Buf length check.
import std/buf;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(8192);
    let b: Buf = buf.new();
    if (buf.len(b) != 4) {
        return 1;
    }
    return 99;
}
