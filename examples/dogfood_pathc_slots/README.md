# Path C dogfood - dense slot distances

Living Path C sample: **grow once**, then **no-grow** `v[i]=x` slot updates under `effects { mut }`.

| Phase | API |
|-------|-----|
| Grow | `vec.push` / reassign |
| Slot write | `dist[i] = x` (MUT-2 sugar; same family as `vec_set`) |
| Refuse | Soft-fx · growable realloc under index-assign |

```text
.\scripts\test-pathc-app.ps1
# or:
fx run examples/dogfood_pathc_slots/main.fx              # IR default → 42
fx run examples/dogfood_pathc_slots/main.fx --emit-c     # → 42
```

See the composition / wrap guides · the composition / wrap guides.
