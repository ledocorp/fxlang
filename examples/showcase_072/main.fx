// 0.7.2 showcase - Map iterate + Vec v[i] → exit 42
import std/vec;
import std/map;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(8192);

    let m: Map<string, i32> = map.new();
    m = map.insert(m, "a", 10);
    m = map.insert(m, "b", 12);
    m = map.insert(m, "c", 20);
    let sum: i32 = 0;
    let i: i32 = 0;
    while (i < map.len(m)) {
        sum = sum + map.nth_value(m, i);
        i = i + 1;
    }
    if (sum != 42) {
        return 1;
    }

    let v: Vec<i32> = vec.new(0);
    v = vec.push(v, 40);
    v = vec.push(v, 2);
    return v[0] + v[1];
}
