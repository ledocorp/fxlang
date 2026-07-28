# Compiler source (read-only / inspectable)

**Status:** Educational snapshot for humans who want to *read* how fx’s frontend is expressed in fx.  
**Not** the supported way to run or rebuild the compiler.

## How to use fx

Use the prebuilt binary in [`../bin/`](../bin/):

```text
fx doctor
fx version
fx new hello
fx run hello/main.fx
```

This folder does **not** replace `bin/fx`.

## What this is

Copies of the **fx-authored compiler modules** (lexer, parse, AST, diagnostics, emit). They show the self-host direction: important compiler logic lives as ordinary `.fx` you can open in an editor.

| Path | Role |
|------|------|
| [`lib/sh_lexer.fx`](lib/sh_lexer.fx) | Lexer |
| [`lib/sh_parse.fx`](lib/sh_parse.fx) | Parser |
| [`lib/sh_ast.fx`](lib/sh_ast.fx) | AST types |
| [`lib/sh_diag.fx`](lib/sh_diag.fx) | Diagnostics |
| [`lib/sh_emit.fx`](lib/sh_emit.fx) | Emit / lowering helpers |

File headers in these copies are cleaned for reading. Some body comments and string literals still mention historical gate markers; those are part of the source as authored, not a public roadmap.

## What this is not

- A turnkey “build fx from source” SDK  
- The private test harness, goldens, or CI  
- A promise that every line here is the only code the shipping binary contains  

## Why ship it

So curious readers can inspect the compiler’s fx surface without needing the private build factory, while everyone else simply runs the binary.
