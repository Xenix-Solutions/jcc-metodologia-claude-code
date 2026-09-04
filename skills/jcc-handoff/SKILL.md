---
name: jcc-handoff
description: "JCC Cierre de sesión — handoff fechado + índices al día + Fase actual como puntero corto + backlog, memoria y /usage"
disable-model-invocation: true
---

Voy a cerrar esta sesión para abrir otra fresca (control de la ventana de contexto). Ejecuta el
cierre de la metodología JCC ordenando los HOGARES. Hazlo con cuidado de NO perder
información.

RESULTADO DEL CIERRE: una foto fechada (el handoff) con la que un humano o una sesión que no
estuvo puede retomar el trabajo; los mapas vivos (README del work item, índice global, "Fase
actual", Backlog) al día y coherentes con ella; nada durable que solo viviera en la conversación
o en "Fase actual". Lo que NO hace el cierre: no avanza fases, no reedita fotos anteriores, no
genera prompts de arranque aparte.

MODELO (tres hogares + índice global + backlog):
- CLAUDE.md "Fase actual"  = estado vivo, CORTO, se SOBRESCRIBE (nunca acumula historia).
- README del work item     = mapa/índice de los documentos de ese Feature o Epic.
- HANDOFF(s) fechados       = fotos fechadas con evidencia; su UBICACIÓN la fija el paso 1 según
  sea Feature o Epic (ahí vive la historia; la evidencia vive UNA sola vez, aquí — DESIGN/README/
  índices enlazan, no duplican).
- jccdocs/README.md         = índice GLOBAL de todos los work items; AUTORITATIVO para el estado
  de merge/PR (el handoff es foto pre-merge y no se reedita). Se refresca aquí, en el handoff,
  no en los cierres de fase.
- CLAUDE.md "### Backlog"   = pendientes DURABLES (decidido no-ahora), una línea cada uno;
  curado: se PODA lo hecho o caducado.

1. HANDOFF (la foto fechada). Escribe la bitácora de cierre del trabajo en curso:
   - Ubicación: **Feature** → `HANDOFF_yyyymmdd_<slug>.md` EN LA CARPETA del Feature, junto al
     DESIGN/SPEC — **sin subcarpeta `handoffs/`**, aunque sean varias sesiones (se fechan y
     conviven). **Epic** → el ÚNICO `handoffs/` en la RAÍZ del Epic (nunca por Feature), aunque
     la sesión se centrara en un `feature-NN_` concreto. Los handoffs existentes con nombres
     anteriores no se renombran.
   - Contenido: cabecera **"Estado metodológico"** (fase actual · siguiente command · restricciones
     activas que no se pueden saltar · evidencia del estado: qué artefactos existen y en qué estado)
     + qué se hizo + qué se verificó CON EVIDENCIA REAL (no "hecho" a secas) + **qué pasó en qué
     orden**: hipótesis corregidas y caminos descartados, en secuencia, legible por quien no estuvo
     (es el único sitio donde queda el hilo temporal) + **linaje de los recursos operativos** que
     nombres (BDs, entornos, despliegues: de dónde salió cada uno, de qué commit o copia) + cómo
     retomar.
   - Describe el estado **AL CERRAR**, no un estado futuro que aún no ha ocurrido (si algo está sin
     commitear o con el merge/PR pendiente, dilo como tal: el handoff es foto pre-merge; el estado
     definitivo de merge lo lleva el índice global).
   - La evidencia de ejecución se escribe UNA sola vez, aquí. Si un DESIGN o README la necesita,
     que enlace a este handoff; no la dupliques.
   - Si este cierre es CON SUCESOR (otra persona o un lector externo retoma), ofréceme además un
     dossier narrativo (`BRIEF_yyyymmdd_<slug>.md`) generado ahora, mientras la conversación vive:
     después ya no se puede reconstruir con la misma fidelidad.

2. PRESERVAR ANTES DE RECORTAR. Recorre lo que hoy hay en "Fase actual" de CLAUDE.md: cualquier
   hecho durable (cierres, veredictos de review, commits/deploys, gotchas, pendientes) que SOLO viva
   ahí, muévelo primero a su handoff o al README del work item. Solo entonces recortes.

3. BACKPORT DE CORRECCIONES. Recorre lo descubierto o corregido en esta sesión: si algo contradice
   la documentación VIGENTE, haz el BARRIDO COMPLETO — enmienda TODOS los documentos vigentes que
   la corrección contradiga (DESIGNs, SPECs, READMEs, el propio CLAUDE.md), no solo el primero que
   encuentres (ADDENDUM fechado, o corrección directa si es el contrato de CLAUDE.md), antes de
   cerrar. Un backport parcial deja dos verdades temporales conviviendo, y una sesión futura
   obedecerá al documento equivocado. ENMIENDA ADITIVA: si lo impreciso es un handoff propio aún
   vigente, no reescribas su cuerpo — añádele una nota fechada al final y backportea solo a los
   documentos vigentes que contradiga; los documentos cuyas cifras eran ciertas para su fecha son
   fotos y NO se tocan.

4. SOBRESCRIBIR "Fase actual" en CLAUDE.md con un PUNTERO CORTO — con EDICIÓN DIRIGIDA: toca solo
   esa sección, no reescribas CLAUDE.md entero (calibración v1.5 para Fable 5.1 — tiende a
   reescribir ficheros completos; revisar al cambiar de modelo) — que contenga solo: work item
   activo · fase · siguiente command CON LA BARRA AL INICIO (la instrucción de arranque ES el
   comando: `/jcc-<fase>` y el contexto detrás, en el mismo mensaje) · enlaces al README del work
   item y a su último handoff · enlace al índice global `jccdocs/README.md` (enlaza los que
   existan; no fabriques documentos solo para enlazarlos). Si no queda trabajo activo, dilo
   ("ninguno; el siguiente arranca con `/jcc-design`, `/jcc-analysis` o `/jcc-start`"). NADA de
   trabajos ya cerrados en esta línea. Si el proyecto no tiene aún el bloque JCC, o lo tiene de
   una versión anterior, dilo y ofréceme `/jcc-start` / `/jcc-upgrade` para la próxima apertura
   (o créalo ahora con la plantilla del doc, con mi visto bueno).

5. ÍNDICES. Actualiza el README del work item (documentos creados esta sesión) y el índice global
   `jccdocs/README.md` (estado del work item: activo/cerrado, Y el estado de merge/PR si lo hay —
   si el merge queda para después del cierre, el índice lo dice y la reconciliación de la próxima
   sesión lo pondrá al día). Créalos si no existen y el trabajo lo pide (Epic, o Feature que ya
   pasa de ~4 documentos).

6. BACKLOG, MEMORIA, `/usage` Y PENDIENTES. Los pendientes DURABLES (decidido no-ahora:
   endurecimientos, deudas conscientes, decisiones diferidas) van al `### Backlog` de CLAUDE.md,
   una línea cada uno, PODANDO a la vez lo hecho o caducado (su historia ya vive en los handoffs);
   créalo si no existe y hay pendientes. Los pendientes de simple continuidad van al handoff, no al
   Backlog. Pídeme que ejecute `/usage` y anota en el handoff una línea con los números (ritual de
   la metodología: es la telemetría con la que se deciden las palancas de coste). Recuérdame
   actualizar tu memoria del proyecto y lo pendiente (commit/push según la política del proyecto,
   notas). En la memoria del proyecto, deja (si no está ya) el apunte-RECETA de arranque — una
   receta estática, no una foto del estado: "al arrancar, sigue los punteros: índice global →
   README del work item activo → último handoff, y contrasta con git log". Una foto caduca si una
   sesión muere sin handoff; la receta no. Marca las decisiones tomadas "en caliente" al final para
   releerlas en frío.

ESTE HANDOFF ES LA INSTRUCCIÓN DE ARRANQUE de la siguiente sesión — no generes prompts de
arranque aparte: la sesión siguiente arranca con el command de su fase al inicio del mensaje y la
reconciliación de apertura lee el resto.

LONGITUD DEL HANDOFF (calibración v1.5 para Fable 5.1, vale también en Opus 5; revisar al cambiar de modelo): cubre la
sustancia y la evidencia recortando RELLENO, no conectivas ni contexto. El criterio es la
RELECTURA HUMANA: quien retome (humano o sesión) tiene que entenderlo de corrido, sin descifrar
telegramas. Es una foto para poder retomar, no un informe — ni un acertijo.

Antes de escribir, dime en una línea cuál crees que es la fase actual y por qué (contrastada con los
artefactos del repo), para que lo confirme. Si el estado real no cuadra con lo que declaraba
CLAUDE.md, dilo. Al terminar, repórtame: qué información moviste y a dónde, el nuevo texto de "Fase
actual", y que los índices quedan al día.
