# host/concur - structured task nursery

Host-side join-before-teardown nursery (`fx_task_nursery`). OS threads only;
not language `spawn` / channels.

```text
gcc -Ihost/concur your_host.c host/concur/fx_task_nursery.c -o your_app
# Linux: add -pthread
```

Smoke: `examples/concur_nursery_smoke/`.
