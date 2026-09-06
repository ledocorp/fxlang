// example - Cap-gated switch_context / load_pt @override → 42
fn switch_context(cap: IrqCap, next: i32) -> i32 effects { irq } {
    irq_enter(cap);
    irq_exit(cap);
    return next;
}

@override(target = "x86_64")
fn switch_context(cap: IrqCap, next: i32) -> i32 effects { irq } {
    irq_enter(cap);
    irq_exit(cap);
    return next;
}

fn load_pt(cap: IrqCap, root: i32) -> i32 effects { irq } {
    irq_enter(cap);
    irq_exit(cap);
    return root;
}

@override(target = "x86_64")
fn load_pt(cap: IrqCap, root: i32) -> i32 effects { irq } {
    irq_enter(cap);
    irq_exit(cap);
    return root;
}

fn main() -> i32 effects { irq } {
    let cap = IrqCap.mint_hosted();
    let a = switch_context(cap, 41);
    return load_pt(cap, a) + 1;
}
