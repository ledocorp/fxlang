// Embedded scaffold: small explicit arena, no std import.
// Grow: let-chains teach value-threading; quieter: v = vec_push(v, x).

fn main() -> i32 effects { alloc, mut } {
    region r = arena(1024);
    let v: Vec<i32> = vec_new(0);
    let v2: Vec<i32> = vec_push(v, 40);
    let v3: Vec<i32> = vec_push(v2, 2);
    return vec_get(v3, 0) + vec_get(v3, 1);
}
