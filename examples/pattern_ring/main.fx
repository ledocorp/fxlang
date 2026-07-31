// FX-0.7.4-D0 — fixed-capacity ring via array + head/tail indices (no interior pointers).
// For a packaged FIFO see std/queue + lib/ring_queue.
// Run: fx run examples/pattern_ring/main.fx  → exit 42
fn main() -> i32 {
    let buf: [i32; 4] = [0, 0, 0, 0];
    let slot: &mut [i32] = &mut buf;
    let head: i32 = 0;
    let tail: i32 = 0;
    let cap: i32 = 4;

    // enqueue 10, 20, 12
    slot[tail] = 10;
    tail = (tail + 1) % cap;
    slot[tail] = 20;
    tail = (tail + 1) % cap;
    slot[tail] = 12;
    tail = (tail + 1) % cap;

    let a: i32 = slot[head];
    head = (head + 1) % cap;
    let b: i32 = slot[head];
    head = (head + 1) % cap;
    let c: i32 = slot[head];
    return a + b + c;
}
