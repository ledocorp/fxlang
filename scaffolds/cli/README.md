# CLI scaffold

fx owns `tool_lib.run` → `Result<i32, core_Err>`.  
C owns argv / usage / exit codes via staged `fx_cli_host.h` (from `host/cli`).

```text
fx build tool_lib.fx -o out --emit-c --host host_cli.c --link-include .
./out/prog hello    # expect exit 42 (Ok payload)
```

`fx run` does not pass program argv - keep the thin C host.
