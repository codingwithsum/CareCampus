#!/usr/bin/env pwsh
# ======================================================
# CareCampus - Build Script
# ======================================================
# This script reads .env file and passes all values as
# --dart-define parameters to flutter build/run commands.
# ======================================================
# Usage:
#   .\build.ps1 run              # flutter run with .env
#   .\build.ps1 build apk        # flutter build apk with .env
#   .\build.ps1 build web        # flutter build web with .env
#   .\build.ps1 run -d chrome    # flutter run on chrome with .env
# ======================================================

param(
    [Parameter(Position=0)]
    [string]$Command = "run",

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$ExtraArgs
)

$envFile = Join-Path $PSScriptRoot ".env"

if (-Not (Test-Path $envFile)) {
    Write-Host "ERROR: .env file not found!" -ForegroundColor Red
    Write-Host "Copy .env.example to .env and fill in your actual values:" -ForegroundColor Yellow
    Write-Host "  cp .env.example .env" -ForegroundColor Yellow
    exit 1
}

# Read .env file and build --dart-define flags
$dartDefines = @()
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    # Skip comments and empty lines
    if ($line -and -not $line.StartsWith('#')) {
        $dartDefines += "--dart-define=$line"
    }
}

Write-Host "Loaded $($dartDefines.Count) environment variables from .env" -ForegroundColor Green

# Build the full command
$fullArgs = @($Command) + $dartDefines + $ExtraArgs

Write-Host "Running: flutter $($fullArgs -join ' ')" -ForegroundColor Cyan
Write-Host ""

& flutter @fullArgs
