---
name: jcc-implement
description: "JCC Fase 3 — Implementation: construir según el SPEC (Explorar→Planificar→Codificar→Commit)"
argument-hint: "[opcional: ruta al SPEC o a la carpeta del work item]"
disable-model-invocation: true
---

Esta fase implementa el trabajo ya especificado (Fase 3, Implementation, de la metodología JCC).
Lee, en este orden: CLAUDE.md (si existe, es el contrato del proyecto) y el/los SPEC (tu
contrato para este trabajo; si el mensaje trae una ruta detrás del command, empieza por ella). Puedes consultar DESIGN.md para el porqué, pero si el SPEC lo
contradice, manda el SPEC.

RESULTADO DE ESTA FASE: código que cumple el SPEC, con la verificación del SPEC (y la regresión,
si había código) ejecutada y su evidencia REAL puesta delante de mí; CLAUDE.md al día si el
trabajo alteró el contrato del proyecto; commit(s) con mensaje descriptivo. Lo que NO hace esta
fase: no implementa a espaldas del SPEC; no añade features, refactors ni abstracciones que el
SPEC no exija (lo que veas de paso —un bug ajeno, una mejora— se reporta como seguimiento, no se
arregla en este cambio salvo que lo pedido no funcione sin ello); no convierte scripts de
comprobación de usar-y-tirar en tests permanentes (commitea tests solo donde el SPEC los pide o
la zona ya los tiene, al tamaño de los vecinos).

ANTES DE NADA, dime en una línea modelo y effort activos — el effort lo inyecta el sistema en este
texto: `${CLAUDE_EFFORT}` — y contrástalos con la tabla "Perfil por fase" de la metodología
(Implementation = sesión, `claude-fable-5-1`, `high`; copia del perfil vigente, calibración v1.5
— si la tabla cambia, cambia esta línea). Si no coinciden, señálalo: el effort se elige al abrir
(cambiarlo a mitad desplaza la calibración y, según el proveedor, invalida la caché). No
bloquees: dilo y sigue.

Sigue el ciclo Explorar → Planificar → Codificar → Commit:

1. EXPLORAR y PLANIFICAR (en plan mode, sin escribir todavía): propón un plan por pasos. Agrupa
   en un mismo turno las lecturas y comprobaciones que no dependan unas de otras (calibración
   v1.5 para Fable 5.1 — tiende a una llamada por turno donde varias caben; revisar al cambiar de
   modelo). Si el proyecto AÚN NO tiene CLAUDE.md (raro tras el bootstrap de `/jcc-start`, pero
   posible en código heredado), dilo y ofrece `/jcc-start` antes de seguir; si prefiero seguir,
   incluye como primer paso crearlo sembrado desde el SPEC (stack, estructura, comandos de
   build/test/lint, reglas permanentes —entre ellas tests para la lógica no trivial—) más el
   bloque JCC copiado de la plantilla de `~/.claude/skills/jcc-start/SKILL.md`, nunca de memoria.
   Si hay código existente, el plan debe decir
   EXPLÍCITAMENTE cómo preserva lo listado en "Qué se PRESERVA". Preséntame el plan y espera mi
   visto bueno.

2. CODIFICAR (tras mi aprobación): implementa siguiendo el plan y el SPEC. Si hay código
   existente, imita los patrones y convenciones que ya hay; no introduzcas un estilo nuevo. Edita
   de forma DIRIGIDA: cuando una edición local basta, no reescribas el fichero entero (calibración
   v1.5 para Fable 5.1 — tiende a reescribir ficheros completos; revisar al cambiar de modelo). Si
   hay migración de datos, hazla idempotente (re-ejecutarla no duplica ni corrompe) y reversible
   si es posible.

3. PUERTA DE VERIFICACIÓN (formulación activa — calibración v1.5 para Fable 5.1; revisar al
   cambiar de modelo; la justificación vive en el doc, *Estado del documento*):
   ejecuta la verificación del SPEC y, si había código existente, la regresión; no declares
   nada "hecho" sin mostrarme evidencia REAL de que ambas pasan (salida de comando, no resumen).
   Si algo falla o se saltó, dilo tal cual. Tests nuevos SOLO si el SPEC los pidió para esta
   zona y no existen; si no los pidió, no los crees (si crees que faltan, repórtalo como
   seguimiento).

4. CIERRE: con la verificación en verde, actualiza CLAUDE.md si el trabajo alteró el contrato del
   proyecto (nuevas dependencias, comandos, arquitectura). Al actualizarlo, recorre el fichero
   COMPLETO y elimina o corrige lo que este cambio deja obsoleto — actualizar es también borrar:
   dos verdades temporales conviviendo en CLAUDE.md envenenan todas las sesiones futuras. Luego
   commit con mensaje descriptivo (inicializa git si el proyecto aún no lo está). SIN push ni PR
   salvo que la política de push escrita en las Reglas operativas de CLAUDE.md lo permita; si no
   hay política escrita, propón el push/PR y no lo ejecutes. Si durante la fase Claude Code
   cambió de modelo por fallback del clasificador, dilo en el mensaje del commit.

