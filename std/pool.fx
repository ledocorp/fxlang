// std Pool facade over lib/id_pool (typed Id slots; FX-0.7.5-A1).
module pool;

import lib/id_pool;

fn make() -> Pool effects { alloc } {
    return id_pool.make();
}

fn len(p: Pool) -> i32 {
    return id_pool.len(p);
}

fn from_raw(n: i32) -> Id {
    return id_pool.from_raw(n);
}

fn raw(id: Id) -> i32 {
    return id_pool.raw(id);
}

fn alloc(p: Pool, x: i32) -> Alloc effects { alloc, mut } {
    return id_pool.alloc(p, x);
}

fn get(p: Pool, id: Id) -> i32 {
    return id_pool.get(p, id);
}

fn set(p: Pool, id: Id, x: i32) -> Pool effects { alloc, mut } {
    return id_pool.set(p, id, x);
}
