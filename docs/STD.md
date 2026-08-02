# Standard library (`std/`)

Ordinary fx modules. Import them like any other library. They are not the C runtime and not the compiler.
Linking still uses zspec when you allocate through the usual paths.

Canonical web copy: https://www.ledocorp.org/fx/docs/std/

```fx
import std/vec;
import std/map;
import std/string;
```

## Modules in 0.7.5

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
| `pool` | Id-pool facade (`make`/`alloc`/`get`/`set`/`len`/`raw`/`from_raw`) — typed **`Id`**; needs `lib/id_pool` |
| `buf` | Growable `Buf` + `Bytes` view |
| `fx_defaults` | Small defaults-related constants/helpers |

## Value-threading

Growing operations return an updated handle. Always reassign:

```fx
v = vec.push(v, 40);           // or vec_push(v, 40)
m = map.insert(m, "w", 30);    // or map_insert(...)
b = string.append(b, "hi");    // builder path
```

Quieter patterns (same semantics): loop `v = vec.push(v, n)`, and `&mut` state `p.nodes = vec.push(p.nodes, x)`. Scaffolds keep let-chains for first teaching.

## Vec

- Facade: `vec.new` / `push` / `get` / `len` (and arena variants where applicable)
- Builtins: `vec_new`, `vec_push`, `vec_get`, field `.len`
- Elements: integers (incl. unsigned widths), `bool`, `string`, structs, payload enums
- Reads: `v[i]` sugar or `get` / `vec_get` (same emit); **no** `v[i] = x`
- Slot writes: `vec_set` / `std/vec.set` (requires `mut`; no grow)
- Note: the thin `std/vec.get` facade is typed around everyday `i32` use; for other element types prefer builtins

## String and StrBuilder

- Fixed strings: `str_compare`, `str_concat`, `str_len`, `str_byte_at`
- Builder: `strbuf_new` / `strbuf_push` / `strbuf_finish` · facade `builder` / `append` / `build`
- Prefer the builder for loops; pairwise `str_concat` is fine for single joins

## Buf and Bytes

- Growable region buffer: `buf_new` / `buf_push` / `buf_len` / `buf_get` / `buf_finish`
- Immutable view: `bytes_len` / `bytes_get`
- Facade `std/buf`: `new` / `push` / `len` / `get` / `finish` / `view_len` / `view_get`
- Value-threaded like `vec_push` (`b = buf.push(b, x)`)

## Map and set

- Implemented map: **`Map<string, i32>`** (+ `Map<string, string>` ss variants)
- `map_new` / `insert` / **`add_i32`** / `remove` / `get` / `contains` / `len`
- **`map_add_i32`**: existing key → slot add (no grow); miss → insert (may grow)
- Dense iterate: `map_nth_key` / `map_nth_value` (index `0 .. map_len(m)`; table order, not insertion order; OOB → `""` / `0`)
- Facade `std/map`: `nth_key` / `nth_value` / `add_i32`
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

- **`std/queue`** needs `lib/ring_queue.fx` beside the project (or package root). `fx new` (simple) stages both `std/` and `lib/ring_queue.fx`. The public package ships `lib/`.
- **`std/pool`** needs `lib/id_pool.fx` (also staged by `fx new`). Handles are typed **`Id`**. `set` uses `vec_set` (stable slot write; D2). `raw` / `from_raw` unwrap/wrap explicitly.
- `fx new` (simple) copies a Core `std/` set beside your project so imports resolve offline.

## Growth

The stdlib is intentionally small in 0.7.x. The 0.7.2 baseline added Buf/Bytes facades and Map iterate; 0.7.3 adds `Map<string,string>` helpers (`*_ss`). Later packages may add richer I/O, paths, JSON, time/RNG, and testing helpers, still as explicit, allocator-aware fx code.

[LANGUAGE.md](LANGUAGE.md) · [REGIONS.md](REGIONS.md) · [REFERENCE.md](REFERENCE.md)
