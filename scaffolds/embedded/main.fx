// Embedded scaffold: small explicit arena, no std import.
// Grow: v.push / reassign - not v2/v3 let-chains as default.

fn main() -> i32 effects { alloc, mut } {
    region r = arena(1024);
    let v: Vec<i32> = vec_new(0);
    v.push(40);
    v.push(2);
    return vec_get(v, 0) + vec_get(v, 1);
}
