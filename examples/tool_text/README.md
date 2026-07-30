# Text path tool (M3a)

One taught path: **StrBuilder → string → file → `byte_at` → Buf**.

```text
fx run examples/tool_text/main.fx
# exit 42

fx run examples/tool_text/fail_len.fx    # 1
fx run examples/tool_text/fail_write.fx  # 2
```

Regression: `.\scripts\test-week2-tools.ps1` (uses packaged `public/bin/fx` when present).

See [TEXT_PATH_LITE.md](../../docs/specs/TEXT_PATH_LITE.md).
