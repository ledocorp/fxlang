// FX-0.8-UX-3 / UX-3b — route desk stock helpers (Map-returning; IR multi-module).
// Callers create the Map in entry; helpers transform/query (region threaded by UX-3b).
import std/map;
import std/string;

fn seed(m: Map<string, i32>) -> Map<string, i32> effects { alloc, mut } {
    m = map.add_i32(m, "dock", 10);
    m = map.add_i32(m, "aisle", 12);
    m = map.add_i32(m, "yard", 8);
    return m;
}

fn receive(m: Map<string, i32>, bin: string, qty: i32) -> Map<string, i32> effects { alloc, mut } {
    return map.add_i32(m, bin, qty);
}

fn scrap_bin(m: Map<string, i32>, bin: string) -> Map<string, i32> effects { alloc, mut } {
    return map.remove(m, bin);
}

fn total(m: Map<string, i32>) -> i32 {
    let sum: i32 = 0;
    let i: i32 = 0;
    while (i < map.len(m)) {
        sum = sum + map.nth_value(m, i);
        i = i + 1;
    }
    return sum;
}

fn qty_at(m: Map<string, i32>, bin: string) -> i32 {
    let i: i32 = 0;
    while (i < map.len(m)) {
        if (string.compare(map.nth_key(m, i), bin)) {
            return map.nth_value(m, i);
        }
        i = i + 1;
    }
    return 0 - 1;
}
