// grow phase, then read-only walk (“freeze by convention”).
// Until Growing/Frozen phase types land (D3), discipline = no further push after freeze.
// Run: fx run examples/pattern_grow_freeze/main.fx  → exit 42
import std/vec;

fn sum_frozen(v: Vec<i32>) -> i32 {
    let n: i32 = v.len;
    let i: i32 = 0;
    let acc: i32 = 0;
    while (i < n) {
        acc = acc + v[i];
        i = i + 1;
    }
    return acc;
}

fn main() -> i32 effects { alloc, mut } {
    region r = arena(2048);

    // --- growing phase ---
    let v: Vec<i32> = vec.new(0);
    v = vec.push(v, 10);
    v = vec.push(v, 20);
    v = vec.push(v, 12);
    // --- frozen by convention: only reads below ---

    return sum_frozen(v);
}
