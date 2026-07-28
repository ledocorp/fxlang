# Standard library (`std/`)

Ordinary fx modules. Import them like any other library. They are not the C runtime and not the compiler.
Linking still uses zspec when you allocate through the usual paths.

Canonical web copy: https://www.ledocorp.org/fx/docs/std/

```fx
import std/vec;
import std/map;
import std/string;
```

## Modules in 0.7.1

| Module | Role |
|--------|------|
| `vec` | Growable vectors |
| `string` | Compare / concat / builder helpers |
| `map` | `Map<string, i32>` dictionary |
| `set` | Set facade over map (presence = 1) |
| `box` / `pair` | Generic ownership / pair helpers |
| `math` | `abs` `min` `max` `clamp` … |
| `fmt` | Integer / tag formatting helpers |
| `io` | Lines + minimal file I/O (`effects { io }`) |
| `queue` | Bounded queue facade (see caveat below) |
| `fx_defaults` | Small defaults-related constants/helpers |

## Value-threading

Growing operations return an updated handle. Always reassign:

```fx
v = vec.push(v, 40);           // or vec_push(v, 40)
m = map.insert(m, "w", 30);    // or map_insert(...)
b = string.append(b, "hi");    // builder path
```

## Vec

- Facade: `vec.new` / `push` / `get` / `len` (and arena variants where applicable)
- Builtins: `vec_new`, `vec_push`, `vec_get`, field `.len`
- Elements: integers (incl. unsigned widths), `bool`, `string`, structs, payload enums
- No `v[i]` · use `get` / `vec_get`
- Note: the thin `std/vec.get` facade is typed around everyday `i32` use; for other element types prefer builtins

## String and StrBuilder

- Fixed strings: `str_compare`, `str_concat`, `str_len`, `str_byte_at`
- Builder: `strbuf_new` / `strbuf_push` / `strbuf_finish` · facade `builder` / `append` / `build`
- Prefer the builder for loops; pairwise `str_concat` is fine for single joins

## Map and set

- Implemented map: **`Map<string, i32>` only**
- `map_new` / `insert` / `remove` / `get` / `contains` / `len`
- `map_get` returns `Result<i32, core_Err>` · miss is an error · composes with `?`
- `std/set`: insert / contains / len over the same map shape

```fx
import std/map;
using core;

fn main() -> Result<i32, core_Err> effects { alloc, mut } {
    region r = arena(4096);
    let m0: Map<string, i32> = map.new();
    let m1 = map.insert(m0, "answer", 42);
    let v = map.get(m1, "answer")?;
    return Ok(v);
}
```

## IO and fmt

- `std/io`: write lines, read/write files · declare `io` (and `alloc` when needed)
- `std/fmt`: helpers such as `format_i64` / tag formatters for printable output

## Math, box, pair

- `std/math`: small pure helpers on `i32`/`i64`
- `std/box`, `std/pair`: generic struct helpers for ownership and pairing

## Caveats

- **`std/queue`** is authored against a `lib/ring_queue` module. That library path is not staged in the public package the way `std/` is. Treat queue as “language-ready; may need a local `lib/` copy until packaging stages it.”
- `fx new` (simple) copies `std/` beside your project so imports resolve offline.

## Growth

The stdlib is intentionally small in 0.7.1. Later packages may add richer collections, paths, JSON, time/RNG, and testing helpers, still as explicit, allocator-aware fx code.

[LANGUAGE.md](LANGUAGE.md) · [REGIONS.md](REGIONS.md) · [REFERENCE.md](REFERENCE.md)
