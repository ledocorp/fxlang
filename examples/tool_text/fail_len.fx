// Expect exit 1: empty builder finishes to wrong length for tool_text path.
import std/string;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    let sb = string.builder();
    let s = string.build(sb);
    if (string.len(s) != 5) {
        return 1;
    }
    return 99;
}
