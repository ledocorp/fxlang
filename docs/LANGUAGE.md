# The fx language

fx is a systems language built for locality of reasoning: allocation, mutation, ownership, and I/O
show up in the source, then lower to readable C on a small zspec substrate.
The **0.9.71** package is a full programming surface, not just “regions + vec.”
It includes Buf/Bytes, sub-slices, Map iterate (`string→i32` / `string→string`), **`map_add_i32`** accumulate,
typed **`Id`** pools (`std/pool`), grow ergonomics, Vec `v[i]` reads / no-grow `v[i]=x` / `vec_set` slot writes,
array-backed `&mut [T]`, lexical loan checking on `&`/`&mut`, structured concurrency facades, SIMD/`@override` footholds,
and general Result/`?`. Non-toy demos: `examples/composition_tally`, `composition_reach`, `dogfood_pathc_slots`.

**How to compose** (ids, accumulate, reachability, grow/freeze, dual-emit tracking): [COMPOSITION.md](COMPOSITION.md) · [TRACKING.md](TRACKING.md).

Canonical web copy: https://www.ledocorp.org/fx/docs/language/

## What fx is trying to be

- **Explicit** · no hidden allocator, no tracing GC, no magic control flow
- **Dual emission** · run natively *and* emit C a competent C programmer can maintain
- **Tiered** · ownership/regions (safe) → effects → optional refinement contracts
- **C-native** · wrap existing libraries; do not pretend C never existed
- **Predictable for humans and agents** · mechanical style, local decisions

## Design pillars

### 1. Explicit effects

```fx
fn main() -> i32 effects { alloc, mut, io } {
 // may allocate, mutate, and do I/O
}
```

Implemented effects: `alloc`, `mut`, `io`, `concur`, `atomic`, `mmio`. Pure functions omit the clause. Callers can see cost before reading the body.

### 2. Named regions

```fx
region r = arena(4096); // heap arena
region t = temp(1024); // short-lived heap batch
region s = scope; // stack borrow region (no heap)
region f = fx(4096); // hierarchical fx region
```

Full walkthrough: [REGIONS.md](REGIONS.md) (ownership, `&` / `&mut` / `&region`, all region kinds).

### 3. Dual emission

- `fx run` / `fx build` · emit, link zspec, run or produce a binary
- `fx emit-c` · inspect `.c` / `.h`
- `--host` · C owns `main`; fx is the library

### 4. Small but real standard library

`std/` is ordinary fx you `import`. See [STD.md](STD.md) for APIs beyond `vec`.

## Program structure

- Apps: usually `fn main() -> i32` (exit code). `main` may also return `Result<i32, core_Err>`.
- Libraries: `module name;` at the top of a `.fx` file.
- Imports: `import std/vec;` · last path segment is the alias (`vec.push`).
- **Local lets** may omit the type when the initializer determines it (`let x = 42;`).
 Function **parameters and returns stay explicit**. Surface JSON stays an exact API passport
 (no soft inferred signatures). Ambiguous RHS (e.g. empty `[]` as an array) is a loud error — annotate.
- **Batch Vec init:** `let v: Vec<i32> = [40, 2];` expands to `vec_new(0)` + `vec_push` (same grow
 physics as `v.push`). Requires a `Vec<T>` annotation (≤32 elems). Plain `[T; N]` arrays are unchanged.
- **Facets (static contracts):** `facet Writer { … }` + `attach Writer for File { … }` + `where T: Writer`
 on generics. Calls monomorphize to named C (`fx_facet_Writer_File_write`). Not traits / `dyn`.
 Demo: `examples/facet_writer/`.
- **Cap dictionaries (dynamic tables):** `capdict WriterDict { … }` + mint with `ctx` + fn slots;
  invoke `d.write(n)` → visible C vtable. Dual-path: emit-C and IR when QBE is staged.
  Demo: `examples/capdict_writer/`.
- **Atomics:** `Atomic<i32>` + `Atomic.new` / `.load` / `.store` / `.fetch_add` with **explicit**
  `order.{relaxed,acquire,release,acq_rel,seq_cst}` under `effects { atomic }`. emit-C → `<stdatomic.h>`.
  Dual-path IR when QBE is staged. Demo: `examples/kern_atomic/`.
- **MMIO:** `MmioCap.mint_hosted()` + `mmio_read32` / `mmio_write32` under `effects { mmio }`.
  Cap-gated `volatile` in C — no ambient poke. Dual-path IR when QBE is staged. Demo: `examples/kern_mmio/`.
- **Freestanding compile:** `fx run … --freestanding --emit-c` → `-ffreestanding`; no zspec;
 hosted CRT still links for exit proof (not `-nostdlib`).
- Zspec symbols: `using core;` (for idiomatic `Err` / `core_Err`).
- C FFI: `extern "c" { fn name(…) -> …; }` then link with `--host` / link flags.

## Types (as implemented)

