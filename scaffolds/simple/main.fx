// Simple scaffold (recommended): visible heap, not a GC.
//   effects { alloc, mut }  states heap + mutation
//   region r = arena(n)     named lifetime; free when r ends
//   import std/vec          staged std/ beside this project (or FX_STD_ROOT)
// Grow: let-chains teach value-threading. Quieter patterns (same semantics):
//   v = vec.push(v, x);              // loop / accumulator reassignment
//   p.nodes = vec.push(p.nodes, x);  // &mut state field update

import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    let v: Vec<i32> = vec.new(0);
    let v2: Vec<i32> = vec.push(v, 40);
    let v3: Vec<i32> = vec.push(v2, 2);
    return vec.get(v3, 0) + vec.get(v3, 1);
}
