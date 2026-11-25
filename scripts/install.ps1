<#
.SYNOPSIS
    Copy 1C agent skills into Cursor, Codex, and Claude directories.

.DESCRIPTION
    The source of truth is skills/ next to this script.
    agents  -> .agents/skills   shared path read by Cursor and Codex
    claude  -> .claude/skills   Claude Code
    cursor  -> .cursor/skills   Cursor only
    codex   -> .codex/skills    older Codex location

.EXAMPLE
    powershell -NoProfile -File .\scripts\install.ps1 -Scope user -Into agents,claude

.EXAMPLE
    powershell -NoProfile -File .\scripts\install.ps1 -Scope project -Root . -Into agents,claude
#>
[CmdletBinding()]
param(
    [ValidateSet("user", "project")]
    [string]$Scope = "user",

    [string]$Root,

    [string[]]$Into = @("agents", "claude")
)

$ErrorActionPreference = "Stop"

$Source = Join-Path (Split-Path -Parent $PSScriptRoot) "skills"
if (-not (Test-Path -LiteralPath $Source)) {
    throw "Skills directory not found: $Source"
}

if (-not $Root) {
    if ($Scope -eq "user") {
        $Root = $env:USERPROFILE
    } else {
        $Root = (Get-Location).Path
    }
}

$Root = (Resolve-Path -LiteralPath $Root).Path

$map = @{
    agents = ".agents\skills"
    claude = ".claude\skills"
    cursor = ".cursor\skills"
    codex  = ".codex\skills"
}

$keys = @()
foreach ($item in $Into) {
    foreach ($part in ($item -split ",")) {
        $name = $part.Trim()
        if ($name) { $keys += $name }
    }
}

if (-not $keys) {
    throw "Pass -Into with one or more of: agents, claude, cursor, codex"
}

$skillDirs = @(Get-ChildItem -LiteralPath $Source -Directory)
if (-not $skillDirs) {
    throw "No skill directories in $Source"
}

foreach ($key in $keys) {
    if (-not $map.ContainsKey($key)) {
        throw "Unknown destination '$key'. Use: agents, claude, cursor, codex"
    }

    $destRoot = Join-Path $Root $map[$key]
    New-Item -ItemType Directory -Force -Path $destRoot | Out-Null

    foreach ($skill in $skillDirs) {
        $target = Join-Path $destRoot $skill.Name
        if (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target -Recurse -Force
        }
        Copy-Item -LiteralPath $skill.FullName -Destination $target -Recurse
    }

    Write-Output "Installed to $destRoot"
}
