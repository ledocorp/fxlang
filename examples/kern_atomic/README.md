# kern_atomic

Atomic demo: `Atomic<i32>` with explicit memory orders under `effects { atomic }`.

```text
fx run examples/kern_atomic/main.fx --emit-c
fx run examples/kern_atomic/main.fx --backend ir
# expect exit 42
```

Native IR works when QBE is staged. Missing order is a type error (no silent defaults).
