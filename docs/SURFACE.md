# fx surface map (as implemented)

**Package version:** 0.9.71 

**Status:** As implemented — not aspirational 
**Canonical web copy:** https://www.ledocorp.org/fx/docs/surface/

This page is the **complete inventory of shipped functionality** in the public language package.
It includes typed pool **`Id`**, **`map_add_i32`**, lexical loans, concurrency facades, SIMD/`@override`,
caps/guest/net, and the `composition_*` / `bind_*` / `concur_*` examples.
Use it as a cheatsheet and as a depth ledger: if something is not listed here, do not assume it exists.

Prefer the [language tour](LANGUAGE.md) when learning. Prefer this page when asking “does fx have X?”
Prefer [COMPOSITION.md](COMPOSITION.md) when asking “how do I build a graph / table / ring in fx?”
Prefer [TRACKING.md](TRACKING.md) when asking “how does emitted C map back to fx?”

**Short paths:** Vec read `v[i]` · slot write `vec_set` / no-grow `v[i]=x` (needs `mut`) · grow `push`.
See [COMPOSITION.md](COMPOSITION.md).

---

## A. Kernel

### Keywords

`enum` `struct` `extern` `fn` `import` `let` `match` `module` `return` `effects`
`if` `while` `for` `break` `continue` `else` `defer` `region` `arena` `scope` `dynamic` `guest`
`temp` `fx` `own` `mut` `true` `false` `using` · `Ok` / `Err` on Result paths

Comments: `//` line comments. Refinement `where` is verification-tier (not required for everyday programs).

### Literals

| Kind | Forms |
|------|--------|
| Integers | decimal `123`, hex `0x1F` (underscores allowed). Unsuffixed ints adopt an **expected** integer type when they fit. Values that fit `u32` but not signed `i32` (e.g. `0xFF0000FF`) are **`i32` bit-patterns** when expected/`default` — use `: i64` / `as i64` if you need the full magnitude as 64-bit. |
| Floats | `1.5` → `f64` by default; `1.5f32` |
| Chars | `'A'`, `'\n'` (lower to `i32` byte values) |
| Strings / bools | `"…"` with escapes · `true` / `false` |

### Program shape

| Item | As implemented |
|------|----------------|
| Library file | `module name;` at top |
| Program entry | usually `fn main() -> i32`; may return `Result<i32, core_Err>` |
| Imports | `import std/vec;` — last path segment is the alias; **no** transitive visibility |
| Zspec in scope | `using core;` / `using core.mem;` |
| FFI | `extern "c" { fn name(…) -> …; }` |

### Types

| Kind | Forms |
|------|--------|
| Integers | `i8` `i16` `i32` `i64` · `u8` `u16` `u32` `u64` |
| Floats | `f32` `f64` |
| Scalars | `bool` `string` `void` `core_Err` |
| User types | `struct` · `enum` (unit + payload variants) |
| Collections | `Vec<T>` · `[T; N]` · `&[T]` · `&mut [T]` · `StrBuilder` · `Map<string, i32>` · `Map<string, string>` · `Buf` / `Bytes` |
| Sum | `Result<T, E>` (typically `core_Err`) |
| Ownership | `own T` · `&T` · `&mut T` · `&region r T` |
| Generics | type params on functions/structs · **no traits** |

Numeric rule: same-family ops; `i32↔i64` and `f32↔f64` can widen; **no** implicit signed↔unsigned or int↔float. Cast: `x as T`.

**Local lets:** `let x = 42;` is allowed when the initializer determines the type. Function **params/returns** stay written. Surface JSON remains an exact API passport (no inferred signature theater). Ambiguous RHS (empty `[]` as array) → annotate.

**Batch Vec init:** `let v: Vec<i32> = [40, 2];` → `vec_new` + pushes (≤32). plain `[i32; N]` stays an array.

**Facets:** `facet` / `attach` / `where T: Facet` → static mono named C. See [LANGUAGE.md](LANGUAGE.md) · `examples/facet_writer/`.

**CapDict:** `capdict` mint + `d.write(n)` → visible C vtable (`void* ctx` + fn ptrs). Dual-path: emit-C and IR when QBE is staged. See `examples/capdict_writer/`.

**fx ≠ C (agents):** struct literal fields use `,` not `;`; no C compound literals `(T){ .x = … }`; `Result` needs `?` / match; do not invent std APIs — read [STD.md](STD.md).

### Control flow

`if` / `else` · `while` · C-style `for` · `break` / `continue` · exhaustive `match` · `defer` (LIFO) · `return`

### Operators

