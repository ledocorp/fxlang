#!/usr/bin/env bash
# Stranger smoke for the language package — doctor + dual-path exits.
# Run from the package root (folder that contains bin/ and examples/).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FX="$ROOT/bin/fx"
if [[ ! -x "$FX" ]]; then
  echo "bin/fx not found or not executable — run from the language package root" >&2
  exit 1
fi

echo "verify-pack: fx=$FX"
"$FX" doctor

assert42() {
  local label="$1"; shift
  echo "verify-pack: $label"
  set +e
  "$FX" "$@"
  local code=$?
  set -e
  if [[ "$code" -ne 42 ]]; then
    echo "$label exit $code (want 42)" >&2
    exit 1
  fi
}

EX="$ROOT/examples"
assert42 "showcase_core --emit-c" run "$EX/showcase_core/main.fx" --emit-c
assert42 "tool_bytes --emit-c" run "$EX/tool_bytes/main.fx" --emit-c
assert42 "pattern_ids --emit-c" run "$EX/pattern_ids/main.fx" --emit-c
assert42 "wire_smoke --emit-c" run "$EX/wire_smoke/main.fx" --emit-c

if [[ -x "$ROOT/third_party/qbe/obj/qbe" ]] || [[ -x "$ROOT/third_party/qbe/windows/qbe.exe" ]]; then
  assert42 "showcase_core Auto" run "$EX/showcase_core/main.fx"
  assert42 "pattern_ids Auto" run "$EX/pattern_ids/main.fx"
  echo "verify-pack: dual-path Auto OK (QBE present)"
else
  echo "verify-pack: QBE not in package — Auto dual-path skipped (emit-C only)"
fi

echo "verify-pack: OK"
exit 0
