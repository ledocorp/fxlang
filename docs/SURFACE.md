# fx surface map (as implemented)

**Package version:** 0.7.3  
**Map ID:** FX-0.7.3-M6  
**Status:** As implemented — not aspirational  
**Canonical web copy:** https://www.ledocorp.org/fx/docs/surface/

This page is the **complete inventory of shipped functionality** in the public language package.
Use it as a cheatsheet and as a depth ledger: if something is not listed here, do not assume it exists.

Prefer the [language tour](LANGUAGE.md) when learning. Prefer this page when asking “does fx have X?”

---

## A. Kernel

### Keywords

`enum` `struct` `extern` `fn` `import` `let` `match` `module` `return` `effects`
`if` `while` `for` `break` `continue` `else` `defer` `region` `arena` `scope`
`temp` `fx` `own` `mut` `true` `false` `using` · `Ok` / `Err` on Result paths

Comments: `//` line comments. Refinement `where` is verification-tier (not required for everyday programs).

### Literals

| Kind | Forms |
|------|--------|
| Integers | decimal `123`, hex `0x1F` (underscores allowed) |
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

### Control flow

`if` / `else` · `while` · C-style `for` · `break` / `continue` · exhaustive `match` · `defer` (LIFO) · `return`

### Operators

| Class | Ops |
|-------|-----|
| Arithmetic | `+ - * / %` (int; `%` int-only) · `+ - * /` (float) · unary `-` |
| Bitwise | `& \| ^ << >>` on integer families |
| Logical | `!` `&&` `\|\|` |
| Compare | `== != < <= > >=` |
| Index | `a[i]` arrays R/W; `&[T]` read-only; `&mut [T]` write-through; Vec **read** via `v[i]` / `vec_get` (no `v[i]=x`) |
| Sub-slice | `a[lo..hi]` → `&[T]` (exclusive `hi`; arrays, `Vec`, slices) |
| Other | `expr as T` · `*p` deref |

**No** `v[i] = x` on `Vec`.

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

Details: [REGIONS.md](REGIONS.md). Advanced device/capability Runtime regions are **not** in this package.

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
| `Vec<T>` | `vec_new` / `push` / `get` / `.len`; read `v[i]` | **`v[i]=x` refused** (grow via push/reassign); nested/exotic elems |
| Arrays `[T; N]` | index R/W; sub-slice | — |
| `&[T]` | read index; sub-slice | write through immutable view |
| `&mut [T]` | index write-through (array-backed) | `&mut Vec` as slice; mut sub-slices |
| `StrBuilder` | `strbuf_new` / `push` / `finish` / `len` | — |
| `string` helpers | `str_compare` `str_concat` `str_len` `str_byte_at` | rich unicode / regex; no silent `Bytes`↔`string` builtin |
| `Map<string, i32>` | insert/remove/get/contains/len; `map_nth_*` | — |
| `Map<string, string>` | `map_new_ss` / shared map builtins; `std/map.*_ss` | other KV shapes still out |
| `Buf` / `Bytes` | `buf_new`/`push`/`len`/`get`/`finish`; `bytes_len`/`bytes_get` | general streaming I/O API |

**Taught text path:** StrBuilder → `string` → `write_file` → scan with `byte_at` → `Buf` / `Bytes`. See `examples/tool_text`.

`Vec` elements commonly used: integers (incl. unsigned widths), `bool`, `string`, structs, payload enums. Prefer builtins over thin `std/vec.get` for non-`i32` elements.

---

## D. `std/` modules

Ordinary fx. Import like any library. Linking still uses zspec for usual alloc paths.

| Module | Role | Notes |
|--------|------|--------|
| `vec` | `new` / `push` / `get` / `len` (+ arena variants) | thin `get` oriented to `i32` |
| `string` | compare / concat / builder facades | — |
| `map` | `Map<string,i32>` + `*_ss` for `Map<string,string>` | not a fully generic map |
| `set` | presence set over map | — |
| `buf` | `Buf` + `Bytes` view facades | — |
| `box` / `pair` | ownership / pair helpers | — |
| `math` | `abs` `min` `max` `clamp` … | — |
| `fmt` | integer / tag format helpers | — |
| `io` | lines + text file read/write | declare `io` (+ `alloc` when needed) |
| `queue` | bounded queue facade | needs `lib/ring_queue.fx` (shipped; `fx new` stages it) |
| `fx_defaults` | small defaults helpers | — |

