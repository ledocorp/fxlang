// lib/id_pool.fx — region id-pool; set uses vec_set (FX-0.7.4-D2 slot mut, no rebuild).
module id_pool;

struct Pool {
    data: Vec<i32>,
}

struct Alloc {
    pool: Pool,
    id: i32,
}

fn make() -> Pool effects { alloc } {
    let d: Vec<i32> = vec_new(0);
    return Pool { data: d };
}

fn len(p: Pool) -> i32 {
    return p.data.len;
}

fn alloc(p: Pool, x: i32) -> Alloc effects { alloc, mut } {
    let d: Vec<i32> = vec_push(p.data, x);
    let id: i32 = d.len - 1;
    return Alloc { pool: Pool { data: d }, id: id };
}

fn get(p: Pool, id: i32) -> i32 {
    return vec_get(p.data, id);
}

fn set(p: Pool, id: i32, x: i32) -> Pool effects { alloc, mut } {
    // D2: stable-slot write — identity/capacity unchanged (not growable-Vec v[i]=x).
    return Pool { data: vec_set(p.data, id, x) };
}
