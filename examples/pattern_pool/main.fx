// FX-0.7.4-D2 — composition: vec_set + pool.set (stable slot, no rebuild).
import std/pool;
import lib/id_pool;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);

    let p0: Pool = pool.make();
    let a0: Alloc = pool.alloc(p0, 0);
    let a1: Alloc = pool.alloc(a0.pool, 1);
    let a2: Alloc = pool.alloc(a1.pool, 1);

    let p: Pool = pool.set(a2.pool, a0.id, 40);

    let s: i32 = pool.get(p, a0.id) + pool.get(p, a1.id) + pool.get(p, a2.id);
    if (pool.len(p) != 3) {
        return 1;
    }
    return s;
}
