#!/usr/bin/env pwsh
# Usage:
#   .\scripts\release.ps1           # bump patch (1.0.0 -> 1.0.1)
#   .\scripts\release.ps1 minor     # bump minor (1.0.0 -> 1.1.0)
#   .\scripts\release.ps1 major     # bump major (1.0.0 -> 2.0.0)
#
# Bumps pubspec.yaml version, commits, pushes, and creates a GitHub Release.
# Requires: git, gh (GitHub CLI) authenticated.

param(
    [ValidateSet("patch", "minor", "major")]
    [string]$Bump = "patch"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Read current version from pubspec.yaml ---
$pubspec = Get-Content "$PSScriptRoot/../pubspec.yaml" -Raw
if ($pubspec -notmatch 'version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)') {
    Write-Error "Could not parse version from pubspec.yaml"
    exit 1
}

[int]$major = $Matches[1]
[int]$minor = $Matches[2]
[int]$patch = $Matches[3]
[int]$build = $Matches[4]

# --- Bump ---
switch ($Bump) {
    "major" { $major++; $minor = 0; $patch = 0 }
    "minor" { $minor++; $patch = 0 }
    "patch" { $patch++ }
}
$build++

$newVersion = "$major.$minor.$patch+$build"
$newVersionName = "$major.$minor.$patch"

Write-Host "Bumping version: $($Matches[1]).$($Matches[2]).$($Matches[3])+$($Matches[4]) -> $newVersion"

# --- Update pubspec.yaml ---
$updated = $pubspec -replace 'version:\s*\d+\.\d+\.\d+\+\d+', "version: $newVersion"
Set-Content "$PSScriptRoot/../pubspec.yaml" $updated -NoNewline

# --- Commit & tag ---
Push-Location "$PSScriptRoot/.."
try {
    git add pubspec.yaml
    git commit -m "chore: bump version to $newVersion"
    git tag "v$newVersionName"
    git push
    git push origin "v$newVersionName"

    # --- Create GitHub Release (triggers CD workflow) ---
    gh release create "v$newVersionName" `
        --title "v$newVersionName" `
        --notes "Release $newVersionName" `
        --latest

    Write-Host ""
    Write-Host "Released v$newVersionName. CD workflow is now building and uploading to Play Store (internal track)."
    Write-Host "Promote to production from GitHub Actions using workflow_dispatch."
} finally {
    Pop-Location
}
