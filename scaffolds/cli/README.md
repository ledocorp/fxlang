# CLI scaffold

fx owns `cli_main` / `run` → `Result<i32, core_Err>`.  
Shared host spine owns argv (`fx build … --cli` - **FX-CLI-AUTOHOST-1**).  
No author-written `host_cli.c`.

```text
fx build tool_lib.fx -o out --emit-c --cli
./out/prog hello    # expect exit 42 (Ok payload)
```

`fx run` still does not forward program argv by itself - use `--cli` (or `--host` for WRAP/GUI).