COHERENCIA SI LA REALIDAD CAMBIA EL DISEÑO: si al implementar surge un cambio sobre lo diseñado
y es ESTRUCTURAL (modelo de datos, abstracciones, contratos, stack) o condiciona el futuro,
NO lo absorbas: súbelo a la mesa común con tu recomendación. En todo caso, registra el cambio
como ADDENDUM FECHADO en DESIGN.md y enmienda o crea el SPEC afectado, para que el rastro de
auditoría no mienta. No implementes a espaldas del SPEC. El ADDENDUM registra la decisión y su
porqué; la EVIDENCIA de ejecución va al handoff, no al DESIGN (la evidencia vive una sola vez).

AL CERRAR LA FASE (higiene documental JCC; se EJECUTA, no se ofrece): (1) si creaste documentos
(p. ej. un RUNBOOK) o un ADDENDUM, regístralos/actualízalos en el README del work item; (2)
SOBRESCRIBE la sub-viñeta de ESTE work item en "Fase actual" de CLAUDE.md (una por work item
activo; las de los demás no se tocan) — SOLO los campos del puntero (work item · fase ·
siguiente command · enlaces al README, al último handoff y al índice global `jccdocs/README.md`
— los que existan; no fabriques documentos solo para enlazarlos); edítala con EDICIÓN DIRIGIDA —
toca solo esa sección, no reescribas CLAUDE.md entero (calibración v1.5 para Fable 5.1 — tiende a
reescribir ficheros completos; revisar al cambiar de modelo); PROHIBIDO añadir contenido nuevo A
ESTA LÍNEA (el resto de CLAUDE.md se actualiza según el paso 4): el detalle técnico vive en el
código y sus documentos, los pendientes durables en el `### Backlog`, y lo demás espera a
`/jcc-handoff`. Lo que NO bloqueas es el avance de fase: la decisión de avanzar es mía. La
siguiente fase es SIEMPRE la Review, una por pasada de implementación: ofréceme lanzarla como
subagente con la definición de agente del kit (`jcc-review`: `claude-opus-5`, `high`, otra
familia que esta sesión; nunca un fork; copia del perfil vigente, calibración v1.5 — si la tabla
cambia, cambia esta línea) o, si quiero verla en directo, abrir sesión aparte con
`/jcc-review` al inicio del mensaje y el contexto detrás: la instrucción de arranque ES el
comando.

MENSAJE DE LANZAMIENTO DEL REVISOR (si elijo subagente, lo compones tú: la skill `jcc-review` no
está en tu contexto, la lee el agente). Contiene exactamente: (1) la(s) ruta(s) del/los SPEC
revisados; (2) la carpeta del work item, donde escribirá `REVIEW.md` (o `REVIEW-NN_<slug>.md` si
ya hay una pasada anterior) y registrará su fila en el README del work item, creándolo si no
existe; (3) si había código existente (sí/no) y dónde está la superficie de regresión ("Qué se
PRESERVA" del SPEC); (4) si es RE-REVIEW de un fix: qué hallazgos se arreglaron y en qué commits,
y que el resultado va como sección fechada aditiva al `REVIEW.md` original (FIX = corrige
hallazgos sin cambiar el SPEC; si el SPEC cambió o hay código nuevo fuera de los hallazgos, es
NUEVA PASADA → `REVIEW-NN_` nuevo, y el punto (2) lo dice); (5) si durante esta
fase Claude Code cambió de modelo por fallback automático del clasificador (avisa en la sesión;
deja la sesión en Opus 4.8), dilo aquí y anótalo también en el mensaje del commit: el revisor
Opus 5 dejaría de ser "otra familia". Nada más: ni tu evidencia ni tu opinión sobre el código —
el revisor no debe darlas por buenas.

TRAS EL VEREDICTO (lo hace esta sesión, la orquestadora; el revisor tiene prohibido tocar los
hogares): SOBRESCRIBE la sub-viñeta de este work item en "Fase actual" con el resultado — work item · Review
· veredicto (limpio, o con hallazgos abiertos) · siguiente command (`/jcc-implement <ruta al
REVIEW>` para los fixes; si está limpio, `/jcc-handoff` para cerrar) · enlaces. El estado
"cerrado" del work item NO lo escribes tú: lo escribe `/jcc-handoff` en el índice global cuando
el veredicto limpio está registrado y el merge/PR resuelto (o cuando yo lo decida
explícitamente, anotado en el handoff).
