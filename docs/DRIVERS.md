# How fx compiles your program (one screen)

**Last updated:** 10 September 2026 · Package **0.9.74**

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

### Speed policy (honest)

| Kind of program | Supported habit |
|-----------------|-----------------|
| Tools / ordinary logic | **Auto** (IR when present) is fine |
| Tight numeric loops, draw/GPU, host-heavy structs | Prefer **`--emit-c`** — that is the **supported fast path** |
| QBE / IR | Correctness and dual-path proof — **not** “faster than gcc/clang on hot loops” |

Do not chase an LLVM personality transplant before collections / bind deepen. Dual-path still matters: same program should mean the same thing on emit-C and IR when both run ([QUALITY.md](QUALITY.md)).

**Equivalence gate:** IR exit must match emit-C on the standing dual-path corpus (see [QUALITY.md](QUALITY.md)). Release blockers when a claimed dual-path program disagrees on exit code.

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

[CLI.md](CLI.md) · [START_HERE.md](START_HERE.md) · [WEEKEND.md](WEEKEND.md) · [SURFACE.md](SURFACE.md) · [NEXT.md](NEXT.md) · [GAPS.md](GAPS.md)