| Class | Ops |
|-------|-----|
| Arithmetic | `+ - * / %` (int; `%` int-only) · `+ - * /` (float) · unary `-` |
| Bitwise | `& \| ^ << >>` on integer families |
| Logical | `!` `&&` `\|\|` |
| Compare | `== != < <= > >=` |
| Index | `a[i]` arrays R/W; `&[T]` read-only; `&mut [T]` write-through; Vec **read** via `v[i]` / `vec_get`; Vec **slot write** via `vec_set` or no-grow `v[i]=x` (needs `mut`) |
| Sub-slice | `a[lo..hi]` → `&[T]` (exclusive `hi`; arrays, `Vec`, slices) |
| Other | `expr as T` · `*p` deref · record update `base with { f: v, … }` (value copy; unmentioned fields from `base`) |

**Yes** no-grow `v[i] = x` on `Vec` under `mut` (same as `vec_set`). **No** growable index-assign.

**Record update:** `let p2 = p with { y: 32 };` builds a new struct value (not shared mut).

### Result / ?

- Construct: `Ok(x)` / `Err(e)` (usually with `using core;`)
- Propagate: `let x = f()?;` / `x = f()?;`
- **No** `Option` — use `Result`

---

## B. Memory model

### Effects (signature-visible)

| Effect | Meaning |
|--------|---------|
| `alloc` | Heap / arena allocation |
| `mut` | Mutation / exclusive borrows as required |
| `io` | Host I/O (stdout, files, …) |

Omit the clause when pure. Callers see cost before reading the body.

### Regions

| Syntax | Role |
|--------|------|
| `region r = arena(n);` | Default heap arena |
| `region r = temp(n);` | Short-lived heap batch |
| `region r = scope;` | Stack borrow region (no heap) |
| `region r = fx(n);` | Hierarchical fx region |
| `dynamic region g = guest(n);` | Guest session (emit-C + `host/cap` link) |

Details: [REGIONS.md](REGIONS.md). Advanced device Runtime (migration, soft heaps) is **not** in this package; capability guest sessions are.

### Value-threading

Growers return an updated handle — **reassign**:

```fx
v = vec_push(v, 40);
m = map_insert(m, "w", 30);
b = strbuf_push(b, "hello");
buf = buf_push(buf, 1);
```

Teaching patterns: scaffold let-chains · loop reassignment · `&mut` field update (`p.nodes = vec.push(p.nodes, x)`).

---

## C. Data (built-ins)

| Surface | Can | Cannot / limit |
|---------|-----|----------------|
| `Vec<T>` | `vec_new` / `push` / `get` / `vec_set` / `.len`; read `v[i]`; write `v[i]=x` (no grow) | grow via push; nested/exotic elems |
| Arrays `[T; N]` | index R/W; sub-slice | — |
| `&[T]` | read index; sub-slice | write through immutable view |
| `&mut [T]` | index write-through (array-backed) | `&mut Vec` as slice; mut sub-slices |
| `StrBuilder` | `strbuf_new` / `push` / `finish` / `len` | — |
| `string` helpers | `str_compare` `str_concat` `str_len` `str_byte_at` | rich unicode / regex; no silent `Bytes`↔`string` builtin |
| `Map<string, i32>` | insert/remove/get/contains/len; **`map_add_i32`** / `std/map.add_i32`; `map_nth_*` | accumulate = slot add or insert |
| `Map<string, string>` | `map_new_ss` / shared map builtins; `std/map.*_ss` | other KV shapes still out |
| `Buf` / `Bytes` | `buf_new`/`push`/`len`/`get`/`finish`; `bytes_len`/`bytes_get` | general streaming I/O API |

**Taught text path:** StrBuilder → `string` → `write_file` → scan with `byte_at` → `Buf` / `Bytes`. See `examples/tool_text`.

`Vec` elements commonly used: integers (incl. unsigned widths), `bool`, `string`, structs, payload enums. Prefer builtins over thin `std/vec.get` for non-`i32` elements.

---

## D. `std/` modules (complete inventory)

Ordinary fx. Import like any library. Linking still uses zspec for usual alloc paths.
Detail and examples: [STD.md](STD.md).

### Core collections & helpers

