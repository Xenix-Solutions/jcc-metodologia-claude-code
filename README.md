# Metodología JCC — Agentic Dev con Claude Code

Metodología de desarrollo con **Claude Code (CC)**: un solo flujo para producto nuevo o cambios sobre código existente, mediante diseño conjunto entre pares que lleva al mejor resultado y lo ejecuta con control, con CC operando como **copiloto** consciente del marco y una estructura documental (`jccdocs/`) que cualquier sesión o compañero puede recorrer.

Este repositorio es la **publicación de la versión vigente**: el documento de la metodología, las skills (los prompts de fase y las herramientas fuera del workflow, invocadas como slash commands), la definición de agente del revisor y su instalador. La evolución (histórico, debates de diseño, versiones archivadas) vive en un repositorio privado; aquí llega cada versión liberada.

## 👉 Empieza aquí

- **Documento de la metodología:** [`docs/JCC_Metodologia.md`](docs/JCC_Metodologia.md). La versión vigente está declarada **dentro del documento** (cabecera y *Estado del documento*); el nombre del fichero es deliberadamente estable para que los enlaces y URLs no caduquen entre versiones.
- **Instalación del kit** (Windows / PowerShell):

```powershell
git clone https://github.com/Xenix-Solutions/jcc-metodologia-claude-code
cd jcc-metodologia-claude-code
.\skills\install.ps1
```

El script copia cada `skills/<nombre>/SKILL.md` a `~/.claude/skills/` y `agents/jcc-review.md` a `~/.claude/agents/` (ámbito de usuario: disponibles en todos tus proyectos), y retira copias muertas: las legacy `~/.claude/commands/<skill>.md` con el nombre de una skill del kit (era command, hasta v1.3.2; el resto de esa carpeta no se toca) y las skills renombradas en v1.5 (`jcc-consulta`, `jcc-auditoria`; si eran un enlace o junction, retira solo el enlace). Es idempotente; `.\skills\install.ps1 -Check` comprueba si tu copia viva ha divergido sin escribir nada. Si la política de ejecución bloquea el script: `powershell -ExecutionPolicy Bypass -File .\skills\install.ps1`. En otros sistemas basta con copiar las carpetas `skills/jcc-*` a `~/.claude/skills/` y `agents/jcc-review.md` a `~/.claude/agents/`.

- **Primer uso en un proyecto:** ábrelo y teclea `/jcc-start`. En un proyecto nuevo hace el bootstrap día-0 (bloque JCC y *Reglas operativas* en `CLAUDE.md` — conectores MCP, lectura acotada, política de push, confidencialidad si es de cliente —, `jccdocs/`, `anexos/`, portada, `.gitignore`, `git init`) con tu visto bueno; en uno ya adoptado te dice en qué estado está y qué command toca; si su bloque JCC es de una versión anterior, te ofrece `/jcc-upgrade`.

## En una pantalla

- **Cuatro fases + cierre, cada una una skill** (se invocan como slash commands, con la barra al inicio del mensaje):
  `/jcc-design` (Design → `DESIGN.md`) · `/jcc-spec` (→ `SPEC.md`) · `/jcc-implement` (código) · `/jcc-review` (revisión adversarial independiente) · `/jcc-handoff` (cierre de sesión).
- **Cuatro herramientas fuera del workflow y una de mantenimiento:** `/jcc-start` (el vestíbulo: detecta el estado del proyecto y te ofrece el command que toca) · `/jcc-analysis` (deliberar el QUÉ con rastro) · `/jcc-query` (leer la documentación como historia) · `/jcc-audit` (auditoría independiente de la documentación) · `/jcc-upgrade` (migrar un proyecto al canon vigente). Diez commands.
- **Perfil por fase como fuente única de modelo y effort:** hoy Fable 5.1 `high` en las sesiones y Opus 5 `high` como revisor, que corre como subagente con la definición de agente `agents/jcc-review.md` (otra familia de modelo que quien implementó: la diversidad de revisor es el argumento). Cada command de fase lleva una copia etiquetada del perfil de su fase y la verifica al arrancar; la tabla es la fuente y un cambio en ella arrastra las copias.
- **CC copiloto:** conoce el marco vía un bloque fino en el `CLAUDE.md` del proyecto (plantilla en el documento; la escribe `/jcc-start`), avisa en las transiciones de fase y ofrece el command que toca; nunca bloquea — el usuario decide.
- **Los tres hogares (+ índice global), todos bajo `jccdocs/`** para que la documentación no se degrade:
  - **estado vivo** → línea *"Fase actual"* de `CLAUDE.md` (corta, se sobrescribe; una por work item activo);
  - **mapa** → `README.md` de cada work item (Epic, Feature o Analysis);
  - **historia con evidencia** → los `HANDOFF_yyyymmdd_<slug>.md` de cada work item (en un Epic, `handoffs/`);
  - **puerta de entrada** → `jccdocs/README.md` (índice global de work items del proyecto).

## URL estable del documento

Para referenciar la metodología desde el `CLAUDE.md` de un proyecto (o para que un agente la consulte en sesión):

```
https://raw.githubusercontent.com/Xenix-Solutions/jcc-metodologia-claude-code/main/docs/JCC_Metodologia.md
```

## Versionado

- La **versión** vive dentro del documento, no en el nombre del fichero. El bloque JCC de cada proyecto lleva su propia línea de versión (`Bloque JCC vX.Y`); `/jcc-start` la compara con la del kit instalado y `/jcc-upgrade` la migra.
- Los **patches** (p. ej. `v1.5 → v1.5.1`) son ajustes que no tocan el núcleo (fases, hogares, gate, contrato de pares, estructura) y se registran en la sección *Estado del documento*.
- Las instrucciones de las skills atadas a un modelo concreto van etiquetadas como **calibración perecedera** (`calibración vX.Y para <modelo>; revisar al cambiar de modelo`): son lo primero que se audita en cada transición de modelo.

## Licencia

[MIT](LICENSE).
