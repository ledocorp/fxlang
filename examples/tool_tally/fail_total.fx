// Expect exit 1: wrong tally must fail the total check pattern.
import std/map;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(16384);
    let m: Map<string, i32> = map.new();
    m = map.insert(m, "ok", 1);
    m = map.insert(m, "warn", 1);
    m = map.insert(m, "err", 1);
    let total: i32 = 0;
    let i: i32 = 0;
    while (i < map.len(m)) {
        total = total + map.nth_value(m, i);
        i = i + 1;
    }
    if (total != 42) {
        return 1;
    }
    return 99;
}
