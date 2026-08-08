# Editor setup — `fx lsp` + highlighting

**Last updated:** 7 August 2026

fx ships a **stdio language server** (`fx lsp`) for diagnostics, go-to-definition,
find-references, and hover. Pair it with any editor that can run an external LSP.
Syntax highlighting can use a tree-sitter grammar when you install one separately.

---

## Prerequisites

1. Put the package `bin/` on your `PATH` (or use the full path to `fx` / `fx.exe`).  
2. Confirm in a terminal: `fx version` (expect **v0.9.1**) and `fx check` on a `.fx` file.

---

## Cursor / VS Code (generic LSP)

Use a generic **LSP client** / “run language server” extension and point it at:

| Field | Value |
|-------|--------|
| Command | `fx` (or full path to `fx.exe`) |
| Args | `["lsp"]` |
| Language / selector | `*.fx` |
| Transport | **stdio** |

Minimal settings sketch:

```json
{
  "files.associations": {
    "*.fx": "plaintext"
  }
}
```

After reload, open a `.fx` file and wait for the server to start (Output / LSP log
if something fails).

---

## What `fx lsp` does today

| Action | Expectation |
|--------|-------------|
| Open / edit / save `.fx` | Diagnostics from `fx check` (Problems panel) — **same FX codes** as the CLI |
| Go to Definition (F12) | Jump to local defs, imports, and (with `.fxmap`) C↔fx |
| Find All References (Shift+F12) | Definition + uses, including **other modules** that import the symbol |
| Hover | Inferred type at the cursor when known |
| Completion / signature help | Basic identifiers and call-site help |

Runtime / C stepping: see [DEBUG.md](DEBUG.md) (`#line` + gdb) — no DAP product required.

**Not claimed:** safe rename-across-project, or a full IDE debugger product.

---

## Tree-sitter (optional highlighting)

Semantic checking comes from **`fx lsp` / `fx check`**. For highlighting/folds,
use a community or self-built [tree-sitter](https://tree-sitter.github.io/tree-sitter/)
grammar pointed at `*.fx` files. The language package does **not** require tree-sitter
to edit or run programs.

Good first file: `fx new hello` → open `hello/main.fx`, or
`examples/dogfood_fxjson/main.fx` from the package.

---

## Good first files

- Scaffold: `fx new hello` → open `hello/main.fx`  
- Multi-file dogfood: `examples/dogfood_fxjson/main.fx` — F12 on imports

CLI check without the editor:

```text
fx check examples/dogfood_fxjson/main.fx
```

---

## Related

- [AGENT.md](AGENT.md) — check / run / emit-c / locate / MCP  
- [TRACKING.md](TRACKING.md) — annotate / `.fxmap` / `#line` overview  
- [DEBUG.md](DEBUG.md) — `#line` + gdb recipe  
- [CLI.md](CLI.md) — full command surface  
- [COMPOSITION.md](COMPOSITION.md) — how to structure programs  
- [NEXT.md](NEXT.md) — what’s next  
