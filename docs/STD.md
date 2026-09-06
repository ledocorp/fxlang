# Standard library (`std/`)

Ordinary fx modules. Import them like any other library. They are not the C runtime and not the compiler.
Linking still uses zspec when you allocate through the usual paths.

Canonical web copy: https://www.ledocorp.org/fx/docs/std/

```fx
import std/vec;
import std/map;
import std/string;
```

## Modules (0.9.71 inventory)

Full cheatsheet table: [SURFACE.md](SURFACE.md) §D. Summary:

| Bucket | Modules |
|--------|---------|
| Core | `vec` `string` `map` `set` `buf` `box` `pair` `math` `fmt` `io` `queue` `pool` `fx_defaults` |
| Caps / guest / net | `cap` `guest` `io_cap` `net` |
| Concurrency | `nursery` `chan` `select` `mailbox` `supervise` `sync` (`async` = deprecated stub) |
| Path / data / time | `path` `strutil` `encoding` `fs` `fs_walk` `log` `json` `json_validate` `json_full` `sqlite` `http` `time` `env` |
| Testing | `testing` `proptest` |

## Mutation reminder

- Grow: reassign (`vec.push` / `vec_push`)
- Slot write: `vec_set` / `std/vec.set` under `mut` (no realloc)
- **Yes** no-grow `v[i] = x` under `mut` (same as `vec_set`)
- **No** growable realloc under index-assign

See [COMPOSITION.md](COMPOSITION.md). Library wrap priorities beyond `std/`: [LIBRARIES.md](LIBRARIES.md).

## Value-threading

Growing operations return an updated handle. Always reassign:

```fx
v = vec.push(v, 40); // or vec_push(v, 40)
m = map.insert(m, "w", 30); // or map_insert(...)
b = string.append(b, "hi"); // builder path
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

## Testing (native culture)

- `std/testing`, `std/proptest` — asserts with stderr diagnostics, property helpers 
- `fx test` / `fx fuzz` — discover `*_test.fx`, named `test_*`, dual-path (`--backend c|ir|both`); fuzz runs an fx-compiled driver 
- Shared corpora live under `validation/reference/`; assure dogfood under `examples/assure/`

## Capability / guest sessions

- `std/cap` — `FsCap` / `OutCap` / `AllocCap` / `FuelCap` / `NetCap` (allowlist) 
- `std/guest` — begin/end/`begin_nested`, mint_*, alloc/burn, `mint_net` / `net_allows` 
- `std/io_cap` — cap-scoped file I/O 
- `std/net` — TCP `dial` under NetCap allowlist. `dial_tls` exists as a facade but **always fails** in this language package (default `host/cap` dial has no TLS). HTTPS belongs to the separate **fxfetch** tool (links Mbed TLS). 

- `dynamic region g = guest(n)` — language sugar (emit-C + IR + `host/cap` link) 
- process-trust ambient `std/io` remains for ordinary tools

## Concurrency (synthesis product)

- `std/nursery`, `std/chan`, `std/select`, `std/mailbox`, `std/supervise` — structured nursery, i32/i64 channels, select timeout, mailboxes, supervision apply 
- `nursery.spawn_i32` / `await_i32` — production API (keyword `nursery`/`spawn`/`await` later) 
- Host runtime under the std APIs; emit-C + IR dual-path for linked `concur_*` 
- Not a Go/Erlang/BEAM runtime identity claim

## Path, encoding, fs, log, json, sqlite (0.9.x production)

- `std/path` — join, parent_len, basename_off, ext_off, is_abs, has_double_sep 
- `std/strutil` — contains / starts_with / ends_with 
- `std/encoding` — hex + base64 over `Vec<i32>` byte codes 
- `std/fs` — `copy_file`; `std/fs_walk.list_names` for directory names 
- `std/log` — thin tagged stderr helpers 
- `std/json` — thin cJSON path facade (link cJSON) 
- `std/json_validate` / `std/json_full` — fx-native validate path 
- `std/sqlite` — SQLite WRAP facade (link amalgamation; FsCap path available) 
- Also: `std/time`, `std/env` (argv stays host/cli), `std/http` (llhttp parse), `std/sync` mutex

## Growth

The stdlib stays modular and lean at link time. Deferred domains land when pulled — still as explicit, allocator-aware fx code.

[LANGUAGE.md](LANGUAGE.md) · [REGIONS.md](REGIONS.md) · [REFERENCE.md](REFERENCE.md)
