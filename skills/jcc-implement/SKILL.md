---
name: jcc-implement
description: "JCC Fase 3 — Implementación: construir según el SPEC (Explorar→Planificar→Codificar→Commit)"
disable-model-invocation: true
---

Esta fase implementa el trabajo ya especificado (Fase 3 de la metodología JCC). Lee, en este
orden: CLAUDE.md (si existe, es el contrato del proyecto) y el/los SPEC (tu contrato para este
trabajo). Puedes consultar DESIGN.md para el porqué, pero si el SPEC lo contradice, manda el SPEC.

ANTES DE NADA (calibración v1.3.2 para Opus 4.8; revisar al cambiar de modelo), dime en una línea
el effort activo (${CLAUDE_EFFORT}). La pauta vigente: `xhigh` como estándar de sesión — no se
cambia a mitad (obliga a releer toda la conversación sin caché; se elige al abrir). No
bloquees: dilo y sigue.

Sigue el ciclo Explorar → Planificar → Codificar → Commit:

1. EXPLORAR y PLANIFICAR (en plan mode, sin escribir todavía): propón un plan por pasos. Si el
   proyecto AÚN NO tiene CLAUDE.md (producto nuevo), incluye como primer paso crearlo sembrado
   desde el SPEC (stack, estructura, comandos de build/test/lint, reglas permanentes —entre
   ellas tests para la lógica no trivial— y el bloque JCC de metodología). Si hay código
   existente, el plan debe decir EXPLÍCITAMENTE cómo preserva lo listado en "Qué se PRESERVA".
   Preséntame el plan y espera mi visto bueno.

2. CODIFICAR (tras mi aprobación): implementa siguiendo el plan y el SPEC. Si hay código
   existente, imita los patrones y convenciones que ya hay; no introduzcas un estilo nuevo. Si
   hay migración de datos, hazla idempotente (re-ejecutarla no duplica ni corrompe) y reversible
   si es posible.

3. PUERTA DE VERIFICACIÓN (formulación activa — calibración v1.3.2 para Opus 4.8; con Opus 5
   se reformula a solo-reporte, porque instruir la verificación le causa sobre-verificación):
   ejecuta la verificación del SPEC y, si había código existente, la regresión; no declares
   nada "hecho" sin mostrarme evidencia REAL de que ambas pasan. Si la zona no tenía tests,
   créalos.

4. CIERRE: con la verificación en verde, actualiza CLAUDE.md si el trabajo alteró el contrato del
   proyecto (nuevas dependencias, comandos, arquitectura). Al actualizarlo, recorre el fichero
   COMPLETO y elimina o corrige lo que este cambio deja obsoleto — actualizar es también borrar:
   dos verdades temporales conviviendo en CLAUDE.md envenenan todas las sesiones futuras. Luego
   commit con mensaje descriptivo (inicializa git si el proyecto aún no lo está). PR si procede.

COHERENCIA SI LA REALIDAD CAMBIA EL DISEÑO: si al implementar surge un cambio sobre lo diseñado
y es ESTRUCTURAL (modelo de datos, abstracciones, contratos, stack) o condiciona el futuro,
NO lo absorbas: súbelo a la mesa común con tu recomendación. En todo caso, registra el cambio
como ADDENDUM FECHADO en DESIGN.md y enmienda o crea el SPEC afectado, para que el rastro de
auditoría no mienta. No implementes a espaldas del SPEC. El ADDENDUM registra la decisión y su
porqué; la EVIDENCIA de ejecución va al handoff, no al DESIGN (la evidencia vive una sola vez).

AL CERRAR LA FASE (higiene documental JCC): (1) si creaste documentos (p. ej. un RUNBOOK) o
un ADDENDUM, regístralos/actualízalos en el README del cambio; (2) SOBRESCRIBE la línea "Fase actual" de
CLAUDE.md — SOLO los campos del puntero (cambio/ciclo · fase · siguiente command · enlaces al
README, al último handoff y al índice global — los que existan; no fabriques documentos solo para
enlazarlos); PROHIBIDO añadir contenido nuevo A ESTA LÍNEA
(el resto de CLAUDE.md se actualiza según el paso 4): el detalle técnico vive en el código y sus
documentos, los pendientes durables en el `### Backlog`, y lo demás espera a `/jcc-handoff`.
Esta higiene se EJECUTA, no se ofrece; lo que NO bloqueas es el avance de fase: ofréceme el
command siguiente y la decisión de avanzar es mía.
