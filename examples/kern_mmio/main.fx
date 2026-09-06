// examples/kern_mmio - MmioCap + mmio_read32/write32 (Season K).
// Run: fx run examples/kern_mmio/main.fx --emit-c
//      fx run examples/kern_mmio/main.fx --backend ir
// Expect exit 42 (emit-C and IR when QBE is staged).

fn bump(cap: MmioCap) -> i32 effects { mmio } {
    mmio_write32(cap, 0, 41);
    return mmio_read32(cap, 0) + 1;
}

fn main() -> i32 effects { mmio } {
    let cap = MmioCap.mint_hosted();
    return bump(cap);
}
