// Week-two tool: Map tally + dense iterate + StrBuilder report → exit 42
import std/map;
import std/string;
import std/io;

fn main() -> i32 effects { alloc, mut, io } {
    region r = arena(16384);

    // Simulated category tallies - accumulate with map.add_i32.
    let m: Map<string, i32> = map.new();
    m = map.add_i32(m, "ok", 10);
    m = map.add_i32(m, "warn", 7);
    m = map.add_i32(m, "err", 20);
    m = map.add_i32(m, "warn", 5);

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
