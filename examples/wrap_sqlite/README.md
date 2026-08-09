# wrap_sqlite

WRAP of the **SQLite amalgamation** (`third_party/sqlite3.{c,h}`) behind a thin fx facade.

| Path | Role |
|------|------|
| `sqlite_ref.c` | Opaque `sqlite3*` table; i32 handles |
| `sqlite_safe.fx` | `Result` open/exec/query/close |
| `main.fx` | Dual-path smoke → exit **42** |
| `host.c` | Optional argv-shaped host via `host/cli` |

```text
fx run examples/wrap_sqlite/main.fx
fx run examples/wrap_sqlite/main.fx --emit-c
```

Not Minimal Core. No NetCap required (`:memory:`). File-path + FsCap later when an app demands.
