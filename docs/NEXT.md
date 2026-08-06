# What’s next for fx

**Last updated:** 6 August 2026

fx 0.8.0 leads with **IR → native**, keeps **readable C emission** first-class, and ships
dogfood Apps 1–5 as real small tools. Capability-region sandboxes remain **design only**.

**Product focus:** adoptable fx for small correctness-sensitive tools — clear diagnostics,
thin C CLI hosts where argv is needed, honest dual paths, and libraries wrapped when an
app needs them. Not mut sugar, not a package registry first.

---

## Locked choices

| Topic | Choice |
|-------|--------|
| Slot updates in region storage | Explicit APIs (`vec_set`, pool set, arrays / `&mut` slices) |
| Growable vector index-assign (`v[i] = x`) | **Not** adding this sugar |
| Shared “Cell-style” interior mutability | **Not** the fx method |
| Package manager / registry | **Later** — path imports and `std/` for now |
| Sandboxed / capability regions | **Later** — same language rules; extra control over guest code |
| Native IR backend | Keep trustworthy for real apps — dual path with emit-C stays the product |

Grow stays visible: `v = vec_push(v, x)`.
Slot writes stay explicit and do not reallocate.

See [COMPOSITION.md](COMPOSITION.md).

---

## Near-term product work

1. Keep composition teaching and dogfood apps green on both run paths.  
2. Deepen C wraps when an app needs them (hashes, compress, paths) — [LIBRARIES.md](LIBRARIES.md).  
3. Maintain IR + emit-C parity on the tools people actually run.  
4. Capability sandboxes and a package manager only when a concrete tool needs them.

---

## What this is not

- Dropping readable C emission  
- Turning fx into Rust-with-regions via hidden mutation  
- Wrapping every popular C library before anyone has a program that needs it  
- Claiming certification or a full formal toolchain as part of the language package  

---

## Related

- [DOGFOOD.md](DOGFOOD.md) — the dogfood apps  
- [QUALITY.md](QUALITY.md) — public quality habits  
- [LIBRARIES.md](LIBRARIES.md) — C wrap priorities  
- [COMPOSITION.md](COMPOSITION.md) — how to build  
- [releases/0.8.0.md](releases/0.8.0.md) — this package’s release notes  
