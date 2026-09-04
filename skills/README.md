# `skills/` — las skills JCC (copia de referencia)

Los prompts de la metodología JCC en formato skill. En v1.5 son **diez**: las cuatro fases del workflow (`/jcc-design`, `/jcc-spec`, `/jcc-implement`, `/jcc-review`), el cierre (`/jcc-handoff`), las cuatro herramientas fuera del workflow (`/jcc-start`, `/jcc-analysis`, `/jcc-query`, `/jcc-audit`) y el mantenimiento (`/jcc-upgrade`). Hasta v1.3.2 fueron slash commands en `commands/`; en v1.4 migraron a skills (`skills/<nombre>/SKILL.md`), el formato vigente de la plataforma. La invocación no cambia: se siguen tecleando igual, **con la barra al inicio del mensaje**.

**Esta carpeta es la copia de referencia de la versión publicada** (la metodología se evoluciona en un repo privado; aquí llega cada versión liberada). Claude Code, en cambio, solo ve las skills que están en `~/.claude/skills/` (ámbito de usuario, disponibles en todos tus proyectos). De ahí las dos ubicaciones y el script que las mantiene alineadas. Lo mismo vale para la **definición de agente** del revisor, que vive en [`../agents/jcc-review.md`](../agents/jcc-review.md) y se instala en `~/.claude/agents/`.

| | Ruta | Rol |
|---|---|---|
| **Referencia** | `skills/<nombre>/SKILL.md` y `agents/<nombre>.md` (este repo) | la versión publicada; se actualiza con cada release |
| **Copia viva** | `~/.claude/skills/<nombre>/SKILL.md` y `~/.claude/agents/<nombre>.md` | la que lee Claude Code; se regenera desde el repo |

## Frontmatter

Todas llevan `name:` (igual a la carpeta), `description:` y **`disable-model-invocation: true`**: los commands jamás deben auto-dispararse — un `/jcc-handoff` o `/jcc-review` auto-invocado a mitad de sesión sería un incidente. Esa línea garantiza **por mecanismo** que el modelo no lo invoque por iniciativa propia (verificado en sonda: sin mención en el mensaje, el harness lo bloquea), no por defecto de plataforma que puede cambiar en un point release, y además saca las descripciones del presupuesto de contexto. Lo que NO garantiza (v1.5.1): si el usuario menciona `/jcc-x` en mitad de un mensaje, el modelo puede invocarlo con la herramienta Skill y el harness lo permite; ese caso lo cubre la línea de detección del bloque JCC, que es instrucción, no barrera. `argument-hint:` en las que reciben argumentos (`jcc-design`, `jcc-analysis`, `jcc-start`, `jcc-query`, `jcc-audit`, `jcc-upgrade`; `jcc-spec` y `jcc-implement` admiten una ruta opcional). Los commands se nombran **en inglés** (convención v1.5: `jcc-consulta` → `jcc-query`, `jcc-auditoria` → `jcc-audit`).

La definición de agente (`agents/jcc-review.md`) lleva además `model: claude-opus-5`, `effort: high` y `tools: Read, Grep, Glob, Bash, Write, Edit` (`tools` es lista blanca: sin `Write`/`Edit` el agente no podría escribir `REVIEW.md`; corregido en v1.5.1) — ID completo, no alias, porque un alias en un fichero durable es una fecha de caducidad sin fecha; y `effort` fijado porque un subagente sin definición hereda el de la sesión (doc oficial: *"Default: inherits from session"*). **Asimetría a vigilar:** las definiciones de agente no tienen equivalente a `disable-model-invocation`, así que el agente es, en principio, invocable por el modelo por su cuenta; lo frena su `description` ("NUNCA lo lances por iniciativa propia") y la doctrina del bloque (la Review la dispara el operador).

## Registro de los prompts (v1.5)

Las skills están redactadas **outcome-first** para Fable 5.1: primero el resultado de la fase y sus fronteras (qué NO hace), después el contrato. Las **puertas del operador** (entrevista por tandas, visto bueno antes de escribir, mesa común para lo estructural, "no bloquees: dilo y sigue"), la **numeración de pasos** y el **formato de los artefactos** son contrato, no andamiaje. Toda instrucción atada a un modelo concreto lleva la etiqueta `calibración vX.Y para <modelo>; revisar al cambiar de modelo`. Cada skill de fase lleva una **copia etiquetada** del perfil de su fase (modelo y effort de la tabla *Perfil por fase*) y la **verifica** al arrancar; la tabla es la fuente y un cambio en ella arrastra las copias en el mismo patch (v1.5.1).

## Uso

Instalar o actualizar la copia viva desde el repo (idempotente, se puede repetir sin miedo):

```powershell
.\skills\install.ps1
```

El install además **retira copias muertas** que, si conviven con las vivas, quedan como divergencia silenciosa: las legacy `~/.claude/commands/<skill>.md` con el nombre de una skill del kit (era command, hasta v1.3.2; el resto de esa carpeta no se toca) y las skills **renombradas** en v1.5 (`~/.claude/skills/jcc-consulta/`, `~/.claude/skills/jcc-auditoria/`; si eran un enlace o junction, retira solo el enlace, nunca su destino — v1.5.1). E instala `../agents/jcc-*.md` en `~/.claude/agents/`.

Solo Windows/PowerShell (usa `$env:USERPROFILE`). Si la política de ejecución bloquea el script: `powershell -ExecutionPolicy Bypass -File .\skills\install.ps1`.

Comprobar si las dos copias han divergido, sin escribir nada (devuelve exit code 1 si hay divergencia; cubre skills y agentes):

```powershell
.\skills\install.ps1 -Check
```

`-Check` avisa además de skills o agentes tuyos que existen en `~/.claude/` y **no** están en este repo, por si quieres versionarlos en tu propio repo: es trabajo que se perdería al cambiar de máquina o al reinstalar.

## En una máquina nueva

```powershell
git clone https://github.com/Xenix-Solutions/jcc-metodologia-claude-code
cd jcc-metodologia-claude-code
.\skills\install.ps1
```

Después, en cada proyecto: abrirlo y `/jcc-start`. Si el proyecto tiene un bloque JCC de una versión anterior, `jcc-start` lo detecta y ofrece `/jcc-upgrade`; la migración es por proyecto, a demanda.

## Por qué una copia y no un enlace

Un enlace simbólico o un hard link darían una sola copia real y cero divergencia posible, pero: los symlinks de fichero en Windows piden Developer Mode o permisos de administrador; un hard link **se rompe en silencio** si un editor reemplaza el fichero en vez de escribirlo en sitio; y ninguno de los dos cruza máquinas. Una copia explícita más `-Check` es más tosca, pero falla de forma **visible** — que es lo que interesa cuando el fallo que se quiere evitar es un estado desincronizado que no se nota.

## Relación con el documento de metodología

El documento de metodología **describe** cada fase; el **prompt operativo vive solo en su skill**, sin duplicarse en prosa. Es una decisión de la v1.1: si el mismo prompt estuviera enunciado en dos sitios, divergirían sin que se note.

Esta carpeta no rompe esa regla. No es un segundo enunciado del prompt, es un respaldo **byte a byte** cuya coincidencia se verifica con un comando (`-Check`). La duplicación problemática es la que no se puede comprobar; ésta sí. Las únicas copias deliberadas son las **plantillas del bootstrap** — el bloque JCC (byte a byte) y el esqueleto de `jccdocs/README.md` (columnas) —, que viven en el documento y, embebidas, en `jcc-start` (para que el bootstrap las escriba sin red); si difieren, manda el documento.
