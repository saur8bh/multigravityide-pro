<#
.SYNOPSIS
Uninstall Multigravity IDE Pro completely including all profiles, shortcuts, and binary files.
#>
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$BASE = if ($env:MULTIGRAVITY_HOME) { $env:MULTIGRAVITY_HOME } else { "$env:USERPROFILE\AntigravityProfiles" }
$INSTALL_DIR = "$env:USERPROFILE\.local\bin"
$START_MENU = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Multigravity IDE Pro - Uninstaller    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will remove:"
Write-Host "  1. Multigravity CLI binary files ($INSTALL_DIR\multigravity.*)"
Write-Host "  2. Start Menu shortcuts ($START_MENU\Multigravity*)"
Write-Host "  3. ALL profile data & templates in $BASE" -ForegroundColor Yellow
Write-Host ""

if (-not $Force) {
    $confirm = Read-Host "Are you sure you want to completely uninstall Multigravity and DELETE ALL profiles? [y/N]"
    if ($confirm -notmatch "^[Yy]$") {
        Write-Host "Uninstall cancelled. Nothing was removed." -ForegroundColor Green
        exit 0
    }
}

# 1. Check for running Antigravity IDE processes
$procs = Get-Process -Name "Antigravity IDE", "Antigravity" -ErrorAction SilentlyContinue
if ($procs) {
    Write-Warning "Antigravity IDE appears to be currently running. Please close it if you encounter file lock errors."
}

# 2. Remove Start Menu shortcuts
Write-Host "Removing shortcuts..."
$shortcuts = Get-ChildItem -Path $START_MENU -Filter "Multigravity*.lnk" -ErrorAction SilentlyContinue
if ($shortcuts) {
    foreach ($s in $shortcuts) {
        Remove-Item -Path $s.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Removed shortcut: $($s.Name)"
    }
}

# 3. Remove Profiles Directory
if (Test-Path $BASE) {
    Write-Host "Removing all profiles and templates in $BASE..."
    try {
        Remove-Item -Path $BASE -Recurse -Force -ErrorAction Stop
        Write-Host "  Removed: $BASE"
    } catch {
        Write-Error "Warning: Could not completely delete $BASE. Some files may be locked. Details: $_"
    }
}

# 4. Remove Binary Files
Write-Host "Removing Multigravity executable files..."
$binFiles = @(
    "$INSTALL_DIR\multigravity.ps1",
    "$INSTALL_DIR\multigravity.cmd"
)
foreach ($bf in $binFiles) {
    if (Test-Path $bf) {
        Remove-Item -Path $bf -Force -ErrorAction SilentlyContinue
        Write-Host "  Removed: $bf"
    }
}

Write-Host ""
Write-Host "[OK] Multigravity IDE Pro has been completely uninstalled." -ForegroundColor Green
Write-Host "Note: If you wish to remove $INSTALL_DIR from your user PATH, you can edit your Environment Variables."
