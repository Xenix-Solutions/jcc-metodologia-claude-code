---
name: jcc-upgrade
description: "JCC Upgrade — migra un proyecto al canon vigente de la metodología (bloque JCC, esquema jccdocs/, naming de lo activo, punteros): lee, compara, propone el plan y lo ejecuta con visto bueno y commit propio. Nunca auto-ejecuta"
argument-hint: "[vacío = este proyecto, plan completo | 'solo plan' | 'solo bloque' | ruta a otro proyecto]"
disable-model-invocation: true
---

Quiero poner este proyecto al día con el canon vigente de la metodología JCC. Esto es
mantenimiento, no una fase: no avanza fases ni toca el contenido de ningún artefacto; mueve,
renombra, repunta y reescribe el bloque JCC — y todo eso solo tras mi visto bueno sobre un plan
concreto. Alcance pedido (puede venir vacío):

$ARGUMENTS

VERSIÓN DEL CANON QUE APLICA ESTE COMMAND: **v1.5.3** (esquema `jccdocs/`, ontología Epic /
Feature / Analysis, naming `yyyymmdd_<tipo>_<slug>/`, bloque JCC v1.5.3 cuya plantilla lleva
`/jcc-start`: léela en `~/.claude/skills/jcc-start/SKILL.md`; es copia de la del doc de metodología y,
si difieren, manda el doc). Comparación local, sin red.

RESULTADO: el proyecto en canon v1.5.3 — bloque JCC v1.5.3 en `CLAUDE.md`, documentación metodológica
bajo `jccdocs/` con la geometría interna intacta, work items ACTIVOS con nombre canónico, punteros
de frontera repuntados, portada ≠ mapa — en UN commit propio, sin push, con un informe de lo que
se movió y de lo que deliberadamente NO se tocó. Lo que NO hace este command: no reescribe fotos
(HANDOFF, REVIEW, BRIEF, AUDIT), no renombra work items cerrados, no edita el contenido de
"Fase actual" ni del Backlog más allá de repuntar enlaces, no pushea.

Antes de nada, dime en una línea modelo y effort activos (`${CLAUDE_EFFORT}`) y contrástalos con
la tabla "Perfil por fase" (Upgrade = sesión, `claude-fable-5-1`, `high`; copia del perfil vigente,
calibración v1.5 — si la tabla cambia, cambia esta línea); si no coinciden, señálalo y sigue.

0. PRECONDICIÓN: `git status` limpio. Si hay cambios sin commitear, PARA y pídeme que los
   commitee o los guarde (`git stash`): el `git mv` masivo y el commit propio de la migración
   arrastrarían trabajo ajeno, y si la sesión muere a medias el árbol quedaría medio migrado sin
   forma limpia de volver.

1. LEER EL ESTADO (solo lectura). `CLAUDE.md`: ¿hay bloque JCC?, ¿qué versión declara (línea
   `Bloque JCC vX.Y[.Z]`; ausente = pre-v1.5)?, ¿qué dice "Fase actual"?, ¿hay `### Backlog` y reglas
   propias del proyecto que deben sobrevivir?, ¿hay sección `## Reglas operativas (INVIOLABLES)`? Contenedor: ¿`docs/cambios/`, `docs/`, raíz,
   `jccdocs/`? Work items: cuáles hay, cuáles están ACTIVOS (Fase actual + índice global + `git
   log`) y cuáles cerrados; cuáles son cambios planos (→ Feature), programas (→ Epic) y ciclos
   (→ `feature-NN_`). Punteros: qué enlaces cruzan la frontera del contenedor (desde `CLAUDE.md`,
   la portada, el índice global, hacia fuera del contenedor). Política de push del proyecto
   (`permissions.ask`, reglas en `CLAUDE.md`). Si `docs/` mezcla metodología con material del
   operador, sepáralo en la lectura: lo segundo es candidato a `anexos/`.

2. COMPARAR CON EL CANON v1.5.3 y listarme las diferencias, una por línea, cada una con su regla
   (un bloque `v1.5`, `v1.5.1` o `v1.5.2` es desfasado SOLO en el bloque: plantilla vieja, mismo esquema;
   el alcance natural es "solo bloque"):
   contenedor único `jccdocs/` (muere `docs/cambios/` y "producto nuevo → raíz"); work items
   colgando directos de `jccdocs/`; naming `yyyymmdd_<epic|feature|analysis>_<slug>/` en raíz y
   `feature-NN_<slug>/` dentro de un Epic; un proyecto que es un solo Epic va TAMBIÉN en carpeta de
   Epic; Feature = carpeta plana sin `handoffs/`; Epic = `handoffs/` único en su raíz; nombres que
   empiezan por letra reservados para estructura; portada mínima en la raíz y mapa en
   `jccdocs/README.md`; `anexos/` para lo no metodológico; bloque JCC v1.5.3 con línea de versión,
   detección de command, lectores y copiloto con los 10 commands; sección `## Reglas operativas
   (INVIOLABLES)` con sus líneas fijas (conectores MCP, lectura acotada, política de push;
   confidencialidad si es de cliente); índice global con columna Merge/PR; `.gitignore` de medios.

