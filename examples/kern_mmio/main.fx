// examples/kern_mmio - MmioCap + mmio_read32/write32 (Season K).
// Run: fx run examples/kern_mmio/main.fx --driver sh --emit-c
// Expect exit 42. MMIO IR is out-of-claim (use --emit-c / --fallback-emit-c).
// Live: FX-SH-LIVE-MMIO-CONV-1.

fn bump(cap: MmioCap) -> i32 effects { mmio } {
    mmio_write32(cap, 0, 41);
    return mmio_read32(cap, 0) + 1;
}

fn main() -> i32 effects { mmio } {
    let cap = MmioCap.mint_hosted();
    return bump(cap);
}