| Module | Role | Notes |
|--------|------|--------|
| `vec` | `new` / `push` / `get` / `set` / `len` (+ arena variants) | thin `get` oriented to `i32` |
| `string` | compare / concat / builder facades | — |
| `map` | `Map<string,i32>` + `*_ss` for `Map<string,string>` | not a fully generic map |
| `set` | presence set over map | — |
| `buf` | `Buf` + `Bytes` view facades | — |
| `box` / `pair` | ownership / pair helpers | — |
| `math` | `abs` `min` `max` `clamp` … | — |
| `fmt` | integer / tag format helpers | — |
| `io` | lines + text file read/write | declare `io` (+ `alloc` when needed) |
| `queue` | bounded queue facade | needs `lib/ring_queue.fx` |
| `pool` | id-pool facade | needs `lib/id_pool.fx`; typed **`Id`**; `set` → `vec_set` |
| `fx_defaults` | arena size / defaults helpers | — |

### Capability / guest / net

| Module | Role | Notes |
|--------|------|--------|
| `cap` | `FsCap` / `OutCap` / `AllocCap` / `FuelCap` / `NetCap` | opaque handles |
| `guest` | begin/end/mint/alloc/burn/net | pair with `host/cap` |
| `io_cap` | cap-scoped file I/O | — |
| `net` | TCP `dial` under NetCap | `dial_tls` facade **always fails** in this package (TLS not in default dial) |

### Structured concurrency

| Module | Role | Notes |
|--------|------|--------|
| `nursery` | host nursery / `spawn_i32` / `await_i32` / join | link `host/concur` |
| `chan` | i32/i64 channel facade | — |
| `select` | wait-any + timeout | — |
| `mailbox` | i32 mailbox facade | — |
| `supervise` | supervision policy + apply | — |
| `sync` | mutex create/lock/unlock | — |
| `async` | **deprecated stub** — prefer `nursery` | do not use as product API |

### Path, files, encoding, data, time

| Module | Role | Notes |
|--------|------|--------|
| `path` | join / parent / basename / ext / is_abs | — |
| `strutil` | contains / starts_with / ends_with | — |
| `encoding` | hex + base64 over `Vec<i32>` | — |
| `fs` | `copy_file` / exists / remove | over `std/io` |
| `fs_walk` | list immediate directory names | link `host/std_fs_walk` |
| `log` | tagged stderr helpers | — |
| `json` | thin cJSON path facade | link cJSON |
| `json_validate` / `json_full` | fx-native validate path | — |
| `sqlite` | SQLite WRAP facade | amalgamation + FsCap open |
| `http` | llhttp parse-only facade | — |
| `time` | wall clock / sleep / seeded LCG | link `host/std_time` |
| `env` | getenv / has / get_or | argv stays host/cli; link `host/std_env` |

### Testing

| Module | Role | Notes |
|--------|------|--------|
| `testing` | asserts + stderr diagnostics | used by `fx test` |
| `proptest` | property / checksum helpers | used by `fx fuzz` |

Caveat: `fx new` (simple) stages `std/` (and `lib/ring_queue.fx`) beside the project so imports resolve offline. Or set `FX_STD_ROOT`.

---

## D2. Lexical loans (ownership checker)

Landed checker on existing `&` / `&mut` / `&region` (no lifetime parameters, no NLL):

| Rule | Effect |
|------|--------|
| Shared XOR mut | Many `&` **or** one `&mut` of the same place in one epoch — not both |
| Region epoch | Loan cannot outlive its owner region → **FX0015** |
| Borrow conflict | Overlapping exclusive/shared loans → **FX0019** (`= rewrite:` line) |
| Effect mismatch | Missing `mut`/`alloc` on slot/grow → **FX0023** (`= rewrite:` distinguishes slot vs `v.push` grow) |
| Hylo call-end | Inline `&mut` actuals end at the statement / call return |

Optional `loan { }` block sugar is **not** shipped. Graphs stay typed **`Id` + SoA** — see [COMPOSITION.md](COMPOSITION.md). Detail: [REGIONS.md](REGIONS.md).

---

## D3. SIMD

Portable vector foothold (scalar emit-C SoT; optional SSE/NEON where staged):

| Types | Common ops |
|-------|------------|
| `v4i32`, `v4f32`, `v16u8` | add/sub/mul/min/max, broadcast, lane, hadd; load/store for `v4i32` |

Not a full vector ISA product. Prefer scalar SoT for dual-emit readability.

---

## D4. Asm / `@override`

| Surface | Role |
|---------|------|
| `@override(target=…)` | Targeted fast path; **portable fx body remains SoT** |
| Constrained `asm { }` | Inline asm with clobber checks (diagnostics FX0034/FX0035) |
| `external = "….s"` | External assembly unit |

IR uses the portable path. Monorepo has an asm-verify harness comparing portable vs override; that harness is **not** a public certification claim.

---

## E. Tooling (`fx` CLI)

