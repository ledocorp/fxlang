# Weekend path — hello → CLI → fxserve

**Last updated:** 9 September 2026  
**Needs:** fx language package **0.9.73+** · optional **fxserve v0.1.0+**  
**Goal:** One short path using only public releases.

---

## 1. Install fx

Needs: **Windows or Linux x86_64** · **gcc** on `PATH`.

1. Get the package from [ledocorp/fxlang releases](https://github.com/ledocorp/fxlang/releases) (or clone the public repo).
2. Put `bin/` on your `PATH` (or run `bin/fx` / `bin/fx.exe` directly).

```text
fx doctor
fx version    # expect v0.9.73
```

If doctor asks for a C compiler, install gcc (or another C toolchain) and retry. → [START_HERE.md](START_HERE.md)

---

## 2. Five-minute hello

```text
fx new hello
cd hello
fx run main.fx          # expect exit 42
fx run main.fx --emit-c # optional: emit readable C
```

More on compile modes: [DRIVERS.md](DRIVERS.md).

---

## 3. Small CLI with arguments

`fx run` does **not** pass program arguments into your fx `main`. Use the CLI starter + `--cli`:

```text
cd ..
fx new myecho --scaffold cli
cd myecho
fx build tool_lib.fx --cli -o out
# Windows:
.\out\tool_lib.exe --help
# Linux:
./out/tool_lib --help
```

Edit `tool_lib.fx` for your tool. Details: [SCAFFOLDS.md](SCAFFOLDS.md) · [CLI.md](CLI.md).

**Package pin:** `fx new` also writes `fx.mod`. You can run `fx mod vendor` and `fx mod verify` to checksum a copy of `std`. Compiling still uses the `std/` next to your project (or `FX_STD_ROOT`). See [CLI.md](CLI.md).

---

## 4. Optional: local static site (fxserve)

**fxserve** is a separate download — not inside `bin/fx`.

1. Get Win or Linux assets from [ledocorp/fxserve releases](https://github.com/ledocorp/fxserve/releases) (**v0.1.0+**).
2. Point it at a site folder:

```text
# from the fxlang package:
fx new mysite --scaffold web
# Install fxserve from its release, then (see its README):
#   fxserve --root mysite/site
# Open http://127.0.0.1:<port>/  → expect HTTP 200
```

Other tools (fxql, fxrun, …): [LIBRARIES.md](LIBRARIES.md) · https://www.ledocorp.org/fx/tools/

---

## Success checklist

- [ ] `fx doctor` exits 0  
- [ ] Hello `fx run` exits **42**  
- [ ] CLI build with `--cli` runs  
- [ ] (Optional) fxserve serves a page with HTTP **200**

---

## Related

[START_HERE.md](START_HERE.md) · [DRIVERS.md](DRIVERS.md) · [CLI.md](CLI.md) · [SCAFFOLDS.md](SCAFFOLDS.md) · [LIBRARIES.md](LIBRARIES.md) · [NEXT.md](NEXT.md)
