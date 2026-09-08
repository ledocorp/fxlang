# Web starter

Static HTML/CSS/JS for local **fxserve** (fx serve season).

```text
fx new mysite web
cd mysite
```

From an fx checkout:

```powershell
<path-to-fx>\tools\fxserve\build.ps1
<path-to-fx>\tools\fxserve\out\fxserve.exe .\site --port 8765
# concurrent (CONCUR-NET-1):
<path-to-fx>\tools\fxserve\out\fxserve.exe .\site --port 8765 --workers 4 --requests 16
```

Or gcc (Windows):

```text
gcc -O2 -I<path-to-fx>/host/serve <path-to-fx>/tools/fxserve/main.c <path-to-fx>/host/serve/fx_http_static.c -o fxserve -lws2_32
fxserve ./site --port 8765
```

Open `http://127.0.0.1:8765/`.

Listen/static live in **host/serve + fxserve** - not `std/`, not `lib/` (yet).
