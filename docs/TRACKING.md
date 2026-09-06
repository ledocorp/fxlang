# Dual-emit tracking (fx ↔ C)

**Package:** 0.9.71 
**Site:** https://www.ledocorp.org/fx/docs/tracking/

fx promises **readable C** and a way to map failures back to `.fx` sources.

---

## Three error layers

| Layer | When | Tool |
|-------|------|------|
| **1 — fx** | Parse / typecheck / borrows | `fx check` → `.fx:line:col` |
| **2 — C / link** | After emit | `fx cc` remaps gcc/clang via `.fxmap` |
| **3 — Runtime** | Running binary | asserts / gdb (use `#line` + `-g`) |

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

## Tips

- Keep annotate mode on when reading emitted C with an agent. 
- Use `--debug-source` when chasing a gcc error or stepping in a debugger. 
- Layer 1 (`fx check`) before layer 2 — most mistakes never need C.

## Related

- [DEBUG.md](DEBUG.md) — step-by-step `#line` + gdb 
- [CLI.md](CLI.md) · [WRAP.md](WRAP.md) · [LANGUAGE.md](LANGUAGE.md)
