<#
.SYNOPSIS
  Sincroniza los slash commands JCC entre este repo (fuente de verdad) y
  ~/.claude/commands/ (la copia que lee Claude Code).

.DESCRIPTION
  Sin parametros: instala repo -> ~/.claude/commands. Idempotente.
  -Check       : no escribe nada; informa de divergencias y devuelve exit code 1 si hay.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -Check
#>
[CmdletBinding()]
param(
    [switch]$Check
)

$ErrorActionPreference = 'Stop'

$RepoDir = $PSScriptRoot
$LiveDir = Join-Path $env:USERPROFILE '.claude\commands'

if (-not (Test-Path $LiveDir)) {
    if ($Check) {
        Write-Host "No existe $LiveDir - los commands no estan instalados." -ForegroundColor Yellow
        exit 1
    }
    New-Item -ItemType Directory -Force $LiveDir | Out-Null
    Write-Host "Creado $LiveDir"
}

function Get-ContentHash($Path) {
    if (Test-Path $Path) { (Get-FileHash -Algorithm SHA256 $Path).Hash } else { $null }
}

$repoFiles = @(Get-ChildItem (Join-Path $RepoDir 'jcc-*.md') -File -ErrorAction SilentlyContinue)
$liveFiles = @(Get-ChildItem (Join-Path $LiveDir 'jcc-*.md') -File -ErrorAction SilentlyContinue)

if ($repoFiles.Count -eq 0) {
    Write-Host "No hay ficheros jcc-*.md en $RepoDir - nada que sincronizar." -ForegroundColor Yellow
    exit 1
}

$diverged  = @()
$installed = @()
$unbacked  = @()

foreach ($f in $repoFiles) {
    $livePath = Join-Path $LiveDir $f.Name
    if ((Get-ContentHash $f.FullName) -eq (Get-ContentHash $livePath)) { continue }

    if ($Check) {
        if (Test-Path $livePath) { $diverged += "$($f.Name): contenido distinto entre repo y copia viva" }
        else                     { $diverged += "$($f.Name): falta en la copia viva" }
    }
    else {
        Copy-Item $f.FullName $livePath -Force
        $installed += $f.Name
    }
}

# Commands vivos sin respaldo en el repo: el caso que importa, es trabajo que se perderia.
foreach ($f in $liveFiles) {
    if (-not (Test-Path (Join-Path $RepoDir $f.Name))) {
        $unbacked += "$($f.Name): existe en la copia viva pero NO esta respaldado en el repo"
    }
}

if ($Check) {
    if ($diverged.Count -eq 0 -and $unbacked.Count -eq 0) {
        Write-Host "OK - repo y copia viva coinciden ($($repoFiles.Count) commands)." -ForegroundColor Green
        exit 0
    }
    Write-Host "DIVERGENCIA:" -ForegroundColor Red
    ($diverged + $unbacked) | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    Write-Host "Si la buena es la del repo:      .\install.ps1"
    Write-Host "Si la buena es la copia viva:    copiala al repo y commitea."
    exit 1
}

if ($installed.Count -eq 0) {
    Write-Host "Nada que hacer - ya estaban al dia ($($repoFiles.Count) commands)." -ForegroundColor Green
}
else {
    Write-Host "Instalados en ${LiveDir}:" -ForegroundColor Green
    $installed | ForEach-Object { Write-Host "  - $_" }
}

if ($unbacked.Count -gt 0) {
    Write-Host ""
    Write-Host "AVISO - hay commands vivos sin respaldo en el repo:" -ForegroundColor Yellow
    $unbacked | ForEach-Object { Write-Host "  - $_" }
    Write-Host "Copialos a commands\ y commitea si los quieres conservar."
}
