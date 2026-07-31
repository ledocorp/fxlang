# Dual-emit tracking (fx ↔ C)

**Package:** 0.7.4 · **Pack:** FX-0.7.4  
**Deep guide (monorepo):** `docs/DEBUGGING_EMITTED_C.md` · design: `docs/specs/EMIT_SOURCE_MAP.md`  
**Site:** https://www.ledocorp.org/fx/docs/tracking/

fx promises **readable C** and a way to map failures back to `.fx` sources.

---

## Three error layers

| Layer | When | Tool |
|-------|------|------|
| **1 — fx** | Parse / typecheck / borrows | `fx check` → `.fx:line:col` |
| **2 — C / link** | After emit | `fx cc` remaps gcc/clang via `.fxmap` |
| **3 — Runtime** | Running binary | ASan / asserts / gdb (use `#line` + `-g`) |

Always prefer layer 1 first.

---

## Emit modes

| Mode | How | What you get |
|------|-----|----------------|
| **Annotate** (default) | `fx emit-c` / `fx run` | `.c` with `/* fx: … */` comments for humans and agents |
| **Debug source** | `--debug-source` | `.fxmap` sidecar + `#line` directives |
| **Minimal** | `--minimal` | Smallest C; no annotate comments or map |

```text
fx emit-c main.fx -o out_c --debug-source
fx locate --c-file out_c/main.c --line 42
```

`fx cc` emits with debug-source internally so C diagnostics can remap to fx.

---

## What maps to what

| Artifact | Role |
|----------|------|
| `/* fx: let x = …; */` | Human/LLM cross-walk in default emit |
| `main.fxmap` | Machine map: C line/col ↔ fx span + kind |
| `#line N "file.fx"` | Debugger / compiler location (debug emit) |

Granularity is per **statement / significant fragment**, not every physical C line.

---

## Agent notes

- Inspect C with `fx emit-c` when auditing lowering.
- Use `fx locate` or MCP `fx_locate` when you have a C line from a toolchain error.
- Do not invent DWARF fx variable names — not in this package story.
- Composition method: [COMPOSITION.md](COMPOSITION.md).

---

## Related CLI

→ [CLI.md](CLI.md) (`emit-c`, `cc`, `locate`, `mcp`)
