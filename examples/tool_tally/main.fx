// Week-two tool: Map tally + dense iterate + StrBuilder report → exit 42
import std/map;
import std/string;
import std/io;

fn main() -> i32 effects { alloc, mut, io } {
    region r = arena(16384);

    // Simulated category tallies (as if tokens were already classified).
    let m: Map<string, i32> = map.new();
    m = map.insert(m, "ok", 10);
    m = map.insert(m, "warn", 12);
    m = map.insert(m, "err", 20);

    let total: i32 = 0;
    let i: i32 = 0;
    while (i < map.len(m)) {
        total = total + map.nth_value(m, i);
        i = i + 1;
    }
    if (total != 42) {
        return 1;
    }

    let b = string.builder();
    b = string.append(b, "tally=");
    // Keep report ASCII-simple; numeric fmt via known total.
    if (total == 42) {
        b = string.append(b, "42");
    }
    let report = string.build(b);
    io.write_line(report);

    return total;
}
