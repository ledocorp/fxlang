# Tally tool (week-two)

`Map<string, i32>` tallies, dense iterate to a total, print a short StrBuilder report.

```text
fx run examples/tool_tally/main.fx
# exit 42  (linked binary prints tally=42)

fx run examples/tool_tally/fail_total.fx
# exit 1 (wrong total)
```

Regression: `.\scripts\test-week2-tools.ps1`
