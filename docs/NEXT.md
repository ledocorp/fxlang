# What’s next for fx

**Last updated:** 2 November 2026

fx **1.0.0** is the current public package — first **stable promise** tag.

It keeps the **0.9.75** trust/teach surface and adds **vendor-first** resolve
(`vendor/std` + `fx.sum` when present). Everyday freezes remain: Windows + Linux
x86_64; argv via `--cli`; GPL-3.0; emit-C permanent.

**Product focus:** clear rules, short paths, and real tools — not a package
registry first, and not a heavy debugger as the bar for “tooling.”

**Short paths:** Vec read `v[i]` · slot update `vec_set` / no-grow `v[i]=x` (needs
`mut`) · grow with `push` / batch `let v: Vec<T> = […]` · local `let x = …` when
the right-hand side makes the type obvious. Loans: shared XOR mut · end at the
call · diagnostics FX0015/FX0019.
See [COMPOSITION.md](COMPOSITION.md), [REGIONS.md](REGIONS.md), and [SURFACE.md](SURFACE.md).

**Get started:** [WEEKEND.md](WEEKEND.md) · **How compile works:** [DRIVERS.md](DRIVERS.md) · **Never / may:** [GAPS.md](GAPS.md)

**1.0.0** is the stable floor; 1.x may deepen without Soft-fx.

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
| Prebuilt platforms | **Frozen** — Windows + Linux x86_64 only (`fx target` lists linux-aarch64 emit-C recipe; no aarch64 zip) |
| `fx.mod` / `fx.sum` | Pin + **vendor-first**: when `vendor/std` verifies, compile uses it; else `std/` / `FX_STD_ROOT`. `fx new` writes `fx.mod`. |
| Package manager / registry | Pin now; download registry later |
| Sandboxed / capability regions | Host-minted caps + guest session; ambient `std/io` for process-trust |
| Network | TCP dial in-package; HTTPS via **fxfetch** (separate tool) |
| Native IR backend | Dual path with readable C stays the product |
| Language “tiers” | One everyday dialect; optional deeper assurance |

Grow stays visible: `v.push(x)` / `v = vec_push(v, x)`.

---

## Suggested next

1. Follow the [weekend path](WEEKEND.md) (hello → CLI → optional fxserve).
2. Run `scripts/verify-pack` ([QUALITY.md](QUALITY.md)) after install.
3. Prefer **one real tool at a time** — [SHIP.md](SHIP.md).
4. Optional: `fx mod vendor` / `verify` for offline `vendor/std` (compile prefers it when present).
5. Further language and tool work continues in later **0.9.x** / **1.x** cuts when useful.

**Companion tools** (separate GitHub packs — not this zip): [LIBRARIES.md](LIBRARIES.md) ·
https://www.ledocorp.org/fx/tools/

See also: [SURFACE.md](SURFACE.md) · [DRIVERS.md](DRIVERS.md) · [GAPS.md](GAPS.md) · [TRAP.md](TRAP.md) · [releases/](releases/).
