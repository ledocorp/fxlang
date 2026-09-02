# Dogfood apps

**Last updated:** 2 September 2026

fx proves itself by porting **real, small open-source-shaped programs**
(under about two thousand lines of *our* logic), with upstream tests or goldens
where possible — not by inventing greenfield toys.

Apps 1–5 live under `examples/dogfood_*` in the **monorepo**. The staged public
package may ship a subset (Path C / tools / composition demos); if a folder is
missing from your checkout, use the monorepo or the matching GitHub release assets.
Composition method (SoA, pools, host-minted I/O): [COMPOSITION.md](COMPOSITION.md).
Agent day-one loop: [AGENT.md](AGENT.md).

---

## App 1 — CHIP‑8 headless interpreter

**Folder:** `examples/dogfood_chip8/`  
**Role:** Composition at scale — memory tables, registers, stack, opcode dispatch, slot updates.  
**Status:** Landed — embedded self-test exits 42 on both native paths.

**Product shape**

- Boot machine, load ROM bytes, `step` / `run`  
- Inspect registers and framebuffer sum  
- Keypad slots + `set_key` / `key_down` (shared with App 3)  
- **No** window or GUI here  
- State is one flat `Vec` (documented in-tree) so both run paths stay green  

**Oracle**

- Embedded self-test ROM (LD/ADD → 42, store/load round-trip, CLS, halt)  
- Scoped Timendus seed: self-test + draw-demo (`TIMENDUS.md`); full [Timendus suite](https://github.com/Timendus/chip8-test-suite) not vendored yet  

**What it proves**

- The fx composition method without mut sugar  
- Dual native paths (default run + `--emit-c`) on a non-toy core  

---

## App 2 — JSON path CLI (cJSON wrap)

**Folder:** `examples/dogfood_jsonget/`  
**Role:** Everyday systems tool — files, errors, JSON via a careful C wrap.  
**Status:** Landed — corpus on both paths + C host argv CLI.  
**Contrast:** App 4 is the same product shape in **pure fx** (no cJSON for semantics).

**Product shape**

- Path language: dotted keys and optional `[index]` (example: `users[0].name`)  
- Number path-get, string equality, stdout print (raw or JSON fragment)  
- Missing path fails cleanly  
- Checked-in fixture + cases (`fixtures/`)  
- Argv front-end via C host: `jsonget <file> <path> [--raw]` (`host_cli.c` + `jsonget_lib.fx`)  

**Oracle**

- Embedded/corpus self-test matching `fixtures/CASES.md`  
- Host CLI against `fixtures/sample.json` (stdout `Ada`, exit 0)  

**Non-goals for v1**

- Full `jq` filters, pipes, or assignment language  

**What it proves**

- cJSON as a usable fx-shaped facade (numbers + strings + print)  
- File I/O on both native paths + thin C argv host  

---

## App 3 — CHIP‑8 visual host

**Folder:** `examples/dogfood_chip8_ui/`  
**Role:** UI / host confidence — same machine as App 1, thin display and input.  
**Status:** Landed — draw-demo on both paths; playable interactive host.

**Product shape**

- Draw the 64×32 framebuffer (scaled in host)  
- Draw-demo ROM (font glyph 0 → 14 pixels) for smoke  
- Play-demo ROM: move glyph with keys **2/4/6/8** (WASD/arrows also mapped)  
- Automated smoke without a window (`main.fx`)  
- Interactive window via `--host host_raylib.c`  

**Host style**

- raylib-class C host  
- Host owns the window; fx owns the interpreter state  
- Interactive builds use the emit-C link path (Windows raylib)  

**What it proves**

- Link/host + live keypad loop without changing language honesty rules  

---

## App 4 — JSON path CLI (pure fx)

**Folder:** `examples/dogfood_fxjson/`  
**Role:** Same path/get product as App 2, with **all** parse/DOM/path logic in fx.  
**Status:** Landed — corpus, CLI exit contract, wild fixtures, `\uXXXX` escapes.

**Product shape**

- Parse → packed DOM → dotted / `[index]` path walk → print  
- Host only for argv/stdio: `fxjson <file> <path> [--raw]`  
- Exit: 0 ok · 1 usage · 2 IO · 3 parse · 4 path miss (stderr on 2–4)  
- Common string escapes including `\uXXXX`; invalid Unicode escapes fail closed  
- Wild fixtures under `fixtures/` for messier real-world JSON  

**Oracle**

- Differential checks against [tidwall/gjson](https://github.com/tidwall/gjson) on shared success paths  
- Dual-path corpus; App 2 identity on shared success paths  

**Non-goals for v1**

- Full jq, JSON5, streaming SAX-only API  

**What it proves**

- A real Go-shaped CLI without depending on a C library for semantics  
- Wrap (App 2) vs pure (App 4) both product-real  

---

## App 5 — text diff (line LCS)

**Folder:** `examples/dogfood_textdiff/`  
**Role:** Algorithms flagship after the JSON A/B story — pure-fx line diff.  
**Status:** Landed — line-split + LCS edit script CLI; dual-path.

**Product shape**

- `textdiff <file_a> <file_b>` (thin C host)  
- Exit 0 identical / 1 different / 2 IO / 3 usage  
- Full-file edit script with ` ` / `-` / `+` prefixes (no GNU hunk headers)  

**Oracle**

- Same line-LCS backtrack in `go_oracle/` (not GNU `diff`)  

**Not yet**

- Myers O(ND), GNU unified hunks, binary / huge-file mode  

---

## Shared rules

| Rule | Meaning |
|------|---------|
| Honesty | Effects, regions, and grow vs slot mut stay visible |
| Dual path | Claimed quality means default native path and `--emit-c` both work |
| Size | Keep *our* logic in the sub‑2k spirit; ROMs and fixtures don’t count against that |
| Comparison | Prefer upstream tests / goldens over invented oracles |
| Scope | Write a short “what matches / what’s out” note per app |

---

## Related

- [NEXT.md](NEXT.md) — overall sequence  
- [COMPOSITION.md](COMPOSITION.md) — fx method  
- [LIBRARIES.md](LIBRARIES.md) — wraps these apps need  
- [WRAP.md](WRAP.md) — C host mechanics  
- [releases/0.8.0.md](releases/0.8.0.md) — package highlights  
