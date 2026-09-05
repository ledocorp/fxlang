# kern_mmio

MMIO demo: \MmioCap.mint_hosted()\ over a hosted volatile window, \mmio_write32\ / \mmio_read32\, and the \mmio\ effect.

\\	ext
fx run examples/kern_mmio/main.fx --driver sh --emit-c
# or: fx run examples/kern_mmio/main.fx --fallback-emit-c
# expect exit 42
\
MMIO IR is out of scope this cut - prefer \--emit-c\ / \--fallback-emit-c\. Ops require a minted \MmioCap\ and \effects { mmio }\.
