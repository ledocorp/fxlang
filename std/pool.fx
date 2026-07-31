// std Pool facade over lib/id_pool (i32 slots by id).
module pool;

import lib/id_pool;

fn make() -> Pool effects { alloc } {
    return id_pool.make();
}

fn len(p: Pool) -> i32 {
    return id_pool.len(p);
}

fn alloc(p: Pool, x: i32) -> Alloc effects { alloc, mut } {
    return id_pool.alloc(p, x);
}

fn get(p: Pool, id: i32) -> i32 {
    return id_pool.get(p, id);
}

fn set(p: Pool, id: i32, x: i32) -> Pool effects { alloc, mut } {
    return id_pool.set(p, id, x);
}
