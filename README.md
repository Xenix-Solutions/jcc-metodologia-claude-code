# Metodología JCC — Agentic Dev con Claude Code

Metodología de desarrollo con **Claude Code (CC)**: un solo flujo para producto nuevo o cambios sobre código existente, mediante análisis conjunto entre pares que lleva al mejor diseño y lo ejecuta con control, con CC operando como **copiloto** consciente del marco.

Este repositorio es la **publicación de la versión vigente**: el documento de la metodología, las skills (los prompts de fase y las herramientas auxiliares, invocadas como slash commands) y su instalador. La evolución (histórico, debates de diseño, versiones archivadas) vive en un repositorio privado; aquí llega cada versión liberada.

## 👉 Empieza aquí

- **Documento de la metodología:** [`docs/JCC_Metodologia.md`](docs/JCC_Metodologia.md). La versión vigente está declarada **dentro del documento** (cabecera y *Estado del documento*); el nombre del fichero es deliberadamente estable para que los enlaces y URLs no caduquen entre versiones.
- **Instalación de las skills** (Windows / PowerShell):

```powershell
git clone https://github.com/Xenix-Solutions/jcc-metodologia-claude-code
cd jcc-metodologia-claude-code
.\skills\install.ps1
```

El script copia cada `skills/<nombre>/SKILL.md` a `~/.claude/skills/` (ámbito de usuario: disponibles en todos tus proyectos) y retira las copias legacy `~/.claude/commands/jcc-*.md` de la era command (hasta v1.3.2). Es idempotente; `.\skills\install.ps1 -Check` comprueba si tu copia viva ha divergido sin escribir nada. En otros sistemas basta con copiar las carpetas `skills/jcc-*` a `~/.claude/skills/`.

## En una pantalla

- **Cuatro fases + cierre, cada una una skill** (se invocan como slash commands):
  `/jcc-design` (análisis conjunto → `DESIGN.md`) · `/jcc-spec` (→ `SPEC.md`) · `/jcc-implement` (código) · `/jcc-review` (revisión adversarial independiente) · `/jcc-handoff` (cierre de sesión).
- **Dos herramientas auxiliares fuera del ciclo:** `/jcc-consulta` (leer la documentación como historia: orientación, historia de un cambio, brief para cliente) · `/jcc-auditoria` (auditoría independiente y adversarial de la documentación).
- **CC copiloto:** conoce el marco vía un bloque fino en el `CLAUDE.md` del proyecto (plantilla en el documento), avisa en las transiciones de fase y ofrece el command que toca; nunca bloquea — el usuario decide.
- **Los tres hogares (+ índice global)** para que la documentación no se degrade:
  - **estado vivo** → línea *"Fase actual"* de `CLAUDE.md` (corta, se sobrescribe);
  - **mapa** → `README.md` de cada cambio;
  - **historia con evidencia** → los `HANDOFF` de cada cambio (en programas, `handoffs/`);
  - **puerta de entrada** → `docs/cambios/README.md` (índice global de cambios del proyecto).

## URL estable del documento

Para referenciar la metodología desde el `CLAUDE.md` de un proyecto (o para que un agente la consulte en sesión):

```
https://raw.githubusercontent.com/Xenix-Solutions/jcc-metodologia-claude-code/main/docs/JCC_Metodologia.md
```

## Versionado

- La **versión** vive dentro del documento, no en el nombre del fichero.
- Los **patches** (p. ej. `v1.2.1 → v1.2.2`) son ajustes que no tocan el núcleo (fases, hogares, gate, contrato de pares, estructura) y se registran en la sección *Estado del documento*.
- Las instrucciones de las skills atadas a un modelo concreto van etiquetadas como **calibración perecedera** (`calibración vX.Y.Z para <modelo>; revisar al cambiar de modelo`): son lo primero que se audita en cada transición de modelo.

## Licencia

[MIT](LICENSE).
