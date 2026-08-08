# Composition under regions

**Package:** 0.9.0  

**Site:** https://www.ledocorp.org/fx/docs/composition/  
**What’s next:** [NEXT.md](NEXT.md) · [DOGFOOD.md](DOGFOOD.md) · [AGENT.md](AGENT.md)

How to build **real programs** in fx without treating it as incomplete Rust — and without an unsafe dialect.

---

## Two lanes

| Lane | What | Default? | Production? |
|------|------|----------|-------------|
| **A — fx method** | Regions, effects, value-threaded grow, ids/pools, array/`&mut [T]`, `vec_set` slot mut | **Yes** | **Yes** |
| **B — convenience helper** | Not shipped (skipped); not an unsafe path | **No** | N/A |

There is **no unsafe path**. Prefer Lane A always.

---

## Mutation policy (locked)

Region-local **slot** mutation is part of the language method today.
What we are **not** adding:

- Growable-`Vec` index-assign sugar (`v[i] = x`)
- Rust-style `Cell` / hidden shared interior mutability
- A “soft” dialect where scripts get different mutability physics

| Kind | How |
|------|-----|
| **Grow** (may reallocate) | Reassign: `v = vec_push(v, x)` |
| **Slot write** (capacity unchanged) | `v = vec_set(v, i, x)` under `mut` (in-place store) |
| **Fixed tables** | Arrays + `&mut [T]` |
| **Graphs / IR** | Ids / pools + `pool.set` |

`vec_set` is an ordinary store into stable storage — not a full vector rebuild.
The reassignment keeps identity/grow honest at the source level.

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

### 6. Composition example programs

```text
fx run examples/composition_tally/main.fx   # multi-pass Map add_i32 → 42
fx run examples/composition_reach/main.fx   # typed Id pool + BFS reachability → 42
```

### 7. SoA / structured state (preferred over nested growables)

When state feels “too nested,” prefer **parallel `Vec`s + typed `Id`**, not `Vec` fields inside structs that grow. Canonical walkthrough: `composition_reach` (nodes / adj / queue / color as siblings under one region). Keep types (`i32`, `Id`, effects) visible on purpose — domain names reduce noise, not soft inference.

### 8. Host-minted I/O authority (no ambient guest `io`)

When a tool must not open arbitrary files from fx code, put **`fopen` in the C host**:
allowlist the path, read bytes, pass a `string` into a guest library with **no `io` effect**.
Denial is a distinct process exit (example uses **5**).

```text
fx run examples/cap_host_smoke/main.fx            # exit 42
fx build examples/cap_host_smoke/guest_lib.fx -o build/cap_host_smoke --emit-c --host examples/cap_host_smoke/host.c
```

### 9. Capability regions (`FsCap` / `OutCap`)

For scripting and embedded guests that **do** need file I/O in fx, pass **opaque caps** the host minted:

- `import std/cap` — `FsCap` (read root) / `OutCap` (write root)
- `import std/io_cap` — `read_file_cap(fs, path)` / `write_file_cap(out, path, data)`
- Host links `examples/cap_runtime/` (`fx_fscap_mint` / `fx_outcap_mint`); deny outside the root is **`Err(5)`** / exit **5**
- Ambient `std/io` stays for process-trust CLIs — caps are a **parallel** facade, not a silent rewrite

```text
fx run examples/cap_regions_ext/main.fx            # dual-path score → 42
fx build examples/cap_regions_ext/guest_lib.fx -o build/cap_regions_ext --emit-c `
  --host examples/cap_regions_ext/host.c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime
```

**Embedded pattern:** mint caps at the C boundary → call guest `run(fs, out, …)` → tear down.
Pure algorithm modules stay IR-runnable without caps; the hosted path proves the allowlist.
Same region / slot-mut physics — not a soft dialect.

### 10. Guest context (session lifetime)

For scripting / embed / extensions that need an **independent guest world**, the host owns a
**guest session**: bump arena + minted caps. Ending the session frees the arena and **revokes**
caps (stale handles deny). This is language power — same fx physics inside the guest, not a
softer dialect.

- `import std/guest` — `GuestCtx`; `begin(root, arena_bytes)` / `mint_fs` / `mint_out` / `end`
- Host C: `fx_guest_begin` / `fx_guest_mint_fscap` / `fx_guest_end` in `examples/cap_runtime/`
- Guest code uses `io_cap` only (no ambient `std/io` in that context)
- After `end`, a second call with the old `FsCap` returns deny (**5**)

```text
fx run examples/cap_guest_ctx/main.fx            # dual-path score → 42
fx build examples/cap_guest_ctx/guest_lib.fx -o build/cap_guest_ctx --emit-c `
  --host examples/cap_guest_ctx/host.c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime
# default prog.exe: begin → run → end → stale-handle deny
```

**Fx host (no C driver):** `examples/cap_guest_fxhost/host_main.fx` calls `guest.begin` / `end` directly.

**Language sugar:** `dynamic region g = guest(N);` lowers to `fx_guest_begin` / `fx_guest_end` on function exit (not `arena` / not Runtime `fx(...)`). See `examples/cap_guest_fxhost/host_sugar.fx`.

Dogfood apps that still use ambient `io` are honest process-trust tools — see [DOGFOOD.md](DOGFOOD.md).

---

## Dual-emit tracking

Default C includes `/* fx: … */` traces. For machine maps and remapped C diagnostics, see [TRACKING.md](TRACKING.md).

---

## Teaching corpus

Short algorithm slices under `examples/teaching/` — each exits **42**:

| Example | Shows |
|---------|--------|
| `teaching/uf_step` | Union-find + `vec_set` path compress |
| `teaching/heap_sift` | Min-heap sift-up with slot swaps |
| `teaching/graph_bfs` | BFS on SoA edges + color table |
| `teaching/stack_vm` | Tiny stack VM (PUSH / MUL) |

```text
fx run examples/teaching/uf_step/main.fx
fx run examples/teaching/uf_step/main.fx --emit-c
```

See [DOGFOOD.md](DOGFOOD.md) for the larger dogfood apps.

## Related

- [NEXT.md](NEXT.md) — what’s next  
- [DOGFOOD.md](DOGFOOD.md) — CHIP‑8, JSON CLIs, textdiff  
- [LIBRARIES.md](LIBRARIES.md) — C wrap priorities  
- [SURFACE.md](SURFACE.md) — what exists today  
- [REGIONS.md](REGIONS.md) — effects and region kinds  
- [LANGUAGE.md](LANGUAGE.md) — language tour  
