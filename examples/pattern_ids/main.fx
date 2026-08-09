// composition pattern: graph as ids into parallel Vecs (SoA).
// No interior pointers; grow is value-threaded; reads via v[i].
// Run: fx run examples/pattern_ids/main.fx  → exit 42
import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);

    // Node i: values[i], left[i], right[i]; -1 = no child
    let values: Vec<i32> = vec.new(0);
    let left: Vec<i32> = vec.new(0);
    let right: Vec<i32> = vec.new(0);

    // id 0 = root (40), children 1 and 2
    values = vec.push(values, 40);
    left = vec.push(left, 1);
    right = vec.push(right, 2);

    // id 1
    values = vec.push(values, 1);
    left = vec.push(left, -1);
    right = vec.push(right, -1);

    // id 2
    values = vec.push(values, 1);
    left = vec.push(left, -1);
    right = vec.push(right, -1);

    let root: i32 = 0;
    let a: i32 = values[root];
    let li: i32 = left[root];
    let ri: i32 = right[root];
    let b: i32 = values[li];
    let c: i32 = values[ri];
    return a + b + c;
}
