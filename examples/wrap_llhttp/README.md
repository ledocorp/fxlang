# wrap_llhttp

WRAP of **llhttp** (Node.js HTTP parser, MIT) - **parse-only** foothold.

| Path | Role |
|------|------|
| `third_party/` | Vendored `llhttp.c` + `api.c` + `http.c` + `llhttp.h` |
| `llhttp_ref.c` | Content-Length / ok shim |
| `llhttp_safe.fx` | `Result` facade |
| `main.fx` | Dual-path → exit **42** |
| `host.c` | NetCap allowlist + parse (no dial) via `host/cap` + `host/cli` |

```text
fx run examples/wrap_llhttp/main.fx
fx run examples/wrap_llhttp/main.fx --emit-c
```

Not Minimal Core. Dial/TLS later under NetCap when an app demands.
