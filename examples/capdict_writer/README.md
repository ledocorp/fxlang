# capdict_writer

Cap dictionary demo: mint a visible C vtable-style table and invoke through it.

```text
fx run examples/capdict_writer/main.fx --emit-c
fx run examples/capdict_writer/main.fx --backend ir
# expect exit 42
```

Native IR works when QBE is staged.
