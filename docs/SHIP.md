# Ship a small tool with fx

**Last updated:** 2 November 2026 · Package **0.9.75**

How to go from hello to a **reproducible** CLI others can build. This is the
consumer packaging story — not a registry tutorial.

---

## 1. Decide the host shape

| Kind | Habit |
|------|--------|
| Library / pure logic | `fx run` / `fx build` — no argv |
| Product CLI | `fx new mytool --scaffold cli` then `fx build … --cli` |
| GUI / custom argv | Thin C `main` + `--host` / `--link` ([WRAP.md](WRAP.md)) |

`fx run` does **not** forward program arguments into fx `main` (frozen).

---

## 2. Pin the language package

```text
fx new mytool --scaffold cli
cd mytool
# fx new writes fx.mod — keep it
fx mod verify          # when you use checksum pins
```

Compile resolves `import std/…` from nearby `std/` / `FX_STD_ROOT`.
**Pin-only** is the v1 promise; vendor-first compile is a later pull.
See [CLI.md](CLI.md).

---

## 3. Dual-path check (before you claim “done”)

On the same program:

```text
fx run main.fx --emit-c
# note exit code (tools often use 42 for smoke success)

fx run main.fx
# when QBE is present (Linux package ships it; Windows when qbe.exe staged)
# exit should match emit-C for dual-path programs
```

Or from a checked-out language package:

```text
# Windows
.\scripts\verify-pack.ps1

# Linux / WSL
./scripts/verify-pack.sh
```

Details: [QUALITY.md](QUALITY.md) · [DRIVERS.md](DRIVERS.md).

---

## 4. Prefer emit-C when shipping hot paths

For numeric loops, host-heavy structs, or code reviewers will read:

```text
fx build main.fx --emit-c -o dist/
```

Keep annotate comments on unless you need `--minimal`. Map failures with
`fx locate` ([TRACKING.md](TRACKING.md) · [C_SHAPE.md](C_SHAPE.md)).

---

## 5. License honesty

This package is **GPL-3.0**. There is **no** emit-C → MIT linking exception today
([LICENSES.md](LICENSES.md)). Plan your combined work accordingly.

---

## 6. Platforms

| Prebuilt `bin/fx` | Status |
|-------------------|--------|
| Windows x86_64 | Yes |
| Linux x86_64 | Yes |
| macOS | Not shipped |
| linux-aarch64 | Emit-C **recipe** via `fx target` — not a zip prebuilt |

---

## Related

[START_HERE.md](START_HERE.md) · [WEEKEND.md](WEEKEND.md) · [WRAP.md](WRAP.md) · [PATTERNS.md](PATTERNS.md) · [GAPS.md](GAPS.md)
