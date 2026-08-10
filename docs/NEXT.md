# What’s next for fx

**Last updated:** 10 August 2026

fx **0.9.6** is the current public package: an **honesty freeze** (argv · platforms · vendor pin)
on top of the **0.9.5** production surface — std packs, structured concurrency, capability-region
IR dual-path, NetCap TCP dial (TLS refused), native `fx test` / `fx fuzz`, and `fx mod` checksum pin.

**Product focus:** teachable composition and honest host boundaries — not mut sugar,
not a package registry first, not a heavy debugger as the bar for “tooling.”

There is **no** `v0.9.25` cut — that mid-lane was cancelled; its work shipped in **0.9.5**.
**0.9.6** is not **v1.0**.

---

## Locked choices

| Topic | Choice |
|-------|--------|
| Slot updates in region storage | Explicit APIs (`vec_set`, pool set, arrays / `&mut` slices) |
| Growable vector index-assign (`v[i] = x`) | **Not** adding this sugar |
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

## Near-term

1. Keep teaching docs and dogfood green on both run paths.  
2. Deepen C wraps when an app needs them — [LIBRARIES.md](LIBRARIES.md).  
3. Selective editor deepen only if `#line`/gdb or thin LSP proves insufficient ([EDITOR.md](EDITOR.md), [DEBUG.md](DEBUG.md)).  
4. Later boards when friction forces them: TLS, vendor-first resolve, macOS prebuilt, concur keywords.

**Not next:** opening a package registry, DAP product, Soft-fx, calling the next cut “v1.0” prematurely.

---

## What this is not

- Dropping readable C emission  
- Hidden mutation / Soft-fx  
- Wrapping every C library before a program needs it  
- Claiming certification as part of the language package  
- Heavy IDE / debugger as the definition of editor support  
- Shipping private boards or harness as the public repo root  

---

## Related

- [DOGFOOD.md](DOGFOOD.md) · [QUALITY.md](QUALITY.md) · [LIBRARIES.md](LIBRARIES.md) · [COMPOSITION.md](COMPOSITION.md)  
- [releases/0.9.6.md](releases/0.9.6.md) — latest release notes  
