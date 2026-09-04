# What’s next for fx

**Last updated:** 4 September 2026

fx **0.9.69** is the current public package: **GPL-3.0** + **native-first Auto**
driver (live `sh_*` for the supported demo set; honest built-in fallback otherwise),
iterate ergonomics (scratch `fx run`, FXCACHE, `--watch`), local let elision + batch
Vec init, lexical loans, no-grow `v[i]=x`, `--cli` auto-host, and the **0.9.6**
honesty freeze (argv · platforms · vendor pin).

**Product focus:** sharp rules + short paths + real tools — not Soft-fx,
not a package registry first, not a heavy debugger as the bar for “tooling.”

**Short paths:** Vec read `v[i]` · slot `vec_set` / no-grow `v[i]=x` (needs `mut`) · grow `push` /
batch `let v: Vec<T> = […]` · local `let x = …` when the RHS determines the type —
same physics; Soft-fx refused. Loans: shared XOR mut · Hylo call-end · FX0015/FX0019.
See [COMPOSITION.md](COMPOSITION.md), [REGIONS.md](REGIONS.md), and [SURFACE.md](SURFACE.md).

**0.9.69** is not **v1.0**.

---

## Locked choices

| Topic | Choice |
|-------|--------|
| Slot updates in region storage | `vec_set` and no-grow `v[i]=x` under `effects { mut }` |
| Growable vector index-assign (realloc under `v[i]=x`) | **Refused** — grow stays `push` / reassign |
| Shared “Cell-style” interior mutability | **Not** the fx method |
| Lexical loans | Shared XOR mut + region escape; no lifetime parameters / NLL |
| Structured graphs / tables | Prefer parallel `Vec`s + typed ids (SoA) — see [COMPOSITION.md](COMPOSITION.md) |
| Explicit types (`i32`, effects, regions) | Stay visible on purpose (local lets may elide when obvious) |
| Program argv on `fx run` | **Frozen** — `--cli` / thin C host / `--scaffold cli` |
| Prebuilt platforms | **Frozen** — Windows + Linux x86_64 only |
| `fx mod` / `fx.sum` | **Frozen** checksum pin; compile still uses `std/` / `FX_STD_ROOT` |
| Package manager / registry | Vendor pin now; registry later |
| Sandboxed / capability regions | Host-minted caps + guest session; ambient `std/io` for process-trust |
| Network | NetCap TCP dial in-package; TLS dial refused here; HTTPS via **fxfetch** tool |
| Native IR backend | Dual path with emit-C stays the product |
| Language “tiers” | One everyday dialect; optional deeper assurance |

Grow stays visible: `v.push(x)` / `v = vec_push(v, x)`.

---

## Suggested next: keep building apps

Language boards are not the only climb. Prefer **one real tool at a time**, deepen Surface
when agents need richer passports, or ship another cut when the steward asks.

Good pulls: wraps you actually need, dogfood programs, editor polish when it hurts,
and host/CLI ergonomics that remove ceremony without soft signatures.

---

## Related

- [DOGFOOD.md](DOGFOOD.md) · [QUALITY.md](QUALITY.md) · [LIBRARIES.md](LIBRARIES.md) · [COMPOSITION.md](COMPOSITION.md) · [SURFACE.md](SURFACE.md)  
- [releases/0.9.69.md](releases/0.9.69.md) — latest release notes  
- [releases/0.9.68.md](releases/0.9.68.md) — native-first Auto  
