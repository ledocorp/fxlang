# Libraries and C wraps

**Last updated:** 2 September 2026

fx’s interop story is the **C ABI**: bind or declare, wrap into fx-shaped APIs
(regions, effects, `Result`), then use from programs.

**Modules today:** path imports + `std/` / `lib/`. **Pin today:** `fx.mod` + `fx mod vendor` /
`verify` + `fx.sum` (checksum pin for `std` — compile still uses `std/` / `FX_STD_ROOT`,
not `vendor/` yet). **Not yet:** download registry or third-party `require`. See [CLI.md](CLI.md).

Mechanics today: [WRAP.md](WRAP.md). Standard modules: [STD.md](STD.md) · [SURFACE.md](SURFACE.md).

---

## Already proven (language package)

| Surface | Role |
|---------|------|
| **cJSON** | Path-get facade + dogfood JSON CLIs |
| **xxHash** | Integrity helper wrap (`examples/wrap_xxhash` in monorepo) |
| **SQLite** | Amalgamation WRAP (`examples/wrap_sqlite` — `:memory:` + file under `FsCap`) |
| **llhttp** | HTTP parse WRAP foothold (`examples/wrap_llhttp`) |
| **BLAKE3** | Integrity wrap (`examples/wrap_blake3` in monorepo) + **fxblake3** tool |
| **LZ4** | Frame wrap (`examples/wrap_lz4` in monorepo) + **fxlz4** tool |
| **stb_sprintf** / **stb_image** | Format and image decode wraps |
| **raylib-class hosts** | GUI / panel examples (host owns `main`) |

“Bind exists” is not the same as “stdlib done.” Pure-fx JSON validate path also exists without a C library for semantics.

---

## Separate product CLIs (not this language package)

These ship from the monorepo `tools/` tree into their own GitHub packages. They are **not**
inside `bin/fx` of the language package, but they are first-class fx offerings:

| Tool | Role |
|------|------|
| **fxrun** | Task runner (`fxrun.toml`) |
| **fxql** | SQLite one-shot query CLI + FsCap |
| **fxfetch** | HTTPS GET under NetCap (links **Mbed TLS**) |
| **fxpipe** | Parallel BLAKE3 under FsCap / nursery |
| **fxlz4** | LZ4 pack/unpack + FsCap |
| **fxblake3** | BLAKE3 hash + FsCap |
| **fxguest** | Guest/cap speech CLI (allow/deny/budget) |

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
