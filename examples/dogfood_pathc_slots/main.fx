// no-grow slot living dogfood (dense SoA distances).
// Grow once with push; relax edges with no-grow `v[i]=x` (MUT-2).
// Soft-fx / growable index-assign stay refused. Exit 42 on expected sink dist.
import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(16384);

    // dist[0]=0; others "inf"
    let dist: Vec<i32> = vec.new(0);
    dist = vec.push(dist, 0);
    dist = vec.push(dist, 999);
    dist = vec.push(dist, 999);
    dist = vec.push(dist, 999);

    // Edges as frozen SoA (u, v, w) - no interior pointers.
    let eu: Vec<i32> = vec.new(0);
    let ev: Vec<i32> = vec.new(0);
    let ew: Vec<i32> = vec.new(0);
    eu = vec.push(eu, 0);
    ev = vec.push(ev, 1);
    ew = vec.push(ew, 10);
    eu = vec.push(eu, 0);
    ev = vec.push(ev, 2);
    ew = vec.push(ew, 5);
    eu = vec.push(eu, 2);
    ev = vec.push(ev, 1);
    ew = vec.push(ew, 3);
    eu = vec.push(eu, 1);
    ev = vec.push(ev, 3);
    ew = vec.push(ew, 34);

    // |V|-1 relax rounds - only slot writes on dist.
    let round: i32 = 0;
    while (round < 3) {
        let e: i32 = 0;
        while (e < eu.len) {
            let u: i32 = eu[e];
            let vv: i32 = ev[e];
            let w: i32 = ew[e];
            let cand: i32 = dist[u] + w;
            if (cand < dist[vv]) {
                dist[vv] = cand;
            }
            e = e + 1;
        }
        round = round + 1;
    }

    // Best path 0â†’2â†’1â†’3 = 5+3+34 = 42
    if (dist[3] != 42) {
        return 1;
    }
    if (dist[1] != 8) {
        return 2;
    }
    if (dist[2] != 5) {
        return 3;
    }
    return dist[3];
}
