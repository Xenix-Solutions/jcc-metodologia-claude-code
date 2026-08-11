<#
.SYNOPSIS
  Sincroniza las skills JCC entre este repo (fuente de verdad) y
  ~/.claude/skills/ (la copia que lee Claude Code).

.DESCRIPTION
  Sin parametros: instala repo -> ~/.claude/skills/<skill>/SKILL.md. Idempotente.
  Ademas ELIMINA las copias legacy ~/.claude/commands/jcc-*.md que correspondan a
  skills del repo (migracion commands->skills de v1.4): si conviven, la skill gana,
  pero la copia muerta queda como divergencia silenciosa.
  -Check       : no escribe ni borra nada; informa de divergencias y devuelve exit code 1 si hay.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -Check
#>
[CmdletBinding()]
param(
    [switch]$Check
)

$ErrorActionPreference = 'Stop'

$RepoDir      = $PSScriptRoot
$LiveDir      = Join-Path $env:USERPROFILE '.claude\skills'
$LegacyDir    = Join-Path $env:USERPROFILE '.claude\commands'

if (-not (Test-Path $LiveDir)) {
    if ($Check) {
        Write-Host "No existe $LiveDir - las skills no estan instaladas." -ForegroundColor Yellow
        exit 1
    }
    New-Item -ItemType Directory -Force $LiveDir | Out-Null
    Write-Host "Creado $LiveDir"
}

function Get-ContentHash($Path) {
    if (Test-Path $Path) { (Get-FileHash -Algorithm SHA256 $Path).Hash } else { $null }
}

$repoSkills = @(Get-ChildItem (Join-Path $RepoDir 'jcc-*') -Directory -ErrorAction SilentlyContinue |
                Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })
$liveSkills = @(Get-ChildItem (Join-Path $LiveDir 'jcc-*') -Directory -ErrorAction SilentlyContinue |
                Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })

if ($repoSkills.Count -eq 0) {
    Write-Host "No hay carpetas jcc-*/SKILL.md en $RepoDir - nada que sincronizar." -ForegroundColor Yellow
    exit 1
}

$diverged  = @()
$installed = @()
$unbacked  = @()
$legacy    = @()

foreach ($s in $repoSkills) {
    $repoFile = Join-Path $s.FullName 'SKILL.md'
    $liveFile = Join-Path (Join-Path $LiveDir $s.Name) 'SKILL.md'
    if ((Get-ContentHash $repoFile) -eq (Get-ContentHash $liveFile)) { continue }

    if ($Check) {
        if (Test-Path $liveFile) { $diverged += "$($s.Name): contenido distinto entre repo y copia viva" }
        else                     { $diverged += "$($s.Name): falta en la copia viva" }
    }
    else {
        New-Item -ItemType Directory -Force (Join-Path $LiveDir $s.Name) | Out-Null
        Copy-Item $repoFile $liveFile -Force
        $installed += $s.Name
    }
}

# Copias legacy en ~/.claude/commands: SOLO los .md cuyo nombre coincide con una skill
# del repo (los cinco de la migracion v1.4); el resto de esa carpeta no se toca.
foreach ($s in $repoSkills) {
    $legacyFile = Join-Path $LegacyDir "$($s.Name).md"
    if (Test-Path $legacyFile) {
        if ($Check) { $legacy += "$($s.Name).md: copia legacy en $LegacyDir (la borraria el install)" }
        else {
            Remove-Item $legacyFile -Force -Confirm:$false
            $legacy += "$($s.Name).md"
        }
    }
}

# Skills vivas sin respaldo en el repo: el caso que importa, es trabajo que se perderia.
foreach ($s in $liveSkills) {
    if (-not (Test-Path (Join-Path (Join-Path $RepoDir $s.Name) 'SKILL.md'))) {
        $unbacked += "$($s.Name): existe en la copia viva pero NO esta respaldada en el repo"
    }
}

if ($Check) {
    if ($diverged.Count -eq 0 -and $unbacked.Count -eq 0 -and $legacy.Count -eq 0) {
        Write-Host "OK - repo y copia viva coinciden ($($repoSkills.Count) skills), sin copias legacy." -ForegroundColor Green
        exit 0
    }
    Write-Host "DIVERGENCIA:" -ForegroundColor Red
    ($diverged + $unbacked + $legacy) | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    Write-Host "Si la buena es la del repo:      .\install.ps1"
    Write-Host "Si la buena es la copia viva:    copiala al repo y commitea."
    exit 1
}

if ($installed.Count -eq 0) {
    Write-Host "Nada que hacer - ya estaban al dia ($($repoSkills.Count) skills)." -ForegroundColor Green
}
else {
    Write-Host "Instaladas en ${LiveDir}:" -ForegroundColor Green
    $installed | ForEach-Object { Write-Host "  - $_" }
}

if ($legacy.Count -gt 0) {
    Write-Host "Copias legacy eliminadas de ${LegacyDir}:" -ForegroundColor Green
    $legacy | ForEach-Object { Write-Host "  - $_" }
}

if ($unbacked.Count -gt 0) {
    Write-Host ""
    Write-Host "AVISO - hay skills vivas sin respaldo en el repo:" -ForegroundColor Yellow
    $unbacked | ForEach-Object { Write-Host "  - $_" }
    Write-Host "Copialas a skills\ y commitea si las quieres conservar."
}
