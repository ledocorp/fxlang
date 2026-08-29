# What’s next for fx

**Last updated:** 25 August 2026

fx **0.9.68** is the current public package: **GPL-3.0** license + **native-first Auto**
driver (live `sh_*` for the supported demo set; honest foundry fallback otherwise), on top of **0.9.67** packaging polish,
**0.9.66** Path C living dogfood (no-grow `v[i]=x`, `--cli` auto-host), the **0.9.6**
honesty freeze (argv · platforms · vendor pin), and the **0.9.5** production surface.

**Product focus:** sharp rules + short paths + real tools — not Soft-fx,
not a package registry first, not a heavy debugger as the bar for “tooling.”

**Short paths:** Vec read `v[i]` · slot `vec_set` / no-grow `v[i]=x` (needs `mut`) · grow `push` —
same physics; Soft-fx refused. See [COMPOSITION.md](COMPOSITION.md) and [SURFACE.md](SURFACE.md).

**0.9.68** is not **v1.0**.

---

## Locked choices

| Topic | Choice |
|-------|--------|
| Slot updates in region storage | `vec_set` and no-grow `v[i]=x` under `effects { mut }` |
| Growable vector index-assign (realloc under `v[i]=x`) | **Refused** — grow stays `push` / reassign |
| Shared “Cell-style” interior mutability | **Not** the fx method |
| Structured graphs / tables | Prefer parallel `Vec`s + typed ids (SoA) — see [COMPOSITION.md](COMPOSITION.md) |
| Explicit types (`i32`, effects, regions) | Stay visible on purpose |
| Program argv on `fx run` | **Frozen** — thin C host / `--scaffold cli` |
| Prebuilt platforms | **Frozen** — Windows + Linux x86_64 only |
| `fx mod` / `fx.sum` | **Frozen** checksum pin; compile still uses `std/` / `FX_STD_ROOT` |
| Package manager / registry | Vendor pin now; registry later (VCS modules — not an empty registry site) |
| Sandboxed / capability regions | Host-minted caps + guest session; ambient `std/io` for process-trust |
| Network authority | NetCap allowlist + TCP dial; **TLS** only when an app demands |
| Native IR backend | Dual path with emit-C stays the product |
| Language “tiers” | One everyday dialect; optional deeper assurance |

Grow stays visible: `v = vec_push(v, x)`.

---

## Suggested next: keep building apps

Language boards are not the primary climb anymore. Prefer **one real tool at a time**.

Good pulls: wraps you actually need, dogfood programs, editor polish when it hurts,
and host/CLI ergonomics that remove ceremony without soft signatures.

---

## Related

- [DOGFOOD.md](DOGFOOD.md) · [QUALITY.md](QUALITY.md) · [LIBRARIES.md](LIBRARIES.md) · [COMPOSITION.md](COMPOSITION.md)  
- [releases/0.9.68.md](releases/0.9.68.md) — latest release notes  
- [releases/0.9.66.md](releases/0.9.66.md) — Path C dogfood  
