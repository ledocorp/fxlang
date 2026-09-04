# CLI scaffold

fx owns `cli_main` / `run` → `Result<i32, core_Err>`.  
Shared host spine owns argv (`fx build … --cli`).  
No author-written `host_cli.c`.

**Exit contract:** `Ok(n)` → process exit `n`; `Err(_)` → nonzero. Scaffold demo: `./out/prog hello` → **42**.

```text
fx new mytool --scaffold cli    # alias: --scaffold tool
cd mytool
fx build tool_lib.fx -o out --emit-c --cli
./out/prog hello                # exit 42
./out/prog                      # missing argv → nonzero
```

`fx run` still does not forward program argv by itself - use `--cli` (or `--host` for WRAP/GUI).