| Category | What you can use |
|----------|------------------|
| Integers | `i8` `i16` `i32` `i64` · `u8` `u16` `u32` `u64` |
| Floats | `f32` `f64` (unsuffixed float literals default to `f64`; use `1.5f32`) |
| Other scalars | `bool` · `string` · `void` · `core_Err` |
| Aggregates | `struct` · `enum` (unit + payload variants) |
| Collections | `Vec<T>` · `[T; N]` · `&[T]` · `&mut [T]` · `StrBuilder` · `Map<string, i32>` · `Map<string, string>` · `Buf` / `Bytes` · pool **`Id`** |
| Errors | `Result<T, E>` (usually `core_Err`) |
| Ownership | `own T` · `&T` · `&mut T` · `&region r T` |
| Generics | Functions and structs (`fn new<T>(…)`, `Box<T>`, `Pair<A,B>`) · no traits |

Numeric rule of thumb: same-family ops only; `i32↔i64` and `f32↔f64` can widen; **no** implicit signed↔unsigned or int↔float. Use postfix cast: `x as u32`.

## Control flow and data

- `if` / `else`, `while`, C-style `for`, `break` / `continue`
- Exhaustive `match` on enums (including payload variants)
- `defer stmt;` for LIFO cleanup on scope exit
- Struct literals `P { a: 1 }`, field access, array index `a[i]`, slice read `s[i]`

```fx
enum Tok { Num(i32), End }

fn value(t: Tok) -> i32 {
 return match t {
 Num(n) => n,
 End => 0,
 };
}
```

## Errors: Result and ?

```fx
using core;

fn parse_positive(n: i32) -> Result<i32, core_Err> {
 if (n <= 0) {
 return Err(CORE_ERR_INVALID_ARG);
 }
 return Ok(n);
}

fn main() -> Result<i32, core_Err> {
 let v = parse_positive(10)?;
 return Ok(v);
}
```

There is no `Option`: use `Result`. Map lookup misses are errors and compose with `?`.

## Value-threading (important idiom)

Growing collections return an updated handle. **Reassign** the result (same pattern for `vec`, `map`, `strbuf`, `buf`):

```fx
v = vec_push(v, 40);
m = map_insert(m, "width", 30);
b = strbuf_push(b, "hello");
```

Three teaching patterns (no hidden mutation):

1. **Method sugar / reassign** (default scaffolds): `v.push(40);` or `v = vec.push(v, 40);`
2. **Loop reassignment**: `v = vec.push(v, n);` inside a `while`
3. **`&mut` state fields**: `p.nodes = vec.push(p.nodes, x);` instead of rebuilding the whole struct

Tutorial **let-chains** (`let v2 = vec.push(v, …)`) still work and still work — they are just not the scaffold default.

Prefer `vec_get(v, i)` or sugar `v[i]` for **reads**. For in-place **slot** writes use `vec_set` / no-grow `v[i]=x` (needs `mut`), or arrays + `&mut [T]`. Growable realloc under index-assign stays (not supported).

Record update (new value, ): `let p2 = p with { y: 32 };`

## First programs

### Minimal

```fx
fn main() -> i32 {
 return 42;
}
```

`fx new tiny --scaffold minimal`

### Recommended (visible heap + std/vec)

```fx
import std/vec;

fn main() -> i32 effects { alloc, mut } {
 region r = arena(4096);
 let v: Vec<i32> = vec.new(0);
 v.push(40);
 v.push(2);
 return vec.get(v, 0) + vec.get(v, 1);
}
```

`fx new hello` (default **simple** scaffold)

### Arrays and slices

```fx
fn sum(s: &[i32]) -> i32 {
 let mut acc: i32 = 0;
 for (let i: i32 = 0; i < s.len; i = i + 1) {
 acc = acc + s[i];
 }
 return acc;
}

fn main() -> i32 {
 let table: [i32; 3] = [10, 20, 12];
 let view: &[i32] = &table;
 let mid: &[i32] = table[0..2]; // exclusive end → [10, 20]
 return sum(view); // 42
}
```

### Working with C

```text
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
```

See [WRAP.md](WRAP.md) for `extern "c"` and linking.

## What not to expect (yet)

- Traits / interfaces / closures / iterators
- `Option<T>` (use `Result`)
- Generic `Map` beyond `string→i32` / `string→string`; insertion-order iteration
- Growable `Vec` index-assign that **reallocates** (no-grow `v[i]=x` / `vec_set` are OK); `&mut Vec` as a slice; mut sub-slices
- Package **registry** / large application ecosystem (offline `fx.mod` / `fx.sum` pin exists)
- Direct Rust/Go/Zig FFI (C ABI only; others speak C)
- Lifetime parameters / NLL; optional `loan { }` block sugar (not shipped)

Compact lookup: [REFERENCE.md](REFERENCE.md) · [REGIONS.md](REGIONS.md) · [STD.md](STD.md) · [CLI.md](CLI.md)
