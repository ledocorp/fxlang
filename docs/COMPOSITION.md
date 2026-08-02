# Composition under regions

**Package:** 0.7.5 · **Pack:** FX-0.7.5  
**Normative monorepo canon:** `docs/specs/COMPOSITION_UNDER_REGIONS.md`  
**Site:** https://www.ledocorp.org/fx/docs/composition/

How to build **real programs** in fx without treating it as incomplete Rust — and without an unsafe dialect.

---

## Two lanes

| Lane | What | Default? | Production? |
|------|------|----------|-------------|
| **A — fx method** | Regions, effects, value-threaded grow, ids/pools, array/`&mut [T]`, `vec_set` slot mut | **Yes** | **Yes** |
| **B — convenience helper** | Not shipped (skipped); not an unsafe path | **No** | N/A |

There is **no unsafe path**. Prefer Lane A always.

---

## Rules that stay load-bearing

1. Effects visible (`alloc` / `mut` / `io`).
2. Named regions as memory epochs (no GC).
3. **Grow** by reassignment: `v = vec_push(v, x)`.
4. No hidden shared mutation.
5. Prefer **indices** over pointers into growing storage.
6. Dual emit stays readable — see [TRACKING.md](TRACKING.md).

**Vec writes:** `v[i] = x` is **refused**. Grow with `vec_push`; slot update with `vec_set(v, i, x)` (requires `mut`); fixed tables with arrays + `&mut [T]`.

---

## Patterns (with examples)

### 1. Ids, not interior pointers

Store payloads in region `Vec`s; edges are integer ids.

```text
fx run examples/pattern_ids/main.fx    # exit 42
```

### 2. Local mutation on fixed tables

```text
fx run examples/pattern_mut_table/main.fx
```

Uses `&mut [T]` on an array.

### 3. Grow, then read-only (“freeze by convention”)

```text
fx run examples/pattern_grow_freeze/main.fx
```

Freeze is a **discipline** (no Growing/Frozen phase types in this package).

### 4. Ids / pools

```text
fx run examples/pattern_ids/main.fx     # SoA Vecs
fx run examples/pattern_pool/main.fx    # std/pool + lib/id_pool
```

`pool.set` / `vec_set` write a **stable slot** (no realloc). Handles are typed **`Id`** (bare `i32` at get/set is a type error). Grow remains `push` / reassign. Still **no** `v[i] = x`.

### 5. Fixed ring (cursors + array)

```text
fx run examples/pattern_ring/main.fx
```

Also see `std/queue` + `lib/ring_queue` for a packaged FIFO.

### 6. Non-toy programs (0.7.5-A3)

```text
fx run examples/composition_tally/main.fx   # multi-pass Map add_i32 → 42
fx run examples/composition_reach/main.fx   # typed Id pool + BFS reachability → 42
```

Harness: `.\scripts\test-composition-patterns.ps1` (opt-in; includes pattern_* + composition_*).

---

## Dual-emit tracking

Default C includes `/* fx: … */` traces. For machine maps and remapped C diagnostics, see [TRACKING.md](TRACKING.md).

---

## Related

- [SURFACE.md](SURFACE.md) — what exists today  
- [REGIONS.md](REGIONS.md) — effects and region kinds  
- [LANGUAGE.md](LANGUAGE.md) — language tour  
