// Simple scaffold (recommended): visible heap, not a GC.
//   effects { alloc, mut }  states heap + mutation
//   region r = arena(n)     named lifetime; free when r ends
//   import std/vec          staged std/ beside this project (or FX_STD_ROOT)
// Grow: reassign / method sugar - not v2/v3 let-chains as default:
//   v.push(x);                       // expands to value-threaded grow
//   v = vec.push(v, x);              // same physics, explicit reassign
//   p.nodes = vec.push(p.nodes, x);  // &mut state field update

import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    let v: Vec<i32> = vec.new(0);
    v.push(40);
    v.push(2);
    return vec.get(v, 0) + vec.get(v, 1);
}
