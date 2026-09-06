// example - IrqCap hosted region → exit 42
fn on_tick(cap: IrqCap) -> i32 effects { irq } {
    irq_enter(cap);
    irq_exit(cap);
    return 41 + 1;
}

fn main() -> i32 effects { irq } {
    let cap = IrqCap.mint_hosted();
    return on_tick(cap);
}
