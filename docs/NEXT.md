# What’s next for fx

**Last updated:** 12 August 2026

fx **0.9.66** is the current public package: Path C living dogfood (no-grow `v[i]=x`),
`--cli` auto-host, and dialect polish on top of the **0.9.6** honesty freeze
(argv · platforms · vendor pin) and the **0.9.5** production surface.

**Product focus:** sharp rules + short paths + real tools — not Soft-fx,
not a package registry first, not a heavy debugger as the bar for “tooling.”

**0.9.66** is not **v1.0**.

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

**Shipped CLIs** (separate repos — Win + Linux bins):

| Tool | Role |
|------|------|
| [fxrun](https://github.com/ledocorp/fxrun) | Task / command runner |
| [fxql](https://github.com/ledocorp/fxql) | SQLite one-shot under `--allow` |
| [fxlz4](https://github.com/ledocorp/fxlz4) | LZ4 frame pack / unpack |
| [fxblake3](https://github.com/ledocorp/fxblake3) | BLAKE3 file / tree hash |
| [fxfetch](https://github.com/ledocorp/fxfetch) | HTTPS GET under NetCap |
| [fxpipe](https://github.com/ledocorp/fxpipe) | Parallel BLAKE3 under FsCap |
| [fxguest](https://github.com/ledocorp/fxguest) | Caps / guest speech demo |

Docs: [ledocorp.org/fx/tools](https://www.ledocorp.org/fx/tools/).

Landed dogfood (Apps 1–5): [DOGFOOD.md](DOGFOOD.md).  
Wrap when an app demands: [LIBRARIES.md](LIBRARIES.md).

### When the app is done — pin std

```text
# in the project root (write fx.mod if scaffolds did not)
fx mod tidy
fx mod vendor      # vendor/std + fx.sum
fx mod verify      # release / CI gate
```

**Honest today:** vendor/`fx.sum` = checksum pin. Compile still resolves `import std/…` via nearby `std/` or `FX_STD_ROOT` — not via `vendor/` yet. Details: [CLI.md](CLI.md) (`fx mod` section).

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
- [releases/0.9.66.md](releases/0.9.66.md) — latest release notes  
