// FX-0.7.5-A3 — non-toy tally: multi-pass Map accumulate + adjust + dense walk → 42
// Uses map.add_i32 (A2). Regions + effects explicit; no unsafe.
import std/map;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(16384);

    // Pass 1 — ingest event categories (insert + accumulate).
    let m: Map<string, i32> = map.new();
    m = map.add_i32(m, "parse", 4);
    m = map.add_i32(m, "typeck", 6);
    m = map.add_i32(m, "emit", 8);
    m = map.add_i32(m, "parse", 3);
    m = map.add_i32(m, "link", 5);
    m = map.add_i32(m, "typeck", 2);

    // Pass 2 — budget adjustments (more accumulate; one overshoot then correct).
    m = map.add_i32(m, "emit", 10);
    m = map.add_i32(m, "link", 7);
    m = map.add_i32(m, "parse", -1);

    if (map.len(m) != 4) {
        return 1;
    }
    if (map.contains(m, "parse") != true) {
        return 2;
    }

    // Pass 3 — dense walk; expected: parse=6, typeck=8, emit=18, link=12 → 44, then trim.
    let sum: i32 = 0;
    let i: i32 = 0;
    while (i < map.len(m)) {
        sum = sum + map.nth_value(m, i);
        i = i + 1;
    }
    if (sum != 44) {
        return 3;
    }

    // Pass 4 — remove overshoot category contribution via remove + re-accumulate.
    m = map.remove(m, "link");
    m = map.add_i32(m, "link", 10);
    // parse=6 + typeck=8 + emit=18 + link=10 = 42

    let total: i32 = 0;
    i = 0;
    while (i < map.len(m)) {
        total = total + map.nth_value(m, i);
        i = i + 1;
    }
    if (total != 42) {
        return 4;
    }
    return total;
}
