<#
.SYNOPSIS
  Sincroniza el kit JCC entre este repo (fuente de verdad) y la copia que lee Claude Code:
  skills -> ~/.claude/skills/<skill>/SKILL.md y definiciones de agente -> ~/.claude/agents/<agente>.md.

.DESCRIPTION
  Sin parametros: instala repo -> ~/.claude/skills/<skill>/SKILL.md (10 skills en v1.5) y
  ../agents/jcc-*.md -> ~/.claude/agents/ (jcc-review: revisor Opus 5 con effort fijado). Idempotente.
  Ademas RETIRA copias muertas que, si conviven con las vivas, quedan como divergencia silenciosa:
   - legacy ~/.claude/commands/jcc-*.md que correspondan a skills del repo (migracion v1.4);
   - skills renombradas en v1.5: ~/.claude/skills/jcc-consulta/ (hoy jcc-query) y
     ~/.claude/skills/jcc-auditoria/ (hoy jcc-audit).
  -Check       : no escribe ni borra nada; informa de divergencias (skills y agentes) y devuelve
                 exit code 1 si hay.

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
$AgentsRepo   = Join-Path (Split-Path $RepoDir -Parent) 'agents'
$LiveDir      = Join-Path $env:USERPROFILE '.claude\skills'
$AgentsLive   = Join-Path $env:USERPROFILE '.claude\agents'
$LegacyDir    = Join-Path $env:USERPROFILE '.claude\commands'
# Skills renombradas en v1.5: la copia viva con el nombre viejo se retira (la nueva la instala este script).
$RenamedSkills = @('jcc-consulta', 'jcc-auditoria')

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

$repoAgents = @(Get-ChildItem (Join-Path $AgentsRepo 'jcc-*.md') -File -ErrorAction SilentlyContinue)

$diverged  = @()
$installed = @()
$unbacked  = @()
$legacy    = @()
$renamed   = @()

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
# del repo (migracion commands->skills de v1.4); el resto de esa carpeta no se toca.
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

# Skills renombradas (v1.5): la carpeta viva con el nombre viejo se retira entera.
foreach ($old in $RenamedSkills) {
    $oldDir = Join-Path $LiveDir $old
    if (Test-Path $oldDir) {
        if ($Check) { $renamed += "${old}: skill renombrada en v1.5, copia viva obsoleta en $LiveDir (la retiraria el install)" }
        else {
            # Si la carpeta es un enlace (junction/symlink), se retira solo el enlace, nunca su destino.
            if ((Get-Item $oldDir -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
                [IO.Directory]::Delete($oldDir)
            } else {
                Remove-Item $oldDir -Recurse -Force -Confirm:$false
            }
            $renamed += $old
        }
    }
}

# Definiciones de agente: ../agents/jcc-*.md -> ~/.claude/agents/<nombre>.md
foreach ($a in $repoAgents) {
    $liveAgent = Join-Path $AgentsLive $a.Name
    if ((Get-ContentHash $a.FullName) -eq (Get-ContentHash $liveAgent)) { continue }
    if ($Check) {
        if (Test-Path $liveAgent) { $diverged += "agente $($a.BaseName): contenido distinto entre repo y copia viva" }
        else                      { $diverged += "agente $($a.BaseName): falta en $AgentsLive" }
    }
    else {
        New-Item -ItemType Directory -Force $AgentsLive | Out-Null
        Copy-Item $a.FullName $liveAgent -Force
        $installed += "agente $($a.BaseName)"
    }
}

# Skills vivas sin respaldo en el repo: el caso que importa, es trabajo que se perderia.
# (Las renombradas ya se han tratado arriba; en -Check no se cuentan dos veces.)
foreach ($s in $liveSkills) {
    if ($RenamedSkills -contains $s.Name) { continue }
    if (-not (Test-Path (Join-Path (Join-Path $RepoDir $s.Name) 'SKILL.md'))) {
        $unbacked += "$($s.Name): existe en la copia viva pero NO esta respaldada en el repo"
    }
}

# Agentes vivos sin respaldo en el repo (mismo criterio que las skills).
if (Test-Path $AgentsLive) {
    foreach ($a in @(Get-ChildItem (Join-Path $AgentsLive 'jcc-*.md') -File -ErrorAction SilentlyContinue)) {
        if (-not (Test-Path (Join-Path $AgentsRepo $a.Name))) {
            $unbacked += "agente $($a.BaseName): existe en $AgentsLive pero NO esta respaldado en el repo"
        }
    }
}

if ($Check) {
    if ($diverged.Count -eq 0 -and $unbacked.Count -eq 0 -and $legacy.Count -eq 0 -and $renamed.Count -eq 0) {
        Write-Host "OK - repo y copia viva coinciden ($($repoSkills.Count) skills + $($repoAgents.Count) agente(s)), sin copias legacy ni renombradas." -ForegroundColor Green
        exit 0
    }
    Write-Host "DIVERGENCIA:" -ForegroundColor Red
    ($diverged + $unbacked + $legacy + $renamed) | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    Write-Host "Si la buena es la del repo:      .\install.ps1"
    Write-Host "Si la buena es la copia viva:    copiala al repo y commitea."
    exit 1
}

if ($installed.Count -eq 0 -and $legacy.Count -eq 0 -and $renamed.Count -eq 0) {
    Write-Host "Nada que hacer - ya estaban al dia ($($repoSkills.Count) skills + $($repoAgents.Count) agente(s))." -ForegroundColor Green
}
elseif ($installed.Count -eq 0) {
    Write-Host "Copias vivas al dia ($($repoSkills.Count) skills + $($repoAgents.Count) agente(s)); solo hubo retiradas:" -ForegroundColor Green
}
else {
    Write-Host "Instalado (skills en ${LiveDir}, agentes en ${AgentsLive}):" -ForegroundColor Green
    $installed | ForEach-Object { Write-Host "  - $_" }
}

if ($renamed.Count -gt 0) {
    Write-Host "Copias vivas de skills renombradas retiradas de ${LiveDir}:" -ForegroundColor Green
    $renamed | ForEach-Object { Write-Host "  - $_" }
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
