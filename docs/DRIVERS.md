# How fx compiles your program (one screen)

**Last updated:** 9 September 2026 · Package **0.9.73**

Short map of the usual compile modes. Full flags: [CLI.md](CLI.md).

---

## Default: `fx run` / `fx build`

```text
your.fx
   →  bin/fx  (you need gcc to link)
        →  preferred path when your program fits
        →  otherwise the built-in engine in the same binary
             →  native code when QBE is in the package
             →  or --emit-c → readable C → native
```

| Term | Meaning |
|------|---------|
| **Auto** (default) | Prefer the main path; fall back to the built-in engine when needed |
| **Built-in engine** | Always inside `bin/fx` — no second install |
| **`--emit-c`** | Emit readable C, then compile with your C toolchain |
| **IR / QBE** | Native path when `third_party/qbe/…` is present |

**Windows:** uses `third_party/qbe/windows/qbe.exe` when that file is in the package. If it is missing, use `--emit-c`.  
**Linux:** uses `third_party/qbe/obj/qbe`.

Readable C stays a first-class option on both platforms.

---

## `--driver` (advanced)

| Value | Behavior |
|-------|----------|
| **`auto`** (default) | Preferred path first; built-in engine if needed |
| **`foundry`** | Built-in engine only |
| **`sh`** | Preferred path only — no fallback (small supported set) |

**`--driver sh` does not support `--cli` / `--host`.** Use Auto or `--driver foundry` for those.

Also useful: `--backend auto|ir|c` and `--emit-c`. See [CLI.md](CLI.md).

---

## Quick recipes

```text
fx run main.fx                 # Auto
fx run main.fx --emit-c        # readable C
fx run main.fx --driver foundry
fx emit-c main.fx -o out_c     # C only, no link
```

CLIs with arguments: `fx new mytool --scaffold cli` then `fx build … --cli` — not `fx run … -- args`.

---

## Related

[CLI.md](CLI.md) · [START_HERE.md](START_HERE.md) · [WEEKEND.md](WEEKEND.md) · [SURFACE.md](SURFACE.md) · [NEXT.md](NEXT.md)
