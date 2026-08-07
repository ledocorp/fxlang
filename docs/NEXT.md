# What’s next for fx

**Last updated:** 7 August 2026

fx **0.8.5** (builds on **0.8.1**) makes the adoptable story **visible in the language package**:
IR → native (QBE shipped), readable C emission, dogfood Apps 1–5, day-one editor loop,
SoA composition, host-minted I/O authority, and a lean agent loop.
Capability-region *language* values remain **later**.

**Product focus:** polish and honesty for small correctness-sensitive tools — not mut sugar,
not a package registry first, not a heavy debugger product as the bar for “tooling.”

---

## Locked choices

| Topic | Choice |
|-------|--------|
| Slot updates in region storage | Explicit APIs (`vec_set`, pool set, arrays / `&mut` slices) |
| Growable vector index-assign (`v[i] = x`) | **Not** adding this sugar |
| Shared “Cell-style” interior mutability | **Not** the fx method |
| Structured graphs / tables | Prefer parallel `Vec`s + typed ids (SoA) — see [COMPOSITION.md](COMPOSITION.md) |
| Explicit types (`i32`, effects, regions) | Stay visible on purpose — domain names reduce noise, not soft inference |
| Package manager / registry | **Later** — path imports and `std/` for now |
| Sandboxed / capability regions | Host-minted reads **today**; typed caps **later** |
| Native IR backend | Keep trustworthy for real apps — dual path with emit-C stays the product |
| Language “tiers” | One everyday dialect; optional deeper assurance on selected modules |

Grow stays visible: `v = vec_push(v, x)`.
Slot writes stay explicit and do not reallocate.

See [COMPOSITION.md](COMPOSITION.md) · [AGENT.md](AGENT.md).

---

## Near-term product work

1. Keep composition teaching and dogfood apps green on both run paths.  
2. Deepen C wraps when an app needs them — [LIBRARIES.md](LIBRARIES.md).  
3. Host-boundary authority: C mints reads; guest takes bytes (`examples/cap_host_smoke/`).  
4. Selective editor deepen only when `#line`/gdb or the thin LSP loop proves insufficient ([EDITOR.md](EDITOR.md), [DEBUG.md](DEBUG.md)).  

---

## What this is not

- Dropping readable C emission  
- Turning fx into Rust-with-regions via hidden mutation  
- Wrapping every popular C library before anyone has a program that needs it  
- Claiming certification or a full formal toolchain as part of the language package  
- Heavy IDE / debugger product as the ongoing definition of “editor support”  
- Softening types so code “looks more like Python/Rust”

---

## Related

- [DOGFOOD.md](DOGFOOD.md) — the dogfood apps  
- [QUALITY.md](QUALITY.md) — public quality habits  
- [LIBRARIES.md](LIBRARIES.md) — C wrap priorities  
- [COMPOSITION.md](COMPOSITION.md) — how to build  
- [releases/0.8.5.md](releases/0.8.5.md) — latest release notes  
