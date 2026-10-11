# Builds the Windows release and compiles the Inno Setup installer.
# Usage (PowerShell, from the project root):
#   .\installer\windows\build_installer.ps1            # uses version from pubspec.yaml
#   .\installer\windows\build_installer.ps1 -Version 1.2.0
#
# Requirements: Flutter (Windows desktop enabled), Visual Studio Build Tools, Inno Setup 6
#   winget install JRSoftware.InnoSetup
param([string]$Version)

$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $root

if (-not $Version) {
  $line = Get-Content pubspec.yaml | Where-Object { $_ -match '^version:' } | Select-Object -First 1
  $Version = ($line -replace 'version:\s*', '') -replace '\+.*', ''
}

Write-Host "> Building FrameWorkz $Version for Windows..." -ForegroundColor Cyan
flutter build windows --release --build-name=$Version
if ($LASTEXITCODE -ne 0) { throw "flutter build failed" }

# Optional: bundle the VC++ runtime so the installer works on clean machines.
$redist = Join-Path $PSScriptRoot "redist"
if (-not (Test-Path (Join-Path $redist "vc_redist.x64.exe"))) {
  New-Item -ItemType Directory -Force $redist | Out-Null
  Write-Host "> Downloading vc_redist.x64.exe..." -ForegroundColor Cyan
  try {
    Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile (Join-Path $redist "vc_redist.x64.exe")
  } catch {
    Write-Warning "Could not download vc_redist; installer will skip it."
  }
}

$iscc = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
  "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $iscc) {
  throw "Inno Setup 6 not found. Install it with: winget install JRSoftware.InnoSetup"
}

Write-Host "> Compiling installer..." -ForegroundColor Cyan
& $iscc "/DMyAppVersion=$Version" (Join-Path $PSScriptRoot "FrameWorkz.iss")
if ($LASTEXITCODE -ne 0) { throw "ISCC failed" }

Write-Host "OK -> installer\dist\FrameWorkz-Setup-$Version.exe" -ForegroundColor Green
