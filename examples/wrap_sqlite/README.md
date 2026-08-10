# wrap_sqlite

WRAP of the **SQLite amalgamation** (`third_party/sqlite3.{c,h}`) behind a thin fx facade.

| Path | Role |
|------|------|
| `sqlite_ref.c` | Opaque `sqlite3*` table; i32 handles; FsCap file open |
| `sqlite_safe.fx` | `Result` open/exec/query/close (+ `open_file_cap`) |
| `main.fx` | `:memory:` dual-path → exit **42** |
| `file_cap.fx` | File DB under FsCap (allow + deny) → exit **42** |
| `host.c` | argv host: memory + FsCap file smoke |
| `fixtures/` | Allowlisted directory for file DB |

```text
fx run examples/wrap_sqlite/main.fx --link examples/wrap_sqlite/sqlite_ref.c \
  --link examples/wrap_sqlite/third_party/sqlite3.c \
  --link host/cap/fx_cap_runtime.c \
  --link-include examples/wrap_sqlite/third_party --link-include host/cap

# file_cap: build, then run with cwd = examples/wrap_sqlite (fixture-relative paths)
fx build examples/wrap_sqlite/file_cap.fx -o out/file_cap --emit-c --link …
```

Not Minimal Core. Dial/TLS are separate. Prefer `open_file_cap` for sandboxed guests;
`open_path` remains for process-trust tools. Gate: `scripts/test-wrap-sqlite.ps1`.
