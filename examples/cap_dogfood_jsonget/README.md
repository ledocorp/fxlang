# cap_dogfood_jsonget

App 2 (JSON path) as a **guest under FsCap** - teachable sandbox on a real dogfood slice.

## Truth

- Guest reads only via `io_cap` + host-minted `FsCap` (no ambient `std/io`)
- Path extract uses the same `cjson_safe` facade as `dogfood_jsonget`
- Session: begin → mint → run(sample) → escape deny → end → stale deny; two sessions
- Process-trust CLI (`dogfood_jsonget`) stays ambient for non-sandbox hosts

## Run

```text
fx build examples/cap_dogfood_jsonget/guest_lib.fx -o build/cap_dogfood_jsonget --emit-c \
  --host examples/cap_dogfood_jsonget/host.c \
  --link host/cap/fx_cap_runtime.c --link-include host/cap
```

Host links the packageable spine (`host/cap` + `host/cli`). See [COMPOSITION.md](../../docs/COMPOSITION.md).
