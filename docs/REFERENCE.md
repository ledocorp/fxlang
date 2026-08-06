# Reference (0.7 surface)

Compact lookup for everyday fx in the **0.8.0** package.
Prefer the [language tour](LANGUAGE.md) when learning.
This page describes the language *as implemented*, not aspirational north-star ideas.
For the full inventory (cheatsheet + depth ledger), see [SURFACE.md](SURFACE.md).

Canonical web copy: https://www.ledocorp.org/fx/docs/reference/

## Keywords

`enum` `struct` `extern` `fn` `import` `let` `match` `module` `return` `effects`
`if` `while` `for` `break` `continue` `else` `defer` `region` `arena` `scope`
`temp` `fx` `own` `mut` `true` `false` `using` · plus `ok` / `err` constructors in Result paths.

Comments: `//` line comments. Refinement `where` is contextual (verification tier).

## Literals

- Integers: decimal `123`, hex `0x1F` (underscores allowed)
- Floats: `1.5` (defaults `f64`), `1.5f32`
- Chars: `'A'`, `'\n'` (lower to `i32` byte values)
- Strings: `"…"` with standard escapes · bools: `true` / `false`

## Program shape

- File: module library (`module name;`) or program with `fn main`
- Entry: usually `fn main() -> i32`; may return `Result<i32, core_Err>`
- Imports: `import std/vec;` (path; last segment = alias; no transitive visibility)
- Zspec into scope: `using core;` / `using core.mem;`
- FFI: `extern "c" { fn name(args) -> ret; }`

## Types

| Kind | Forms |
|------|-------|
| Integers | `i8` `i16` `i32` `i64` `u8` `u16` `u32` `u64` |
| Floats | `f32` `f64` |
| Scalars | `bool` `string` `void` `core_Err` |
| User types | `struct Name { … }` · `enum Name { A, B(T) }` |
| Collections | `Vec<T>` · `[T; N]` · `&[T]` · `&mut [T]` · `StrBuilder` · `Map<string, i32>` · `Map<string, string>` · `Buf` / `Bytes` |
| Sum | `Result<T, E>` (typically `core_Err`) |
| Ownership | `own T` · `&T` · `&mut T` · `&region r T` |
| Generics | Type params on functions/structs · no traits |

`Vec<T>` elements commonly used: integers (incl. unsigned widths), `bool`, `string`, structs, payload enums. Casts: `expr as T` for numeric targets only.

## Effects

```fx
fn f() -> i32 effects { alloc, mut, io } { … }
```

| Effect | Meaning |
|--------|---------|
| `alloc` | Heap / arena allocation |
| `mut` | Mutation of heap / exclusive borrows as required |
| `io` | Host I/O (stdout, files, …) |

## Regions

| Syntax | Role |
|--------|------|
| `region r = arena(n);` | Default heap arena |
| `region r = temp(n);` | Short-lived heap batch |
| `region r = scope;` | Stack borrow region (no heap) |
| `region r = fx(n);` | Hierarchical fx region |

Details: [REGIONS.md](REGIONS.md)

## Operators

- Arithmetic: `+ - * / %` (integers; `%` int-only) · `+ - * /` (floats) · unary `-`
- Bitwise: `& | ^ << >>` on integer families
- Logical: `!` `&&` `||` (bool)
- Compare: `== != < <= > >=`
- Index: arrays R/W; `&[T]` read-only; `&mut [T]` write-through (array-backed); Vec **read** via `v[i]` / `vec_get`; Vec **slot** via `vec_set`
- Sub-slice: `a[lo..hi]` → `&[T]` (exclusive `hi`; arrays, `Vec`, or slices)
- Cast: `expr as T` · deref: `*p`

**No** `v[i] = x` on `Vec` (by design). Slot writes: `vec_set` / `std/vec.set`. Views: arrays + `&mut [T]`.

## Statements

- `let x: T = expr;` · reassignment · `return`
- `if` / `else` · `while` · `for (let i = …; …; …)`
- `break` / `continue` · `defer stmt;` · `match`
- `region r = …;`

## Result / ?

- Construct: `Ok(x)` / `Err(e)` (typically with `using core;`)
- Propagate: `let x = f()?;` and `x = f()?;`
- No `Option`; use `Result`

## Builtins vs std facades

| Area | Builtins (common) | std facade |
|------|-------------------|------------|
| Vec | `vec_new` `vec_push` `vec_get` `vec_set` · `.len` | `std/vec` (`new`/`push`/`get`/`set`/`len`) |
| String | `str_compare` `str_concat` `str_len` `str_byte_at` | `std/string` |
| Builder | `strbuf_new` `strbuf_push` `strbuf_finish` `strbuf_len` | `builder`/`append`/`build` |
| Map | `map_new` `map_insert` **`map_add_i32`** `map_get` `map_contains` `map_nth_*` … | `std/map` (`add_i32`, …) · set via `std/set` |
| Pool | (via facade / lib) | `std/pool` + `lib/id_pool` — typed **`Id`**; `set` → `vec_set` |
| Fmt / IO | (via facades) | `std/fmt` · `std/io` |

Growing ops are **value-threaded**: reassign `v = vec_push(v, x)`, `m = map_insert(m, k, v)`, `m = map_add_i32(m, k, d)`, `b = strbuf_push(b, s)`.
Non-toy compose: `examples/composition_tally`, `examples/composition_reach`.

## Scaffolds

| Kind | Use when |
|------|----------|
| `simple` | Default: region + `std/vec` |
| `minimal` | Bare `main`; add region yourself |
| `embedded` | Tiny arena; builtin `vec_*`; no staged std |

## Honesty bound (not in 0.7 yet)

- Traits, closures, iterators, `Option`
- Nested `Vec<Vec<T>>`; `Vec<f32>` and many non-everyday element types
- Generic maps beyond `string → i32` / `string → string`; insertion-order map iteration (nth is table order)
- `Vec` index **writes** (`v[i] = x` — refused); `&mut Vec` as slice; mut sub-slices
- Package manager; advanced fx Runtime device/capability model
- Non-C FFI

Advanced: refinement types (`where` predicates) exist as a verification tier and typically need an external prover pipeline. Not required for everyday 0.7 programs.

[LANGUAGE.md](LANGUAGE.md) · [CLI.md](CLI.md) · [SURFACE.md](SURFACE.md) · https://www.ledocorp.org/fx/llms.txt
