# Libraries and C wraps

**Last updated:** 5 August 2026

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
| 3 | **Paths + richer file I/O** | `io.read_file` / `write_file`; ROM load |
| 4 | **CLI args / exit codes** | Thin C hosts for App 2 / App 4 |

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
| **SQLite** | Persistence dogfood — larger surface, schedule deliberately |
| **llhttp** + minimal I/O | Networked tools only after JSON/fs comfort |

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
