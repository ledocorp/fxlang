# Gaps contract — what fx will not become

**Last updated:** 10 September 2026 · Package **0.9.73+**

This page is a **contract**, not a wishlist. It answers: what will **never** be
added to stay fx, and what **may** land in later **0.9.x / 1.x** when pulled —
without turning every improvement into a second language.

Everyday freezes and “what’s next” speech: [NEXT.md](NEXT.md).  
As-implemented surface: [SURFACE.md](SURFACE.md).  
Compile modes: [DRIVERS.md](DRIVERS.md).  
Failure policy: [TRAP.md](TRAP.md).

---

## Never (integrity)

These stay out of the dialect and the product story:

| Refuse | Why |
|--------|-----|
| Soft-fx / second memory physics | One ownership model; no lying mutation |
| Grow-on-`v[i]=x` (hidden realloc) | Grow stays `push` / reassign — visible |
| `unsafe { }` that disables loans in fx | Host C is the escape hatch; fx stays checked |
| Lifetime parameters / full NLL | Lexical loans + ids; not Rust-shaped |
| User-defined traits / closures / iterator towers | Facets (closed) may deepen; traits will not |
| Implicit GC / Cell-everywhere interior mut | Explicit regions and effects |
| Package **registry as prerequisite** to be “real” | Pins (`fx.mod` / `fx.sum`) first; registry later if ever |
| Drop readable emit-C or the dual-path habit | IR **adds**; emit-C stays |
| DAP mega-IDE as the bar for “tooling” | `fx lsp` + locate / `#line` is enough |
| In-language `async`/`await` as the concurrency story | Nursery + channels; see SURFACE |
| Porting a full widget tree / compositor to “prove” fx | Bind what you must; host owns the event loop |

---

## May add (1.x pull ladder — when steward pulls)

Improvements that stay **inside fx’s grain** (sharp rules, short paths, loud errors):

| Area | Direction |
|------|-----------|
| Effects + caps | Closed effect set **Complete** (1a–1c fx native): Cap on explicit fs/net · `fs_*` retag · `io` = fs\|net\|time\|proc · std ambient `io` |
| Loans | Reborrow (**1a**) · arm-end exclusive (**1b**) · `using { }` (**1c**) · disjoint const-index (**1d**) — **LOAN-REBORROW-1 Complete**; **not** NLL |
| Facets | Closed set + Plain Vec/Map footholds — **FACET-PLAIN-1 Complete** (IR Map-struct out-of-claim) |
| Collections | Generic `Vec` / `Map` under Plain / Hash+Eq (footholds Complete; deepen on pull) |
| C boundary | Typed `fx bind` opaque/own — **BIND-TYPED-1 Complete** (via 1a; Cap-gated deepen on pull; IR/live out-of-claim); `@repr(c)` Point — **REPR-C-1 Complete** |
| Concurrency | Finish nursery / chan / select; no second runtime |
| Backends | Dual-emit equivalence tests; emit-C as documented fast path |
| `std/wire` | Endian load/store foothold; deepen on pull |
| Targets | Linux aarch64 as **emit-C recipe** via `fx target` (**no** aarch64 prebuilt; IR/QBE aarch64 out-of-claim) |
| Module graph | Deeper `fx mod` / visibility — still no registry-first |

Non-goals for that ladder: algebraic effect handlers, user-defined effect kinds,
overlapping trait impls, LLVM chase before Map/Vec/bind are generic.

---

## Already honest (do not re-litigate)

| Topic | Contract today |
|-------|----------------|
| Program argv | `--cli` / thin C host / `--scaffold cli` — not `fx run … -- args` |
| Platforms | Prebuilt **Windows + Linux x86_64**; **linux-aarch64** = emit-C recipe (`fx target`), not zip |
| Pins | `fx.mod` / `fx.sum` pin-only; compile uses `std/` (not `vendor/` first) |
| TLS in language package | `dial_tls` fails here; HTTPS via **fxfetch** |
| Concurrency keywords | No lexer `nursery`/`spawn`/`await` — use `std/nursery` |
| Compiler rebuild | Use `bin/fx`; [`compiler-source/`](../compiler-source/) is **inspect-only** |
| License | GPL-3.0 package — linking opinion in [LICENSES.md](LICENSES.md) |

---

## Related

[NEXT.md](NEXT.md) · [SURFACE.md](SURFACE.md) · [TRAP.md](TRAP.md) · [DRIVERS.md](DRIVERS.md) · [LICENSES.md](LICENSES.md) · [WEEKEND.md](WEEKEND.md)
