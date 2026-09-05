// examples/kern_atomic - Atomic<i32> with explicit memory orders (Season K).
// Run: fx run examples/kern_atomic/main.fx --driver sh --emit-c
// Expect exit 42. Atomic IR is out-of-claim (use --emit-c / --fallback-emit-c).
// Live: FX-SH-LIVE-ATOMIC-CONV-1.

fn main() -> i32 effects { atomic } {
    let a = Atomic.new(41);
    let _ = a.fetch_add(1, order.release);
    return a.load(order.acquire);
}
