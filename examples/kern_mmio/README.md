# kern_mmio

MMIO demo: `MmioCap.mint_hosted()` over a hosted volatile window, `mmio_write32` / `mmio_read32`, and the `mmio` effect.

```text
fx run examples/kern_mmio/main.fx --emit-c
fx run examples/kern_mmio/main.fx --backend ir
# expect exit 42
```

Native IR works when QBE is staged. Ops require a minted `MmioCap` and `effects { mmio }`.
