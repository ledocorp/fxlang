// demo: named region + vec (Go-feel lifetimes, not a GC).
// Run: fx run examples/showcase_core/main.fx

import std/vec;

fn sum_nonneg(a: i32, b: i32) -> i32 {
    if (a < 0) {
        return -1;
    }
    if (b < 0) {
        return -1;
    }
    return a + b;
}

fn main() -> i32 effects { alloc, mut } {
    region r = arena(2048);
    let v: Vec<i32> = vec.new(0);
    let v2: Vec<i32> = vec.push(v, 40);
    let v3: Vec<i32> = vec.push(v2, 2);
    let n: i32 = sum_nonneg(vec.get(v3, 0), vec.get(v3, 1));
    if (n < 0) {
        return 1;
    }
    return n;
}
