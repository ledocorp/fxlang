// FX-0.7.4-D0 — composition pattern: local mutation on a fixed array table.
// Uses shipped `&mut [T]` (array-backed). Not growable-Vec index assign.
// Run: fx run examples/pattern_mut_table/main.fx  → exit 42
fn main() -> i32 {
    let table: [i32; 3] = [0, 0, 0];
    let view: &mut [i32] = &mut table;
    view[0] = 20;
    view[1] = 14;
    view[2] = 8;
    return view[0] + view[1] + view[2];
}
