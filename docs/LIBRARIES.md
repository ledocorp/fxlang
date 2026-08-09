# Libraries and C wraps

**Last updated:** 8 August 2026

fx’s interop story is the **C ABI**: bind or declare, wrap into fx-shaped APIs
(regions, effects, `Result`), then use from programs. There is **no package manager yet** —
structure code with path imports and `std/` / `lib/`.

Mechanics today: [WRAP.md](WRAP.md). Standard modules: [STD.md](STD.md).

---

## Already proven

| Surface | Role |
|---------|------|
| **cJSON** | Path-get facade + App 2 dogfood CLI |
| **xxHash** | Integrity helper wrap (`examples/wrap_xxhash`) |
| **SQLite** | Amalgamation WRAP foothold (`examples/wrap_sqlite` — `:memory:` dual-path) |
| **llhttp** | HTTP parse WRAP foothold (`examples/wrap_llhttp` — Content-Length dual-path) |
| **stb_sprintf** / **stb_image** | Format and image decode wraps |
| **raylib-class hosts** | GUI / panel examples (host owns `main`) |
| **QOI / httparse subsets** | Earlier language-floor ports |

“Bind exists” is not the same as “stdlib done.” Pure-fx App 4 shows JSON without a C library for semantics.

---

## Near-term (dogfood)

| Priority | Library / area | Why |
|----------|----------------|-----|
| 1 | **cJSON deepen** | **Landed** — path API + wrap + App 2 |
| 2 | **xxHash** | **Landed** — dual-path smoke for integrity helpers |
| 3 | **SQLite / llhttp footholds** | **Landed** — amalgamation + parse-only WRAP demos |
| 4 | **Paths + richer file I/O** | `io.read_file` / `write_file`; ROM load |
| 5 | **CLI args / exit codes** | Thin C hosts + `fx new --scaffold cli` |

---

## Soon

| Library | Why |
|---------|-----|
| **BLAKE3** | Alternate integrity if manifests demand |
| **stb** pieces as needed | e.g. image write — not the whole stb tree |

---

## Mid-term (when an app demands them)

| Library | Why wait |
|---------|----------|
| **lz4**, then **zstd** | Compression CLIs; lz4 first (simpler) |
| **SQLite deepen** | File-path DBs + FsCap; foothold already `:memory:` |
| **llhttp dial / TLS** | Parse foothold landed; dial under NetCap when an app demands |

---

## Backlog (powerful, wrong as the next spine)

| Item | Notes |
|------|--------|
| **Package manager / registry** | After multi-module dogfood proves modules |
| **fff** ([file-search SDK](https://github.com/dmtrKovalenko/fff)) | Flagship embed later — not foundation |
| **tree-sitter as a general app dependency** | fx already has a grammar for *fx*; parsing arbitrary languages is a separate product |
| **Full stb kitchen sink** | Add headers only when an app needs a specific one |
| **Huge frameworks / full TLS stacks** | Host demos OK; not “fx std” |

---

## Honesty for wraps

- Effects and ownership stay explicit in the fx facade  
- Prefer `Result` over errno soup at the fx boundary  
- Dual emission and dual native paths must remain auditable  
- Do not grow Minimal Core just to avoid wrapping  

---

## Related

- [NEXT.md](NEXT.md)  
- [DOGFOOD.md](DOGFOOD.md)  
- [WRAP.md](WRAP.md)  
- [STD.md](STD.md)  
