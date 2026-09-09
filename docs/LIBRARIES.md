# Libraries and C wraps

**Last updated:** 9 September 2026

fx’s interop story is the **C ABI**: bind or declare, wrap into fx-shaped APIs
(regions, effects, `Result`), then use from programs.

**Modules today:** path imports + `std/` / `lib/`. **Pin today:** `fx.mod` + `fx mod vendor` /
`verify` + `fx.sum` (checksum pin for `std` — compile still uses `std/` / `FX_STD_ROOT`,
not `vendor/` yet). **Not yet:** download registry or third-party `require`. See [CLI.md](CLI.md).

**Install tools from GitHub Releases** (Win + Linux x86_64). Index:
https://www.ledocorp.org/fx/tools/ · weekend path: [WEEKEND.md](WEEKEND.md).

Mechanics today: [WRAP.md](WRAP.md). Standard modules: [STD.md](STD.md) · [SURFACE.md](SURFACE.md).

---

## Already proven (language package)

| Surface | Role |
|---------|------|
| **cJSON** / **xxHash** / **stb_*** | Wraps proven in-tree; deep demos stay with wraps/tools (not all staged as examples) |
| **SQLite** | Amalgamation WRAP + **fxql** tool (CLI samples in the tool pack) |
| **llhttp** | HTTP parse WRAP foothold (`std/http`); serve via **[fxserve](https://github.com/ledocorp/fxserve)** |
| **BLAKE3** | Integrity wrap + **fxblake3** tool |
| **LZ4** | Frame wrap + **fxlz4** tool |
| **raylib-class hosts** | GUI hosts (companion packs — not in this language zip) |

“Bind exists” is not the same as “stdlib done.” Pure-fx JSON validate path also exists without a C library for semantics.

---

## Separate product CLIs (not this language package)

These ship as their own GitHub packages (**GPL-3.0**). They are **not** inside
`bin/fx` of the language package. Prefer **0.9.73+** language floor.

| Tool | Role | Releases |
|------|------|----------|
| **fxrun** | Task runner (`fxrun.toml`) | [ledocorp/fxrun](https://github.com/ledocorp/fxrun/releases) |
| **fxql** | SQLite one-shot query CLI + FsCap | [ledocorp/fxql](https://github.com/ledocorp/fxql/releases) |
| **fxfetch** | HTTPS GET under NetCap (links **Mbed TLS**) | [ledocorp/fxfetch](https://github.com/ledocorp/fxfetch/releases) |
| **fxpipe** | Parallel BLAKE3 under FsCap / nursery | [ledocorp/fxpipe](https://github.com/ledocorp/fxpipe/releases) |
| **fxlz4** | LZ4 pack/unpack + FsCap | [ledocorp/fxlz4](https://github.com/ledocorp/fxlz4/releases) |
| **fxblake3** | BLAKE3 hash + FsCap | [ledocorp/fxblake3](https://github.com/ledocorp/fxblake3/releases) |
| **fxguest** | Guest/cap speech CLI (allow/deny/budget) | [ledocorp/fxguest](https://github.com/ledocorp/fxguest/releases) |
| **fxserve** | Local static HTTP(S) | [ledocorp/fxserve](https://github.com/ledocorp/fxserve/releases) **v0.1.0+** |

Language-package `std/net.dial_tls` still **fails** without those extra link units — TCP dial is in-package; HTTPS is **fxfetch**.

---

## Near-term (dogfood)

| Priority | Library / area | Why |
|----------|----------------|-----|
| 1 | Paths + richer file I/O | `std/path` / `fs` / `fs_walk` already landed — deepen when apps pull |
| 2 | CLI args / exit codes | `--cli` + `host/cli` + `fx new --scaffold cli` |
| 3 | Wrap deepen | Pooling / WAL / dial-only when an app demands |

---

## Mid-term (when an app demands them)

| Library | Why wait |
|---------|----------|
| **zstd** | Compression after lz4 |
| **SQLite deepen** | Pooling / WAL / multi-connection — file+`FsCap` already landed |
| **llhttp dial** | Parse foothold landed; dial under NetCap when an app demands |

---

## Related

[WRAP.md](WRAP.md) · [STD.md](STD.md) · [SURFACE.md](SURFACE.md) · [DOGFOOD.md](DOGFOOD.md) · [CLI.md](CLI.md)
