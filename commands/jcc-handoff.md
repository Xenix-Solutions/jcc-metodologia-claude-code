---
description: "JCC Cierre de sesión — handoff fechado + índices al día + Fase actual como puntero corto + recordar memoria"
---

Voy a cerrar esta sesión para abrir otra fresca (control de la ventana de contexto). Ejecuta el
cierre de la metodología JCC (v1.3) ordenando los HOGARES. Hazlo con cuidado de NO perder
información.

MODELO (tres hogares + índice global + backlog):
- CLAUDE.md "Fase actual"  = estado vivo, CORTO, se SOBRESCRIBE (nunca acumula historia).
- README del cambio        = mapa/índice de los documentos de ese cambio.
- handoffs/HANDOFF-<fecha>  = fotos fechadas con evidencia (ahí vive la historia; la evidencia
  vive UNA sola vez, aquí — DESIGN/README/índices enlazan, no duplican).
- docs/cambios/README.md    = índice GLOBAL de todos los cambios; AUTORITATIVO para el estado
  de merge/PR (el handoff es foto pre-merge y no se reedita).
- CLAUDE.md "### Backlog"   = pendientes DURABLES (decidido no-ahora), una línea cada uno;
  curado: se PODA lo hecho o caducado.

1. HANDOFF (la foto fechada). Escribe la bitácora de cierre del trabajo en curso:
   - Ubicación: **cambio plano** → `HANDOFF.md` (o `HANDOFF-AAAA-MM-DD.md` fechados si son varias
     sesiones) EN LA CARPETA del cambio, junto al DESIGN/SPEC — **sin subcarpeta `handoffs/`**.
     **Programa** → un ÚNICO `handoffs/` en la RAÍZ del programa (nunca por ciclo), aunque la sesión
     se centrara en un ciclo concreto.
   - Contenido: cabecera **"Estado metodológico"** (fase actual · siguiente command · restricciones
     activas que no se pueden saltar · evidencia del estado: qué artefactos existen y en qué estado)
     + qué se hizo + qué se verificó CON EVIDENCIA REAL (no "hecho" a secas) + cómo retomar.
   - Describe el estado **AL CERRAR**, no un estado futuro que aún no ha ocurrido (si algo está sin
     commitear o con el merge/PR pendiente, dilo como tal: el handoff es foto pre-merge; el estado
     definitivo de merge lo lleva el índice global).
   - La evidencia de ejecución se escribe UNA sola vez, aquí. Si un DESIGN o README la necesita,
     que enlace a este handoff; no la dupliques.

2. PRESERVAR ANTES DE RECORTAR. Recorre lo que hoy hay en "Fase actual" de CLAUDE.md: cualquier
   hecho durable (cierres, veredictos de review, commits/deploys, gotchas, pendientes) que SOLO viva
   ahí, muévelo primero a su handoff o al README del cambio. Solo entonces recortes.

3. SOBRESCRIBIR "Fase actual" en CLAUDE.md con un PUNTERO CORTO que contenga solo: cambio/ciclo
   activo · fase · siguiente command · enlaces al README del cambio y a su último handoff · enlace
   al índice global docs/cambios/README.md. Si no queda trabajo activo, dilo ("ninguno; el siguiente
   arranca con /jcc-design o /jcc-spec"). NADA de cambios ya cerrados en esta línea. Si el proyecto
   no tiene aún el bloque JCC, propónmelo y créalo con mi visto bueno.

4. ÍNDICES. Actualiza el README del cambio (documentos creados esta sesión) y el índice global
   docs/cambios/README.md (estado del cambio: activo/cerrado, Y el estado de merge/PR si lo hay —
   si el merge queda para después del cierre, el índice lo dice y la reconciliación de la próxima
   sesión lo pondrá al día). Créalos si no existen y el trabajo lo pide (programa, o cambio que ya
   pasa de ~4 documentos).

5. BACKLOG, MEMORIA Y PENDIENTES. Los pendientes DURABLES (decidido no-ahora: endurecimientos,
   deudas conscientes, decisiones diferidas) van al `### Backlog` de CLAUDE.md, una línea cada uno,
   PODANDO a la vez lo hecho o caducado (su historia ya vive en los handoffs); créalo si no existe
   y hay pendientes. Los pendientes de simple continuidad van al handoff, no al Backlog. Recuérdame
   actualizar tu memoria del proyecto y lo pendiente (commit/push, notas). Marca las decisiones
   tomadas "en caliente" al final para releerlas en frío.

LONGITUD DEL HANDOFF (calibración v1.2.1 para Opus 5; revisar al cambiar de modelo): ajústala a lo que hubo en la sesión — cubre la sustancia y la evidencia, sin
relleno ni resúmenes redundantes. Es una foto para poder retomar, no un informe.

Antes de escribir, dime en una línea cuál crees que es la fase actual y por qué (contrastada con los
artefactos del repo), para que lo confirme. Si el estado real no cuadra con lo que declaraba
CLAUDE.md, dilo. Al terminar, repórtame: qué información moviste y a dónde, el nuevo texto de "Fase
actual", y que los índices quedan al día.