| Command | Purpose |
|---------|---------|
| `fx doctor` | C toolchain + zspec paths |
| `fx version` | package version |
| `fx help` | help |
| `fx new <name>` | scaffolds: `simple` / `minimal` / `embedded` / `cli` / `guest` |
| `fx check` | parse + typecheck (`--guest` for guest ambient-io policy) |
| `fx run` / `fx build` | Auto driver; IR → native default; `--emit-c`; `--release` / `--watch` |
| `fx emit-c` | `.c` / `.h` only (no link); `--surface` also writes passport files |
| `fx surface` | Static module passport (JSON + Markdown: types, effects, caps/regions, docs attrs) |
| `fx test` / `fx fuzz` | Discover `*_test.fx` / property driver; `--backend c\|ir\|both` |
| `fx cc` | power emit+link path |
| `fx lsp` | language server (stdio) — basic |
| `fx mcp` | lean MCP (`check` / `locate` / `run` / `surface` / `emit_c`, …) |
| `fx locate` | C line → fx via `.fxmap` |
| `fx bind` | C header → `extern "c"` stubs |
| `fx mod vendor\|tidy\|verify` | offline `vendor/std` + `fx.sum` pin |

Useful product flags: `--cli` (auto-link cli host), `--host`, `--guest` / `--no-guest`, `--driver auto|sh|foundry`, `--fallback-emit-c`. Detail: [CLI.md](CLI.md).

Default link: **gcc** + OS-matched `libzspec` under `build/`. Prebuilt compilers: **Windows + Linux x86_64 only**. `fx run` does **not** forward program argv — use `--cli` / `--host` / `--scaffold cli`.

---

## F. Interop

| Capability | As implemented |
|------------|----------------|
| Dual native paths | `fx run` / `build` → IR → native; `--emit-c` / `fx emit-c` → readable C on zspec |
| C owns `main` | `fx run lib.fx --host host.c` or `--cli` |
| Native lib unit | `fx run app.fx --host host.c --use ./libdir` (loads `libdir/link.args`) |
| Extra link | `--link` · `--link-args-file` · `--link-include` / `--link-dir` / `--link-lib` |
| Header → stubs | `fx bind header.h --out stubs.fx` (Level 1; see WRAP) |
| Host spine | `host/cap` · `host/cli` · `host/process` · `host/concur` · `host/std_*` |
| Net | NetCap TCP `std/net.dial`; TLS not in this package (use **fxfetch** for HTTPS) |
| Examples | `showcase_*` · `bind_*` · `wrap_*` · `wasm_smoke` · `composition_*` · `cap_*` · `concur_*` · `tool_*` · `pattern_*` |

Non-C FFI is **not** shipped. Separate product CLIs (fxrun, fxql, fxfetch, fxpipe, fxlz4, fxblake3, fxguest) live outside this language package — see [LIBRARIES.md](LIBRARIES.md).

---

## G. Limits & deferred

### Also as implemented (0.9.71 floor)

| Surface | Notes |
|---------|--------|
| Collection method sugar | `v.push(x)` / `m.insert(…)` → `vec_push` / `map_insert` |
| Lexical loans | Shared XOR mut · region escape · Hylo call-end — [REGIONS.md](REGIONS.md) |
| SIMD | `v4i32` / `v4f32` / `v16u8` + helpers; optional SSE/NEON — not a full vector ISA |
| `@override` + `asm { }` | Portable SoT + targeted override / constrained asm / external `.s` |
| Guest helpers | Guest-gated `vec_filter` / `vec_map` / `vec_collect` (no lambdas) |
| Surface attrs | `///` docs + `#[…]` data-only attributes on the passport |
| Structured concurrency | `std/nursery`… + `host/concur` (no lexer keywords) |

### Not in the product dialect (as of 0.9.71)

- Traits, closures, iterators, `Option`
- Nested `Vec<Vec<T>>`; many non-everyday `Vec` element types (e.g. casual `Vec<f32>`)
- Generic maps beyond `string → i32` / `string → string`; insertion-order map iteration
- Growable `Vec` index **assign** that reallocates; `&mut Vec` as a mut slice; mut sub-slices
- Package **registry** (offline `fx.mod` / `fx.sum` / `fx mod vendor` for **std** exists; not a download registry)
- Full HTTP client / general TLS stack in the **language package** — TCP dial yes; `std/net.dial_tls` always fails here; HTTPS is a separate **fxfetch** tool that links Mbed TLS
- Lexer keywords `nursery` / `spawn` / `await` (use `nursery.spawn_i32` / `await_i32`)
- Advanced runtime layers (device-aware migration, alternate mutation models)
- OS product / experimental horizon features
- macOS prebuilt binary (**frozen:** Win/Linux x86_64 package only)
- `fx run` program-argv passthrough (**frozen:** C host / `--cli` / `--scaffold cli` owns argv)
- Optional `loan { }` block sugar (not shipped)

