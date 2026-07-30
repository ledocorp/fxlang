# File tool (week-two)

File lifecycle via `std/io`: write → exists → append → rename → delete.

```text
fx run examples/tool_files/main.fx
# exit 42  (fx run prints "ran: exit 42"; message is on the linked binary)

# Failure fixtures (expected exits):
fx run examples/tool_files/fail_write.fx    # 1
fx run examples/tool_files/fail_exists.fx   # 2
fx run examples/tool_files/fail_rename.fx   # 4
fx run examples/tool_files/fail_delete.fx   # 6
```

Regression: `.\scripts\test-week2-tools.ps1`

Note: content-verified `read_file` + `?` is proven in the monorepo (`programs/p2_file_io.fx`) via an fx-owned emit bridge. This package example stays on the general emit path so it runs from `examples/` with the public binary.
