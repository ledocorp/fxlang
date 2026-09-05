# What’s next for fx

**Last updated:** 5 September 2026

fx **0.9.70** is the current public package: **GPL-3.0**, **native-first Auto**
`fx run` (live `sh_*` for the supported demo set; built-in fallback otherwise),
iterate ergonomics (scratch `fx run`, FXCACHE, `--watch`), local let elision + batch
Vec init, lexical loans, no-grow `v[i]=x`, `--cli` auto-host, plus the **0.9.6**
platform freezes (argv · platforms · vendor pin).

**Product focus:** sharp rules, short paths, and real tools — not a package registry
first, and not a heavy debugger as the bar for “tooling.”

**Short paths:** Vec read `v[i]` · slot `vec_set` / no-grow `v[i]=x` (needs `mut`) · grow `push` /
batch `let v: Vec<T> = […]` · local `let x = …` when the RHS determines the type.
Loans: shared XOR mut · call-end · diagnostics FX0015/FX0019.
See [COMPOSITION.md](COMPOSITION.md), [REGIONS.md](REGIONS.md), and [SURFACE.md](SURFACE.md).

**0.9.70** is not **v1.0**.

---

## Locked choices

| Topic | Choice |
|-------|--------|
| Slot updates in region storage | `vec_set` and no-grow `v[i]=x` under `effects { mut }` |
| Growable vector index-assign (realloc under `v[i]=x`) | **Not supported** — grow stays `push` / reassign |
| Shared “Cell-style” interior mutability | **Not** the fx method |
| Lexical loans | Shared XOR mut + region escape; no lifetime parameters / NLL |
| Structured graphs / tables | Prefer parallel `Vec`s + typed ids (SoA) — see [COMPOSITION.md](COMPOSITION.md) |
| Explicit types (`i32`, effects, regions) | Stay visible on purpose (local lets may elide when obvious) |
| Program argv on `fx run` | **Frozen** — `--cli` / thin C host / `--scaffold cli` |
| Prebuilt platforms | **Frozen** — Windows + Linux x86_64 only |
| `fx mod` / `fx.sum` | **Frozen** checksum pin; compile still uses `std/` / `FX_STD_ROOT` |
| Package manager / registry | Vendor pin now; registry later |
| Sandboxed / capability regions | Host-minted caps + guest session; ambient `std/io` for process-trust |
| Network | NetCap TCP dial in-package; TLS dial not in this package; HTTPS via **fxfetch** |
| Native IR backend | Dual path with emit-C stays the product |
| Language “tiers” | One everyday dialect; optional deeper assurance |

Grow stays visible: `v.push(x)` / `v = vec_push(v, x)`.

---

## Suggested next: keep building apps

Prefer **one real tool at a time**, deepen Surface when agents need richer passports,
or ship another cut when the maintainer asks.

See also: [SURFACE.md](SURFACE.md) · [LIBRARIES.md](LIBRARIES.md) · [releases/](releases/).
