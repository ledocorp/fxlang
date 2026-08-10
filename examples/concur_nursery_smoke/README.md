# concur_nursery_smoke

Host-only smoke for the structured task nursery (`host/concur`).

```text
# Windows (MinGW)
gcc -I../../host/concur -I../../host/cli host.c ../../host/concur/fx_task_nursery.c -o nursery_probe

# Linux
gcc -I../../host/concur -I../../host/cli host.c ../../host/concur/fx_task_nursery.c -pthread -o nursery_probe

./nursery_probe   # expect exit 0
```

Proves: two tasks write 20 and 22 → join → sum 42; destroy joins; spawn after
destroy returns dead; fill table returns full.