### Intentionally deferred (architecture, not forgotten)

- Advanced fx Runtime layer (spec Phase 2) — optional 
- Further zspec modules — **pull when `std/` needs C ABI**, not a checklist 
- Deeper agent/LSP / DAP — optional; basic `fx lsp` / `fx mcp` exist 
- Vendor-first compile resolve (**frozen pin-only:** `vendor/` + `fx.sum` checksum; imports still use `std/` / `FX_STD_ROOT`) 
- Language-package TLS dial without an extra tool/link unit 

### Substrate (for linkers / embedders)

zspec **Minimal Core** (allocator, error, string, debug, platform) + `core_fx_region` + `core_fs` — fixed floor. Not a 17-module SDK milestone.

---

## Quick “can I build X?”

| Goal | Path |
|------|------|
| Hello + visible heap | `fx new hello` → `fx run` |
| Grow collections | value-thread `vec` / `map` / `buf` / `strbuf` |
| Iterate a map | `map_nth_*` / `std/map.nth_*` (table order) · see `examples/tool_tally` |
| Tally / accumulate | `map_add_i32` / `std/map.add_i32` · `examples/tool_tally` · **`examples/composition_tally`** |
| Bytes | `Buf` / `Bytes` + `std/buf` · see `examples/tool_bytes` |
| Files | `std/io` + `effects { io }` · see `examples/tool_files` |
| Text path (str↔bytes↔file) | StrBuilder → file → `byte_at` → Buf · see `examples/tool_text` |
| Map string→string | `map_new_ss()` |
| Mut slice write | `&mut [T]` on arrays · `examples/pattern_mut_table` |
| Vec slot write | `vec_set` / `v[i]=x` (no grow) / `std/vec.set` · `examples/pattern_pool` |
| Shared XOR mut / loans | `&` / `&mut` rules · [REGIONS.md](REGIONS.md) |
| Structured concurrency | `std/nursery` + `host/concur` · `examples/concur_*` |
| SIMD vectors | `v4i32` / `v4f32` / `v16u8` · §D3 |
| Asm override | `@override` / `asm { }` · §D4 |
| Record update | `p with { y: 32 }` |
| Module passport | `fx surface file.fx` · `fx emit-c --surface` |
| Graph / IR shape | typed **`Id`** · `std/pool` · `examples/pattern_ids` · [COMPOSITION.md](COMPOSITION.md) |
| Caps / guest I/O | `std/cap` + `std/guest` + `host/cap` · `examples/cap_*` |
| TCP dial | `std/net.dial` under NetCap allowlist |
| HTTPS GET | separate **fxfetch** tool (not `dial_tls` in this package) |
| Grow then read-only | freeze-by-convention · `examples/pattern_grow_freeze` |
| Fixed ring | array + cursors · `examples/pattern_ring` · or `std/queue` |
| Result / `?` | general emit · see `examples/tool_result` |
| Native tests | `fx test` / `fx fuzz` · `std/testing` |
| Embed in C | `--host` / `--cli` + [WRAP.md](WRAP.md) |
| C header → stubs | `fx bind` · `examples/bind_smoke` · [WRAP.md](WRAP.md) |
| Inspect lowering | `fx emit-c` · [TRACKING.md](TRACKING.md) |
| Map C line → fx | `fx emit-c --debug-source` + `fx locate` · [TRACKING.md](TRACKING.md) |

---

## Composition doctrine

Teach **Lane A** (fx method): value-threaded grow, indices over interior pointers, arrays/`&mut [T]` for local mut, **`std/pool`** ids.
**No unsafe dialect.** Optional non-production convenience helper is authorized later and non-default.

→ [COMPOSITION.md](COMPOSITION.md) · dual-emit tracking → [TRACKING.md](TRACKING.md)

**Also landed:** `std/pool` typed **`Id`**, `map_add_i32`, `composition_*` programs, `vec_set` + no-grow `v[i]=x`.

---

[START_HERE.md](START_HERE.md) · [COMPOSITION.md](COMPOSITION.md) · [TRACKING.md](TRACKING.md) · [LANGUAGE.md](LANGUAGE.md) · [REFERENCE.md](REFERENCE.md) · [STD.md](STD.md) · [CLI.md](CLI.md) · [REGIONS.md](REGIONS.md) · [WRAP.md](WRAP.md)
