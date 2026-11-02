// user-facing Vec<T> facade
// L1: stub path = len-only (`new` + `push` + `len` outside a heap region).
//     read/write path = arena (`effects { alloc }` + `region r = arena(...)` + `get`).
module vec;

// STD-010: inside an active heap region with `effects { alloc }`, `new` lowers to arena storage
// with zero-filled slots.
fn new<T>(len: i32) -> Vec<T> {
    return vec_new(len);
}

fn new_arena<T>(len: i32) -> Vec<T> effects { alloc } {
    return vec_arena_new(len);
}

fn push<T>(v: Vec<T>, x: T) -> Vec<T> effects { mut } {
    // Value-threaded: reassign `v = vec.push(v, x)` (or let-chain).
    return vec_push(v, x);
}

// FX-0.7.4-D2 - slot write (no grow). Prefer this over refused `v[i] = x`.
fn set<T>(v: Vec<T>, i: i32, x: T) -> Vec<T> effects { mut } {
    return vec_set(v, i, x);
}

fn get<T>(v: Vec<T>, i: i32) -> T effects { alloc } {
    return vec_get(v, i);
}

fn len<T>(v: Vec<T>) -> i32 {
    return v.len;
}
