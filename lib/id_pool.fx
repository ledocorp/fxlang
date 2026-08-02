// lib/id_pool.fx — region id-pool with typed Id (FX-0.7.5-A1).
// Grow: value-threaded alloc. Slot write: vec_set (D2). No escaping pointers.
module id_pool;

/// Typed pool index — not interchangeable with bare i32 at call sites.
struct Id {
    raw: i32,
}

struct Pool {
    data: Vec<i32>,
}

struct Alloc {
    pool: Pool,
    id: Id,
}

fn make() -> Pool effects { alloc } {
    let d: Vec<i32> = vec_new(0);
    return Pool { data: d };
}

fn len(p: Pool) -> i32 {
    return p.data.len;
}

fn from_raw(n: i32) -> Id {
    return Id { raw: n };
}

fn raw(id: Id) -> i32 {
    return id.raw;
}

fn alloc(p: Pool, x: i32) -> Alloc effects { alloc, mut } {
    let d: Vec<i32> = vec_push(p.data, x);
    let id: Id = Id { raw: d.len - 1 };
    return Alloc { pool: Pool { data: d }, id: id };
}

fn get(p: Pool, id: Id) -> i32 {
    return vec_get(p.data, id.raw);
}

fn set(p: Pool, id: Id, x: i32) -> Pool effects { alloc, mut } {
    // D2: stable-slot write — identity/capacity unchanged (not growable-Vec v[i]=x).
    return Pool { data: vec_set(p.data, id.raw, x) };
}