3. PLAN DE MIGRACIÓN (receta P2: subárbol completo). Preséntamelo como tabla y espera mi visto
   bueno; nada se ejecuta antes:
   - QUÉ SE MUEVE: el contenedor completo con `git mv` (p. ej. `docs/cambios/*` → `jccdocs/`),
     preservando la geometría relativa interna — así las fotos fechadas no necesitan edición.
   - QUÉ SE RENOMBRA: SOLO los work items ACTIVOS, al canon (`AAAAMMDD_<slug>/` →
     `yyyymmdd_feature_<slug>/`; programa → `yyyymmdd_epic_<slug>/`; `ciclo-N-<slug>/` →
     `feature-NN_<slug>/`). Los cerrados conservan nombre y enlaces: renombrar historia cerrada es
     riesgo sin beneficio. Lístalos aparte como "no se tocan".
   - QUÉ SE REPUNTA: solo los enlaces que cruzan la frontera (los de `CLAUDE.md`, la portada, el
     índice global y los que, desde dentro del contenedor, apuntaban fuera). Los enlaces internos
     relativos siguen valiendo por construcción; verifícalo, no lo supongas.
   - QUÉ SE REESCRIBE: la sección `## Metodología (JCC)` de `CLAUDE.md` con la plantilla v1.5.3, con
     EDICIÓN DIRIGIDA — solo esa sección; conserva el contenido actual de "Fase actual" (repuntado)
     y el `### Backlog`. Las reglas propias del proyecto NO las decides tú: lista en la tabla CADA
     línea de la sección actual que no esté en la plantilla y pregúntame, una a una, si se conserva
     (y dónde: en el bloque, en Reglas operativas, en otra sección de CLAUDE.md) o se retira. La
     línea `Bloque JCC v1.5.3` la escribes tú, atómicamente, en ese mismo cambio. Si el bloque era
     anterior a v1.5.3 (cualquier versión, incluida la ausencia de línea), convierte el puntero
     actual de "Fase actual" en la sub-viñeta de su work item y pon el recuento en la línea padre
     (`**Fase actual:** 1 activo`; "ninguno; …" si no hay trabajo activo).
   - QUÉ SE CREA si falta: la sección `## Reglas operativas (INVIOLABLES)` (pregúntame las
     respuestas: conectores MCP, rutas externas, política de push, ¿cliente?), `jccdocs/README.md`
     (mapa, con la columna Merge/PR; si el proyecto no tenía índice global, constrúyelo desde los
     work items reales), portada mínima, `anexos/` (con lo que salga de `docs/` que no sea
     metodología, con mi visto bueno pieza a pieza), `.gitignore` de medios.
   - LO AMBIGUO (¿esto se relee o se ejecuta?, ¿este cambio está activo o cerrado?, ¿este
     `docs/` es material o metodología?) va a la tabla como pregunta, no como decisión tuya.

4. EJECUTAR (tras mi visto bueno, en este orden): `git mv` del subárbol → renombrados de lo activo
   → repunte de enlaces de frontera → bloque JCC → creaciones. Edita de forma dirigida; no
   reescribas ficheros enteros para cambiar un enlace.

5. VERIFICAR Y CERRAR: comprueba que todos los enlaces relativos de `CLAUDE.md`, la portada,
   `jccdocs/README.md` y los READMEs de los work items activos resuelven a fichero existente
   (lístame los rotos, si los hay, y arréglalos antes de commitear). Los enlaces desde FOTOS
   (HANDOFF, REVIEW, BRIEF, AUDIT) hacia lo renombrado quedan rotos por diseño — las fotos no se
   editan —: lístalos en el informe y en la cabecera de `jccdocs/README.md` como "rotos
   aceptados" (con el nombre nuevo al lado), para que `jcc-audit` los trate como informativo.
   Comprueba que `git status` solo muestra
   renombrados y los ficheros previstos; que la línea `Bloque JCC v1.5.3` está. Un commit propio
   ("jcc-upgrade: migración a JCC v1.5.3 — <qué se movió>"). SIN push: recuérdame la política de
   push del proyecto y déjalo en mis manos. Añade en la cabecera de `jccdocs/README.md` una línea
   "Migrado a JCC v1.5.3 el yyyy-mm-dd con `/jcc-upgrade`". Repórtame: qué se movió, qué se
   renombró, qué NO se tocó y por qué, y recomiéndame `/jcc-audit` (capa 1) como comprobación
   independiente si la migración fue grande. Si llevo un censo del parque, recuérdame actualizar
   su fila.

CASOS QUE YA CONOCEMOS: proyecto que era un único programa suelto en la raíz de `jccdocs/`
(DESIGN transversal + `handoffs/` + `ciclo-N/`) → se mete entero en `jccdocs/yyyymmdd_epic_<slug>/`
y el ciclo activo pasa a `feature-NN_<slug>/`. Proyecto con `docs/cambios/` y varios cambios
planos, uno activo → subárbol a `jccdocs/`, solo el activo se renombra a `yyyymmdd_feature_`.
Proyecto sin índice global (pre-v1.2) → se construye `jccdocs/README.md` desde disco. Proyecto
sin bloque JCC en absoluto → eso no es upgrade, es día-0: ofrece `/jcc-start`.

Si el argumento dice "solo plan", para tras el paso 3. Si dice "solo bloque", limita el plan a la
sección de `CLAUDE.md` (y su línea de versión). Si es una ruta a otro proyecto, trabaja allí con
las mismas reglas (la lectura acotada lo permite porque la ruta te la doy yo; si este proyecto es
de cliente y la ruta parece de OTRO cliente, párate y pregúntame).
