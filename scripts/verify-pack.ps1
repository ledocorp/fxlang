#Requires -Version 5.1
<#
.SYNOPSIS
  Stranger smoke for the language package — doctor + dual-path exits.

.DESCRIPTION
  Run from the package root (folder that contains bin/ and examples/).
  Expects exit 42 from teaching demos. Does not run the private monorepo M5.

  Usage:
    .\scripts\verify-pack.ps1
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'
$PSNativeCommandUseErrorActionPreference = $false

$Root = Split-Path -Parent $PSScriptRoot
$Fx = $env:FX_BIN
if (-not $Fx) {
    $Fx = Join-Path $Root 'bin\fx.exe'
    if (-not (Test-Path -LiteralPath $Fx)) {
        $Fx = Join-Path $Root 'bin\fx'
    }
}
if (-not (Test-Path -LiteralPath $Fx)) {
    Write-Error 'bin/fx not found — run from the language package root (or set FX_BIN)'
    exit 1
}

Write-Host "verify-pack: fx=$Fx" -ForegroundColor Cyan
& $Fx doctor
if ($LASTEXITCODE -ne 0) { throw "fx doctor failed: $LASTEXITCODE" }

function Assert-Exit42([string]$Label, [string[]]$FxArgs) {
    Write-Host "verify-pack: $Label" -ForegroundColor DarkGray
    & $Fx @FxArgs
    $code = $LASTEXITCODE
    if ($code -ne 42) {
        throw "$Label exit $code (want 42)"
    }
}

$ex = Join-Path $Root 'examples'
Assert-Exit42 'showcase_core --emit-c' @('run', (Join-Path $ex 'showcase_core\main.fx'), '--emit-c')
Assert-Exit42 'tool_bytes --emit-c' @('run', (Join-Path $ex 'tool_bytes\main.fx'), '--emit-c')
Assert-Exit42 'pattern_ids --emit-c' @('run', (Join-Path $ex 'pattern_ids\main.fx'), '--emit-c')
Assert-Exit42 'wire_smoke --emit-c' @('run', (Join-Path $ex 'wire_smoke\main.fx'), '--emit-c')

# Dual-path when IR/QBE works on this host (skip-clean if Auto falls back oddly).
$qbeWin = Join-Path $Root 'third_party\qbe\windows\qbe.exe'
$qbeLin = Join-Path $Root 'third_party\qbe\obj\qbe'
$hasQbe = (Test-Path -LiteralPath $qbeWin) -or (Test-Path -LiteralPath $qbeLin)
if ($hasQbe) {
    Assert-Exit42 'showcase_core Auto' @('run', (Join-Path $ex 'showcase_core\main.fx'))
    Assert-Exit42 'pattern_ids Auto' @('run', (Join-Path $ex 'pattern_ids\main.fx'))
    Write-Host 'verify-pack: dual-path Auto OK (QBE present)' -ForegroundColor Green
} else {
    Write-Host 'verify-pack: QBE not in package — Auto dual-path skipped (emit-C only)' -ForegroundColor Yellow
}

Write-Host 'verify-pack: OK' -ForegroundColor Green
exit 0
