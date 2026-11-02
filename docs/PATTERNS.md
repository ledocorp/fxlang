# Agent / human patterns (copyable)

**Last updated:** 2 November 2026 · Package **0.9.75**

Small recipes that stay inside fx’s grain. Prefer these over inventing traits,
async keywords, or hidden mutation.

Day-one agent loop: [AGENT.md](AGENT.md). Composition depth: [COMPOSITION.md](COMPOSITION.md).

---

## 1. SoA graph (typed ids)

Parallel `Vec`s + integer ids — no interior pointers.

```text
fx run examples/pattern_ids/main.fx
fx run examples/pattern_ids/main.fx --emit-c
# expect exit 42
```

Also: `pattern_pool`, `composition_reach`.

---

## 2. Result / `?` pipeline

Errors as data; no exceptions.

```text
fx run examples/tool_result/main.fx --emit-c
# expect exit 42
```

Failure policy: [TRAP.md](TRAP.md).

---

## 3. Capability-gated guest

Host-minted trust; guest logic without ambient `io`.

```text
fx run examples/cap_host_smoke/main.fx --emit-c
# expect exit 42
```

---

## 4. Endian wire buffer

`std/wire` foothold — prefer **`--emit-c`** until IR deepen is claimed.

```text
fx run examples/wire_smoke/main.fx --emit-c
# expect exit 42
```

---

## 5. Nursery + channel pipeline (deeper)

Structured concurrency without `async`/`await` keywords. Needs the **host
concur** link (see monorepo / tool dogfood). Teaching foothold in-tree:

```text
# C nursery probe (no fx main) — examples/concur_nursery_smoke/README.md
```

Full `nursery` + `chan` pipeline lives in the development tree as a season proof;
do not invent a second runtime. Surface map: [SURFACE.md](SURFACE.md) · [STD.md](STD.md).

---

## Habits

1. Effects and regions stay in the signature.  
2. Grow with `push` / reassign — not grow-on-`v[i]=x`.  
3. Dual-path: same exit on Auto (when QBE present) and `--emit-c`.  
4. Never invent `std/` names — check [STD.md](STD.md) / [SURFACE.md](SURFACE.md).

---

## Related

[AGENT.md](AGENT.md) · [SHIP.md](SHIP.md) · [C_SHAPE.md](C_SHAPE.md) · [QUALITY.md](QUALITY.md)
