// non-toy reachability: typed pool Ids + edge SoA + worklist → 42
// Nodes in std/pool (A1 Id); edges as parallel Vec raw ids; slot marks via vec.set.
// No interior pointers; grow then walk; no unsafe.
import std/pool;
import lib/id_pool;
import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(16384);

    // --- Grow: five weighted nodes (ids 0..4) ---
    let a0: Alloc = pool.alloc(pool.make(), 10);
    let a1: Alloc = pool.alloc(a0.pool, 8);
    let a2: Alloc = pool.alloc(a1.pool, 7);
    let a3: Alloc = pool.alloc(a2.pool, 12);
    let a4: Alloc = pool.alloc(a3.pool, 5);
    let nodes: Pool = a4.pool;
    let n: i32 = pool.len(nodes);
    if (n != 5) {
        return 1;
    }

    // Edges (raw Id.raw): 0→1, 0→2, 1→3, 2→3, 3→4  - all reachable from 0
    let from: Vec<i32> = vec.new(0);
    let to: Vec<i32> = vec.new(0);
    from = vec.push(from, 0);
    to = vec.push(to, 1);
    from = vec.push(from, 0);
    to = vec.push(to, 2);
    from = vec.push(from, 1);
    to = vec.push(to, 3);
    from = vec.push(from, 2);
    to = vec.push(to, 3);
    from = vec.push(from, 3);
    to = vec.push(to, 4);

    // Visited flags (slot mut; capacity fixed after grow)
    let seen: Vec<i32> = vec.new(0);
    let si: i32 = 0;
    while (si < n) {
        seen = vec.push(seen, 0);
        si = si + 1;
    }

    // Worklist BFS from root id 0
    let wl: Vec<i32> = vec.new(0);
    wl = vec.push(wl, pool.raw(a0.id));
    let head: i32 = 0;
    let sum: i32 = 0;
    let reached: i32 = 0;

    while (head < vec.len(wl)) {
        let u: i32 = wl[head];
        head = head + 1;
        if (seen[u] == 1) {
            continue;
        }
        // Slot mut via builtin (same path as pool.set / id_pool).
        seen = vec_set(seen, u, 1);
        reached = reached + 1;
        let uid: Id = pool.from_raw(u);
        sum = sum + pool.get(nodes, uid);

        let ei: i32 = 0;
        while (ei < vec.len(from)) {
            if (from[ei] == u) {
                let v: i32 = to[ei];
                if (seen[v] == 0) {
                    wl = vec.push(wl, v);
                }
            }
            ei = ei + 1;
        }
    }

    if (reached != 5) {
        return 2;
    }
    // 10+8+7+12+5 = 42
    if (sum != 42) {
        return 3;
    }
    return sum;
}
