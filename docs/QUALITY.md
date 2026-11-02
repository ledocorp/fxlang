# Quality habits (public)

**Last updated:** 2 November 2026 · Package **0.9.75**

fx aims for tools you can audit: dual native paths (IR and readable C), explicit
effects/regions, and dogfood CLIs with clear exit codes on stderr.

## What we emphasize

| Habit | Meaning |
|-------|---------|
| Dual paths | Prefer programs that stay green on both `fx run` and `fx run --emit-c` |
| Equivalence | IR exit must match emit-C on the standing dual-path corpus |
| Clear exits | Tool CLIs document process codes separately from language errors |
| Thin C hosts | Product argv CLIs may use a small C `main`; fx owns the logic — [WRAP.md](WRAP.md) |
| Language package | What you clone is the installable tree (binary, `std/`, docs, examples) |

## Re-run claims (strangers)

From the **language package root** (after `fx doctor`):

```text
# Windows
.\scripts\verify-pack.ps1

# Linux / WSL
chmod +x bin/fx scripts/verify-pack.sh third_party/qbe/obj/qbe
./scripts/verify-pack.sh
```

What that proves:

- `fx doctor` is healthy  
- Teaching demos exit **42** on `--emit-c`  
- When QBE is present, Auto exit matches for a small dual-path subset  

What it does **not** prove: the private monorepo full gate (`test-gcc.ps1`), formal
verification, or every season demo. Those stay development-tree evidence.

Linux CI on this repo runs doctor + teaching smokes ([`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml)).
WSL users: use the Linux `bin/fx` and `verify-pack.sh` the same way.

## What this is not

- A certification claim (DO-178 or otherwise)
- A promise that every OOM path is already surfaced as `Result` Err in every lowering
- A package registry or hidden shared mutation models sandbox story

Dogfood: [DOGFOOD.md](DOGFOOD.md). C shapes: [C_SHAPE.md](C_SHAPE.md). Ship: [SHIP.md](SHIP.md). Next: [NEXT.md](NEXT.md).
