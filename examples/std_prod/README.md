# std_prod -  fx suites

```powershell
.\scripts\test-prod-std.ps1
```

Host-free suites use `fx test --backend both`. JSON/SQLite smokes need WRAP `--link` (wired in the gate).
