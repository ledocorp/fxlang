// examples/kern_atomic - Atomic<i32> with explicit memory orders (Season K).
// Run: fx run examples/kern_atomic/main.fx --emit-c
//      fx run examples/kern_atomic/main.fx --backend ir
// Expect exit 42 (emit-C and IR when QBE is staged).

fn main() -> i32 effects { atomic } {
    let a = Atomic.new(41);
    let _ = a.fetch_add(1, order.release);
    return a.load(order.acquire);
}
