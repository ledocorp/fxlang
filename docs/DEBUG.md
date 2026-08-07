# Debug with `#line` + gdb (no DAP required)

**Last updated:** 7 August 2026

You can step and break on **`.fx` lines** using emit-C debug source — without an
integrated debugger product.

---

## Recipe (Windows / Linux)

1. **Check first** (layer 1):

```text
fx check path/to/main.fx
```

2. **Emit with debug source** (adds `#line` + `.fxmap`):

```text
fx emit-c path/to/main.fx -o out_dbg --debug-source
```

3. **Build with symbols** — easiest path:

```text
fx cc path/to/main.fx -o out_dbg --run
```

`fx cc` turns on debug-source internally so C toolchain messages and maps stay aligned.

4. **gdb** (when available):

```text
gdb --args out_dbg/<binary>
(gdb) break path/to/main.fx:12
(gdb) run
```

Function symbols remain C-shaped: `fx_<module>_<fn>` (e.g. `fx_main_main`).

5. **Map a C line back without gdb:**

```text
fx locate --c-file out_dbg/main.c --line 42
```

---

## Editor diagnostics vs CLI

| Path | Role |
|------|------|
| `fx check` | Authoritative CLI diagnostics (stderr bags, FX codes) |
| `fx lsp` | Same check engine on open/change/save — expect the **same FX codes** for common errors |

If the editor shows nothing, confirm `fx lsp` is wired ([EDITOR.md](EDITOR.md)) and that
`fx check` already reports the issue in a terminal.

---

## Related

- [TRACKING.md](TRACKING.md) — annotate / `.fxmap` / `#line` overview  
- [CLI.md](CLI.md) — `emit-c`, `cc`, `locate`  
- [EDITOR.md](EDITOR.md) — LSP + tree-sitter  
