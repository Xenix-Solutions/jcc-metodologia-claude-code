# `skills/` — las skills JCC (copia versionada)

Los prompts de fase de la metodología JCC en formato skill: `/jcc-design`, `/jcc-spec`, `/jcc-implement`, `/jcc-review`, `/jcc-handoff` (+ las herramientas auxiliares que se añadan). Hasta v1.3.2 fueron slash commands en `commands/`; en v1.4 migraron a skills (`skills/<nombre>/SKILL.md`), el formato vigente de la plataforma tras la fusión commands→skills de Claude Code v2.1.3. La invocación no cambia: se siguen tecleando igual.

**Esta carpeta es la copia de referencia de la versión publicada** (la metodología se evoluciona en un repo privado; aquí llega cada versión liberada). Claude Code, en cambio, solo ve las skills que están en `~/.claude/skills/` (ámbito de usuario, disponibles en todos tus proyectos). De ahí las dos ubicaciones y el script que las mantiene alineadas.

| | Ruta | Rol |
|---|---|---|
| **Referencia** | `skills/<nombre>/SKILL.md` (este repo) | la versión publicada; se actualiza con cada release |
| **Copia viva** | `~/.claude/skills/<nombre>/SKILL.md` | la que lee Claude Code; se regenera desde el repo |

## Frontmatter (decisión v1.4)

Todas llevan `name:` (igual a la carpeta; obligatorio en el spec Agent Skills, aunque Claude Code lo tome del nombre de carpeta si falta) y **`disable-model-invocation: true`**: los comandos de fase jamás deben auto-dispararse — un `/jcc-handoff` o `/jcc-review` auto-invocado a mitad de sesión sería un incidente. Esa línea garantiza la invocación explícita **por mecanismo**, no por defecto de plataforma que puede cambiar en un point release, y además saca las descripciones del presupuesto de contexto. `argument-hint:` solo en `jcc-design` (la única que recibe argumentos).

## Uso

Instalar o actualizar la copia viva desde el repo (idempotente, se puede repetir sin miedo):

```powershell
.\skills\install.ps1
```

El install además **elimina las copias legacy** `~/.claude/commands/jcc-*.md` que correspondan a skills del repo (resto de la era command): si conviven, la skill gana, pero la copia muerta queda como divergencia silenciosa.

Comprobar si las dos copias han divergido, sin escribir nada (devuelve exit code 1 si hay divergencia):

```powershell
.\skills\install.ps1 -Check
```

`-Check` avisa además de skills tuyas que existen en `~/.claude/skills/` y **no** están respaldadas aquí, por si quieres versionarlas en tu propio repo: es trabajo que se perdería al cambiar de máquina o al reinstalar.

## En una máquina nueva

```powershell
git clone https://github.com/Xenix-Solutions/jcc-metodologia-claude-code
cd jcc-metodologia-claude-code
.\skills\install.ps1
```

## Por qué una copia y no un enlace

Un enlace simbólico o un hard link darían una sola copia real y cero divergencia posible, pero: los symlinks de fichero en Windows piden Developer Mode o permisos de administrador; un hard link **se rompe en silencio** si un editor reemplaza el fichero en vez de escribirlo en sitio; y ninguno de los dos cruza máquinas. Una copia explícita más `-Check` es más tosca, pero falla de forma **visible** — que es lo que interesa cuando el fallo que se quiere evitar es un estado desincronizado que no se nota.

## Relación con el documento de metodología

El documento de metodología **describe** cada fase; el **prompt operativo vive solo en su skill**, sin duplicarse en prosa. Es una decisión de la v1.1: si el mismo prompt estuviera enunciado en dos sitios, divergirían sin que se note.

Esta carpeta no rompe esa regla. No es un segundo enunciado del prompt, es un respaldo **byte a byte** cuya coincidencia se verifica con un comando (`-Check`). La duplicación problemática es la que no se puede comprobar; ésta sí.