Caveat: `fx new` (simple) stages `std/` (and `lib/ring_queue.fx`) beside the project so imports resolve offline. Or set `FX_STD_ROOT`.

---

## E. Tooling (`fx` CLI)

| Command | Purpose |
|---------|---------|
| `fx doctor` | C toolchain + zspec paths |
| `fx version` | package version |
| `fx help` | help |
| `fx new <name>` | scaffolds: `simple` / `minimal` / `embedded` |
| `fx check` | parse + typecheck |
| `fx run` / `fx build` | emit, link (+ run); `--release` / `--watch` |
| `fx emit-c` | `.c` / `.h` only |
| `fx cc` | power emit+link path |
| `fx lsp` | language server (stdio) — basic |
| `fx mcp` | lean MCP (`check` / `locate` / `run`, …) |
| `fx locate` | C line → fx via `.fxmap` |

Default link: **gcc** + OS-matched `libzspec` under `build/`. Prebuilt compilers: Windows + Linux x86_64 (macOS binary not in this package yet).

---

## F. Interop

| Capability | As implemented |
|------------|----------------|
| Dual emission | `fx run` / `build` / `emit-c` → readable C on zspec |
| C owns `main` | `fx run lib.fx --host host.c` |
| Extra link | `--link-args-file` · `--link-include` / `--link-dir` / `--link-lib` |
| Examples | `examples/showcase_core` · `showcase_wrap` · `showcase_072` |

Non-C FFI is **not** shipped.

---

## G. Honesty bounds & deferred

### Not in 0.7.3

- Traits, closures, iterators, `Option`
- Nested `Vec<Vec<T>>`; many non-everyday `Vec` element types (e.g. casual `Vec<f32>`)
- Generic maps beyond `string → i32` / `string → string`; insertion-order map iteration
- `Vec` index **writes** (by design — see Vec write story); `&mut Vec` as a mut slice; mut sub-slices
- Package manager; sockets / full net std
- Advanced fx Runtime (device-aware regions, capabilities, migration)
- Neuton / OS product; Experimental horizon features
- macOS prebuilt binary (Win/Linux only in-tree today)

### Intentionally deferred (architecture, not forgotten)

- Advanced fx Runtime layer (spec Phase 2) — optional; **D-003**
- Further zspec modules (hashmap, time, net, …) — **pull when `std/` needs C ABI**, not a checklist
- Deeper agent/LSP product work — optional; basic `fx lsp` / `fx mcp` exist

### Substrate (for linkers / embedders)

zspec **Minimal Core** (allocator, error, string, debug, platform) + `core_fx_region` + `core_fs` — fixed floor. Not a 17-module SDK milestone.

---

## Quick “can I build X?”

| Goal | Path |
|------|------|
| Hello + visible heap | `fx new hello` → `fx run` |
| Grow collections | value-thread `vec` / `map` / `buf` / `strbuf` |
| Iterate a map | `map_nth_*` / `std/map.nth_*` (table order) · see `examples/tool_tally` |
| Bytes | `Buf` / `Bytes` + `std/buf` · see `examples/tool_bytes` |
| Files | `std/io` + `effects { io }` · see `examples/tool_files` |
| Text path (str↔bytes↔file) | StrBuilder → file → `byte_at` → Buf · see `examples/tool_text` |
| Map string→string | `map_new_ss()` · `programs/lv073_map_ss.fx` |
| Mut slice write | `&mut [T]` on arrays · `programs/lv073_mut_slice.fx` |
| Result / `?` | general emit · see `examples/tool_result` |
| Embed in C | `--host` + [WRAP.md](WRAP.md) · `examples/showcase_wrap` |
| Inspect lowering | `fx emit-c` |

---

[START_HERE.md](START_HERE.md) · [LANGUAGE.md](LANGUAGE.md) · [REFERENCE.md](REFERENCE.md) · [STD.md](STD.md) · [CLI.md](CLI.md) · [REGIONS.md](REGIONS.md) · [WRAP.md](WRAP.md)
