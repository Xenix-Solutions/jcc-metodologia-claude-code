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
- CLAUDE.md "Fase actual"  = estado vivo: una sub-viñeta CORTA por work item activo (la línea
  padre lleva el recuento); cada una se SOBRESCRIBE (nunca acumula historia).
- README del work item     = mapa/índice de los documentos de ese Feature, Epic o Analysis standalone.
- HANDOFF(s) fechados       = fotos fechadas con evidencia; su UBICACIÓN la fija el paso 1 según
  sea Feature o Epic (ahí vive la historia; la evidencia vive UNA sola vez, aquí — DESIGN/README/
  índices enlazan, no duplican).
- jccdocs/README.md         = índice GLOBAL de todos los work items (o el índice equivalente que
  el proyecto YA tenga, si aún no migró a `jccdocs/`); AUTORITATIVO para el estado de merge/PR
  (el handoff es foto pre-merge y no se reedita). Se refresca aquí, en el handoff, no en los
  cierres de fase.
- CLAUDE.md "### Backlog"   = pendientes DURABLES (decidido no-ahora), una línea cada uno;
  curado: se PODA lo hecho o caducado.

1. HANDOFF (la foto fechada). Escribe la bitácora de cierre del trabajo en curso:
   - Ubicación: **Feature** → `HANDOFF_yyyymmdd_<slug>.md` EN LA CARPETA del Feature, junto al
     DESIGN/SPEC — **sin subcarpeta `handoffs/`**, aunque sean varias sesiones (se fechan y
     conviven). **Epic** → el ÚNICO `handoffs/` en la RAÍZ del Epic (nunca por Feature), aunque
     la sesión se centrara en un `feature-NN_` concreto (excepción: los HANDOFF anteriores a una
     promoción a Epic se quedan en su `feature-NN_`, son fotos; están listados como aceptados en la
     cabecera del índice global). **Analysis standalone** → en su carpeta
     `yyyymmdd_analysis_<slug>/`. Los handoffs existentes con nombres anteriores no se renombran.
     En un proyecto SIN MIGRAR (documentación fuera de `jccdocs/`), el HANDOFF va en la carpeta que
     el proyecto ya usa para ese work item, con el nombre canónico `HANDOFF_yyyymmdd_<slug>.md`:
     las fotos anteriores conservan el suyo y `/jcc-upgrade` no las renombrará.
     El `<slug>` del handoff es el TEMA de la sesión, no el de la carpeta; dos cierres el mismo
     día llevan slugs distintos.
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

4. SOBRESCRIBIR en "Fase actual" de CLAUDE.md la SUB-VIÑETA DE ESTE WORK ITEM con un PUNTERO
   CORTO — "Fase actual" lleva una sub-viñeta por work item activo; las de los demás work items
   NO se tocan — con EDICIÓN DIRIGIDA: toca solo esa sub-viñeta, no reescribas CLAUDE.md entero
   (calibración v1.5 para Fable 5.1 — tiende a reescribir ficheros completos; revisar al cambiar
   de modelo). Contenido: work item · fase · siguiente command CON LA BARRA AL INICIO (la
   instrucción de arranque ES el comando: `/jcc-<fase>` y el contexto detrás, en el mismo
   mensaje) · enlaces al README del work item y a su último handoff · enlace al índice global
   `jccdocs/README.md` (enlaza los que existan; no fabriques documentos solo para enlazarlos). Si
   este cierre CIERRA el work item, borra solo su sub-viñeta y resta uno al recuento de la línea
   padre (`**Fase actual:** N activo(s)`); si era la última, la línea padre vuelve a "ninguno; el
   siguiente arranca con `/jcc-design`, `/jcc-analysis` o `/jcc-start`". NADA de
   trabajos ya cerrados en "Fase actual". Si el proyecto no tiene aún el bloque JCC, o lo tiene de
   una versión anterior, dilo y ofréceme `/jcc-start` / `/jcc-upgrade` para la próxima apertura
   (o créalo ahora con la plantilla del doc, con mi visto bueno).

5. ÍNDICES. Actualiza el README del work item (documentos creados esta sesión) y el índice global
   `jccdocs/README.md`: columna Estado (activo | cerrado; CERRADO = veredicto limpio registrado
   en un REVIEW y merge/PR resuelto, o decisión mía explícita anotada en este handoff — si es por
   decisión, la fila cita el handoff; para un Analysis standalone, cerrado = bifurcación tomada y
   registrada en `ANALYSIS.md`) y columna Merge/PR con valor cerrado (`—` sin PR previsto ·
   `PR #n abierto` · `mergeado yyyy-mm-dd` · `commit directo`); si el merge queda para después
   del cierre, el índice lo dice y la reconciliación de la próxima sesión lo pondrá al día.
   Créalos si no existen: el README del work item es obligatorio desde que hay un HANDOFF (regla
   única del doc, también en un Analysis standalone); el índice global también, SALVO que el
   proyecto no esté en canon (bloque sin línea de versión, o documentación metodológica fuera de
   `jccdocs/`, p. ej. `docs/cambios/`): entonces actualiza el índice que el proyecto YA tenga, NO
   crees `jccdocs/README.md` (sería un segundo contenedor) y recuérdame `/jcc-upgrade`.

6. BACKLOG, MEMORIA, `/usage` Y PENDIENTES. Los pendientes DURABLES (decidido no-ahora:
   endurecimientos, deudas conscientes, decisiones diferidas) van al `### Backlog` de CLAUDE.md,
   una línea cada uno, PODANDO a la vez lo hecho o caducado (su historia ya vive en los handoffs);
   créalo si no existe y hay pendientes. Los pendientes de simple continuidad van al handoff, no al
   Backlog. Pídeme que ejecute `/usage` y que te pegue la salida (la ve el operador, no tú) y anota en el handoff una línea con los números (ritual de la metodología: es la telemetría con
   la que se deciden las palancas de coste). Propón el COMMIT del handoff y de los hogares AHORA
   (sin push salvo que la política de push escrita en las Reglas operativas lo permita): sin
   commit, quien clone no verá ni el handoff ni la nueva "Fase actual". Recuérdame actualizar tu
   memoria del proyecto — la memoria automática de Claude Code (ficheros por proyecto bajo
   `~/.claude/projects/`, cargados al abrir sesión), NO un fichero del repo ni CLAUDE.md; si tu
   sesión no la tiene, omite este punto — y lo pendiente (notas). En la memoria del proyecto,
   deja (si no está ya) el apunte-RECETA de arranque — una
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
