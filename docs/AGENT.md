# Agent loop — check, run, emit-C, locate

**Last updated:** 8 August 2026

fx treats **agents (LLMs) as first-class consumers** of the same contracts humans use:
diagnostics with spans, path imports, readable emitted C, and a lean MCP server.
Humans remain reviewers and adopters. This is not a mega-IDE product.

---

## Path chooser (before coding)

```text
1. Path?   pure fx | --cli | --host + native lib (--use) | guest
2. Syntax? SURFACE — fx ≠ C (struct fields use `,` not `;`; no C compound literals; Result needs `?`)
3. APIs?   STD / SURFACE only — never invent names (e.g. no string.concat unless listed)
4. Link?   --use <dir> with dir/link.args — never invent winmm/gdi32 lists
5. Backend? host+GUI → --emit-c until IR host/struct parity is documented
```

Put package `bin/` on PATH (`fx doctor`). See [WRAP.md](WRAP.md) · [SURFACE.md](SURFACE.md) · [STD.md](STD.md).

---

## Day-one loop (terminal)

```text
fx doctor
fx check path/to/main.fx
fx run path/to/main.fx
fx run path/to/main.fx --emit-c
fx emit-c path/to/main.fx -o out_dbg --debug-source
fx locate --c-file out_dbg/main.c --line 40
```

| Step | Why |
|------|-----|
| `check` | Stable error codes + spans before edit thrash |
| `run` | Default IR → native when QBE is discoverable; Windows prefers `qbe.exe` when staged, else emit-C fallback ([CLI.md](CLI.md)) |
| `emit-c` | Readable C audit trail (`/* fx: … */` traces) |
| `locate` | Map a **C** line back to fx via `.fxmap` ([TRACKING.md](TRACKING.md)) |

Go-to-definition on **fx** sources uses `fx lsp` in the editor — [EDITOR.md](EDITOR.md).

---

## Lean MCP

```text
fx mcp
```

Exposes a small tool set (`fx_check`, `fx_locate`, `fx_run`, emit helpers, …). Keep it lean —
add tools only when a concrete agent workflow fails. See [CLI.md](CLI.md).

---

## Editor + tree-sitter

- Wire `fx lsp` for diagnostics, go-to-definition, and find-references — [EDITOR.md](EDITOR.md).  
- Syntax highlighting via the in-repo tree-sitter grammar (see EDITOR.md install notes).  
- Debug with `#line` + gdb — [DEBUG.md](DEBUG.md). No DAP required.

---

## Composition habits agents should copy

- Parallel `Vec`s + typed ids (SoA), not nested growable structs — [COMPOSITION.md](COMPOSITION.md).  
- Host mints file authority when it matters: either pass **bytes** only (`examples/cap_host_smoke/`) or pass **`FsCap` / `OutCap`** and use `std/io_cap` (`examples/cap_regions_*`). Deny outside the root is exit **5**.  
- Keep types and effects visible on purpose.

---

## Related

- [CLI.md](CLI.md) · [TRACKING.md](TRACKING.md) · [NEXT.md](NEXT.md) · [DOGFOOD.md](DOGFOOD.md)
