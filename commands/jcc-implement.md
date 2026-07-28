---
description: "JCC Fase 3 — Implementación: construir según el SPEC (Explorar→Planificar→Codificar→Commit)"
---

Esta fase implementa el trabajo ya especificado (Fase 3 de la metodología JCC). Lee, en este
orden: CLAUDE.md (si existe, es el contrato del proyecto) y el/los SPEC (tu contrato para este
trabajo). Puedes consultar DESIGN.md para el porqué, pero si el SPEC lo contradice, manda el SPEC.

ANTES DE NADA (calibración v1.2.2 para Opus 5; revisar al cambiar de modelo), dime en una línea
el effort activo (${CLAUDE_EFFORT}). La pauta vigente: sesión en `high`; la profundidad extra
para lanzar la codificación la pone `ultrathink` en el turno de aprobación, no un cambio de
effort — cambiarlo a mitad de sesión obliga a releer toda la conversación sin caché. Solo si esta
fase arranca en sesión fresca dedicada, `xhigh` elegido al abrirla es alternativa válida. No
bloquees: dilo y sigue.

Sigue el ciclo Explorar → Planificar → Codificar → Commit:

1. EXPLORAR y PLANIFICAR (en plan mode, sin escribir todavía): propón un plan por pasos. Si el
   proyecto AÚN NO tiene CLAUDE.md (producto nuevo), incluye como primer paso crearlo sembrado
   desde el SPEC (stack, estructura, comandos de build/test/lint, reglas permanentes —entre
   ellas tests para la lógica no trivial— y el bloque JCC de metodología). Si hay código
   existente, el plan debe decir EXPLÍCITAMENTE cómo preserva lo listado en "Qué se PRESERVA".
   Preséntame el plan y espera mi visto bueno. Al pedírmelo, si el cambio es multi-fichero o de
   varias horas, recuérdame que mi mensaje de aprobación puede llevar `ultrathink`: da máxima
   profundidad al turno que lanza la codificación sin tocar el effort ni la caché.

2. CODIFICAR (tras mi aprobación): implementa siguiendo el plan y el SPEC. Si hay código
   existente, imita los patrones y convenciones que ya hay; no introduzcas un estilo nuevo. Si
   hay migración de datos, hazla idempotente (re-ejecutarla no duplica ni corrompe) y reversible
   si es posible.

3. PUERTA DE VERIFICACIÓN: no declares nada "hecho" sin mostrarme evidencia REAL de que la
   verificación del SPEC pasa y, si había código existente, de que la regresión sigue verde.
   Cómo y cuándo verificar lo decides tú; lo que esta puerta exige es que la evidencia llegue a
   la mesa. Si la zona no tenía tests, créalos.

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
README, al último handoff y al índice global); PROHIBIDO añadirle contenido nuevo: el detalle
técnico vive en el código y sus documentos, los pendientes durables en el `### Backlog`, y lo
demás espera a `/jcc-handoff`. No bloquees.
