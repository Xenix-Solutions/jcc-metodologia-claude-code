# JCC — Agentic Dev Methodology

> **Versión:** v1.3 (2026-07-27)
> **Tipo:** documento vivo y operativo — **"invoca y avanza"**.
> **Para qué:** desarrollar con Claude Code (CC) un producto nuevo o un cambio sobre código existente, mediante un análisis conjunto que lleva al mejor diseño y luego lo ejecuta con control.
> **Para quién:** cualquiera del equipo. No necesitas leerte la teoría; mira el gate, y si entras, recorre las fases invocando su command. CC mantiene la documentación al día para que cualquiera —tú, un compañero o una sesión nueva— sepa, leyendo un índice, qué hay y dónde.

---

## Idea de fondo (30 segundos)

- **Un solo flujo** para producto nuevo y para cambios sobre código existente. El "sabor" (greenfield / brownfield) lo **autodetecta CC** preguntándose *¿hay código que respetar?* — tú no clasificas nada por adelantado.
- **Análisis conjunto entre pares.** CC es el especialista técnico; tú decides estrategia, alcance y restricciones. Las decisiones **irreversibles o que condicionan el futuro** se deciden en la **mesa común**, no las absorbe CC en silencio.
- **La profundidad la fija el análisis, no una etiqueta previa.** La entrevista se agota rápido en lo simple y profundiza en lo complejo.
- **El artefacto es el puente de contexto.** Cada fase deja un documento (`DESIGN.md`, `SPEC.md`, código) que permite continuar sin arrastrar la conversación.
- **Cada fase es un command.** Los prompts de fase viven en **slash commands globales** (`/jcc-design`, `/jcc-spec`, `/jcc-implement`, `/jcc-review`, `/jcc-handoff`). Un toque en vez de un copy-paste.
- **CC opera consciente del marco (copiloto).** Sabe en qué fase estás, te avisa en las transiciones y te ofrece el command que toca. Tú decides; él nunca bloquea.
- **Cada cosa tiene un hogar** (novedad v1.2). El estado vivo, el mapa de la documentación y la historia con evidencia viven en sitios distintos y no se mezclan. CC los mantiene al día. (Ver *Los tres hogares*.)

---

## Modelo y effort (recomendación)

La metodología **no depende de un modelo concreto**: las fases, los hogares y el contrato de pares funcionan igual con cualquiera. Lo de abajo es la recomendación **vigente a la fecha de esta versión**, no un requisito.

- **Se recomienda Opus 5 en todas las fases.** Es, a fecha de esta versión (julio de 2026), el modelo que mejor encaja con lo que esta metodología hace: coding agentic, trabajo multi-fichero de horizonte largo y revisión de código, al precio de la gama Opus. **Nada impide usar otro** — Fable 5 si necesitas el techo de capacidad, o uno más económico en las fases mecánicas.
- **La palanca de coste es el effort, no el modelo.** `high` —el default— como estándar de sesión: a effort más alto el modelo delibera de más en los turnos conversacionales (entrevista, spec) y se percibe torpe. La profundidad extra para **lanzar una implementación grande** (multi-fichero, del orden de más de 30 minutos) la pone **`ultrathink`** en el turno de aprobación del plan: máxima profundidad en el turno que importa **sin cambiar el effort enviado y por tanto sin invalidar la caché**. Los commands `/jcc-design` y `/jcc-implement` recuerdan esta pauta al arrancar, para que no dependa de la memoria del operador. **`xhigh`** queda para quien abra la implementación en **sesión fresca dedicada** (se elige al abrir, nunca a mitad). La Fase 4 mantiene la precisión a effort bajo: la revisión no necesita `xhigh`.
- **No toques el dial a mitad de sesión.** El effort forma parte de la clave de caché: el turno siguiente reprocesaría toda la conversación sin un solo acierto. Elige al abrir. Además el nivel **persiste entre sesiones** una vez fijado y la escala está **calibrada por modelo**, así que comprueba `/effort` al arrancar si vienes de otra fase o de otro modelo.
- **Capa de calibración etiquetada** (novedad v1.3). Toda instrucción de los commands atada a un modelo concreto lleva la etiqueta **`calibración vX.Y para <modelo>; revisar al cambiar de modelo`**. En una transición de modelo, la auditoría de migración es acotada: recorrer las etiquetas, probar a quitar cada una, y conservar solo las que el modelo nuevo siga necesitando. Las fases, los hogares y el contrato de pares no llevan etiqueta porque no caducan.
- **Este bloque es lo primero que caduca del documento.** Es el único apartado atado a un modelo concreto: si lo estás leyendo y ya existe una generación posterior a Opus 5, trátalo como **pendiente de revisar**, no como vigente. Lo que hay que rehacer entonces es la recomendación de modelo, el mapa de effort (los niveles disponibles y su rendimiento cambian de un modelo a otro) y las calibraciones de comportamiento de los commands. Las fases no se tocan.

---

## ¿Merece metodología? (gate único)

Lo único que se decide antes de analizar, y es barato y reversible:

- **¿Es trivial?** Lo describes en una frase, toca un punto localizado y no ves riesgo de romper nada (p. ej. cambiar un color) → **directo a CC**, sin esto (en plan mode si quieres).
- **¿Hay algo que analizar / alguna duda?** → **entra en la metodología**, y empieza **siempre** por la entrevista (`/jcc-design`). No hay carriles ni clasificación de tamaño: de eso ya se encarga la propia entrevista.

Si al explorar un caso "trivial" resulta que tenía más miga, súbelo a la metodología. El coste de equivocarse en este gate es mínimo.

---

## Los tres hogares (+ índice global)

La lección del uso real (4 proyectos, muchas iteraciones): cuando no hay un sitio claro para cada tipo de información, **todo se apila en el sitio que CC lee siempre (`CLAUDE.md`)** y la "Fase actual" degenera en un changelog interminable. La v1.2 lo arregla dando **tres hogares** con comportamientos distintos, más un índice global:

| Rol | Hogar | Comportamiento |
|---|---|---|
| **Estado vivo** — qué está activo AHORA | línea **"Fase actual"** en `CLAUDE.md` | **corto**, se **SOBRESCRIBE** en cada transición; **nunca acumula** |
| **Mapa / índice** — qué documentos existen y dónde | **`README.md` del cambio** | durable; **crece** al crear cada documento |
| **Historia + evidencia** — qué pasó cada sesión | **`HANDOFF`(s) del cambio** (en su carpeta; en un programa, agrupados en `handoffs/`) | fechado; **se acumula** (uno por sesión de cierre) |
| **Puerta de entrada** — todos los cambios del proyecto | **`docs/cambios/README.md`** (índice global) | tabla estable de navegación; una fila por cambio; **autoritativo para el estado de merge/PR** |
| **Backlog** — pendientes durables (decidido no-ahora) *(novedad v1.3)* | sección **`### Backlog`** de `CLAUDE.md` | **curado**: una línea por pendiente; **se poda** — lo hecho o caducado se borra (su historia ya vive en los handoffs) |

Regla mental que lo resume: **la "Fase actual" es un puntero, no un diario.** Si te descubres pegando historia en `CLAUDE.md`, va al handoff. Si describes qué documentos hay, va al README. Los tres hogares se sostienen mutuamente: porque el README carga el mapa y los handoffs cargan la historia, la "Fase actual" puede por fin ser tres líneas.

Dos reglas anejas (v1.3, de la evidencia de las adopciones):

- **El backlog tampoco es un diario.** Ahí entra solo lo durable que se decidió *no hacer ahora* (endurecimientos, deudas conscientes, decisiones diferidas). Los pendientes de simple continuidad ("retomar por X") van al handoff. Al añadir, **poda**: cada entrada hecha o caducada se borra de la lista.
- **El handoff es una foto pre-merge.** El merge/PR suele ocurrir después de cerrar la sesión, así que el handoff dice honestamente "PR abierto" y ahí se queda (es una foto fechada). El **estado definitivo de merge vive en el índice global**, y la **reconciliación de apertura** de la siguiente sesión lo actualiza si el merge ya ocurrió. Así se mata el "estado mentiroso" recurrente de índices que declaran PRs abiertos ya mergeados.

---

## Precondición: el bloque JCC en `CLAUDE.md`

`CLAUDE.md` (raíz del proyecto, lo lee CC en cada sesión) es el **ancla por-proyecto**. No alberga la metodología (eso vive solo en este doc); alberga un **bloque fino** con el estado vivo y el contrato de copiloto.

> **Proyectos con código existente** deben tener `CLAUDE.md`. Si no existe, créalo con `/init` + curación. **Productos nuevos** lo crean en la fase de Implementación. En ambos casos, añádele este bloque:

```markdown
## Metodología (JCC)

Este proyecto se desarrolla con la metodología JCC. Doc (URL estable, consultable en sesión):
https://raw.githubusercontent.com/Xenix-Solutions/jcc-metodologia-claude-code/main/docs/JCC_Metodologia.md

- **Fase actual:** <puntero CORTO al trabajo ACTIVO>. Contiene solo: cambio/ciclo activo · fase ·
  siguiente command · enlace al README del cambio y a su último handoff · enlace al índice global
  `docs/cambios/README.md`. Si no hay trabajo activo: "ninguno; el siguiente arranca con `/jcc-design`
  o `/jcc-spec`". **Esta línea se SOBRESCRIBE en cada transición; NUNCA acumula historia.**
- **Operas como COPILOTO.** En las transiciones de fase, recuerda y ofrece el command que toca
  (`/jcc-design`, `/jcc-spec`, `/jcc-implement`, `/jcc-review`); **no bloquees**, el usuario decide.
  Las decisiones **estructurales o difíciles de revertir** van a la **mesa común**: no las absorbas.
  **Mantienes la documentación al día sin que te lo pidan**: sobrescribes "Fase actual" (la historia
  va a los HANDOFF + índice global, NO a esta línea), y registras cada documento nuevo en el README del cambio.
  **Ajustas la longitud de cada documento a lo que el trabajo pide**: cubre la sustancia, sin secciones
  de relleno, resúmenes redundantes ni boilerplate.
- **Las convenciones JCC no se improvisan.** Si una situación documental (dónde vive un documento,
  cómo se llama, qué hogar le toca) no está cubierta por lo que tienes en contexto, **consulta el
  doc de arriba** antes de fijar una convención; si no puedes acceder, es decisión de **mesa común**.
- **Reconciliación al arrancar.** Contrasta la "Fase actual" con los artefactos reales del repo
  (¿qué SPEC existen?, ¿qué está implementado/verificado?). Si no cuadran, **dilo**. Si el índice
  global declara un merge/PR pendiente que ya ocurrió, **actualízalo**: el handoff es foto pre-merge;
  el estado definitivo de merge vive en el índice global.
- **`### Backlog`** (sección aparte de este fichero; existe solo si hay pendientes durables): una
  línea por pendiente decidido no-ahora; **se poda** — lo hecho o caducado se borra (su historia ya
  vive en los handoffs).
```

---

## Cómo opera CC (copiloto)

Contrato de comportamiento transversal. La causa de los fallos del pasado fue que la metodología —y luego la propia documentación— vivía fuera de un sitio con reglas claras.

- **Copiloto, no guardia.** CC conoce el marco y la fase actual. En cada **transición** te lo recuerda y te ofrece el command. **Nunca bloquea.**
- **Reconciliación en apertura (automática, no es un command).** Al abrir una sesión fresca, CC contrasta la "Fase actual" con los artefactos del disco y **canta la discrepancia** si no cuadran. Es la defensa contra el "estado mentiroso".
- **Higiene documental (novedad v1.2).** CC mantiene los tres hogares al día por su cuenta: **sobrescribe** "Fase actual" (no la engorda), **registra en el README del cambio** cada documento que crea, y al cerrar **escribe el handoff y actualiza el índice global**. Los handoffs describen el estado **al cerrar**, no un estado futuro que aún no ha ocurrido. **La evidencia de ejecución se escribe una sola vez, en el handoff** (novedad v1.3): DESIGN, README e índices **enlazan** a ella, no la duplican — dos copias de una evidencia viva divergen.
- **Autoridad de la metodología (novedad v1.3).** Las convenciones JCC no se improvisan: ante una situación documental no cubierta por el contexto, CC **consulta el doc de metodología** (URL estable del bloque JCC) antes de fijar una convención; si no puede acceder, la trata como decisión de **mesa común**. Origen: un agente fijó por criterio propio una convención de handoffs contraria a la metodología —el doc era inalcanzable en la práctica— y hubo que deshacerla un día después con seis documentos que reapuntar.
- **Contrato de pares.** Ante una decisión irreversible o que condiciona el futuro, CC la **sube a la mesa común** con su recomendación. Lo reversible y local lo decide y lo reporta.
- **Regresión = parte de la definición de hecho.** En código existente, *"no romper lo que ya iba"* no es un extra.
- **Regla de oro:** lo **deliberado** (avanzar de fase, cerrar sesión) es un **command** que invocas tú; lo **automático** (saber el marco, reconciliar, mantener la documentación) vive en `CLAUDE.md` y ocurre sin que teclees nada.

---

## Estructura de `docs/cambios/`: cambio vs. programa, y convenciones

La estructura **depende del trabajo**; por eso esto son **convenciones que escalan**, no reglas rígidas. Un cambio de tres ficheros no lleva README ni carpeta de handoffs; un programa multi-ciclo sí. Si una convención te obliga a burocracia en algo pequeño, es señal de que te has pasado.

### Dos tamaños de trabajo

- **Cambio (plano):** una carpeta `docs/cambios/AAAAMMDD_<slug>/` con sus artefactos JCC directamente dentro (DESIGN, SPEC(s), REVIEW y el/los HANDOFF) — **sin subcarpetas**. La carpeta `handoffs/` NO se usa aquí, aunque el cambio dure varias sesiones (los handoff se fechan y conviven en la carpeta).
- **Programa (multi-ciclo):** cuando el trabajo se descompone en varios ciclos, cada uno con su propio DESIGN/SPEC. La carpeta del programa contiene documentos **transversales** + un `README.md` (mapa) + `handoffs/` + una **subcarpeta por ciclo** `ciclo-N-<slug>/` con los artefactos JCC de ese ciclo. **En un programa, TODOS los handoffs —incluidos los de sesiones centradas en un ciclo— van a un único `handoffs/` en la raíz del programa, nunca repartidos por `ciclo-N/`**: es la línea de tiempo única del programa (los ciclos que cruza una sesión no caben en una sola carpeta de ciclo). Cada `ciclo-N/` guarda sus DESIGN/SPEC/REVIEW; la localidad "qué handoff es de qué ciclo" la da el README, no la ubicación del fichero.
- **Cuándo promover plano→programa: ANTES de escribir el segundo DESIGN, no después** (afinado en v1.3). El disparador salta en `/jcc-design`, en el momento en que el DESIGN que se va a escribir sería el segundo de una carpeta plana: ahí promover cuesta minutos. Retroactivamente —con varios DESIGN apilados y trabajo hecho— mover ficheros arriesga el rastro y suele acabar en "no tocar y taparlo con el README". No apiles `DESIGN-02/03/04` en plano: eso es un programa pidiendo subcarpetas.

### Nombres canónicos

| Artefacto | Nombre | Notas |
|---|---|---|
| Carpeta de cambio | `AAAAMMDD_<slug>/` | fecha de inicio + slug corto |
| Diseño | `DESIGN.md` | uno por cambio/ciclo; cambios acordados al implementar → **ADDENDUM fechado** dentro |
| Especificación | `SPEC.md` **o** `SPEC-NN_<slug>.md` | monolítico si es indivisible; modular si el DESIGN se descompuso |
| Revisión adversarial | `REVIEW.md` | salida de la fase 4; en cambios pequeños puede ir como sección del handoff |
| Cierre de sesión | `HANDOFF.md` (o `HANDOFF-AAAA-MM-DD.md`) | **cambio plano:** en la carpeta del cambio, junto al DESIGN/SPEC — uno solo si es de una sesión, o fechados si son varias; **sin subcarpeta**. **Programa:** en `handoffs/` (ver *Programa*) |
| Índice del cambio | `README.md` | mapa de los documentos de ese cambio; obligatorio en programas, opcional en cambios triviales |
| Índice global | `docs/cambios/README.md` | tabla de todos los cambios del proyecto |

### Artefactos de apoyo (lista abierta)

El trabajo real produce más que DESIGN/SPEC. Se reconocen como legítimos, con convención de nombre `TIPO_<slug>.md` (mayúsculas), usados **según haga falta**:

- `BRIEF_<slug>.md` — material de partida (de negocio, de un tercero, para una herramienta de diseño).
- `INVESTIGACION_<slug>.md` — investigación/spike que alimenta una decisión.
- `RUNBOOK_<slug>.md` — pasos de operación (cutover, provisión, migración manual).
- `DESIGN-SYSTEM_<slug>.md` — sistema de diseño destilado (tokens, componentes).
- `eval/` — banco de evaluación (golden, prompts, salidas) cuando se afinan prompts o se comparan modelos.

Todos se registran en el README del cambio; ninguno es obligatorio.

### El README del cambio (el índice que pediste)

El README de un cambio/programa es su **mapa autodescriptivo**, para que cualquier sesión nueva —y cualquier humano— sepa qué hay leyendo un solo documento. Contiene:

- Qué es el cambio en una frase, y si es cambio o programa.
- La convención de layout de esa carpeta (para no confundir ejes de numeración, etc.).
- **Índice de documentos** existentes, agrupado por fase/ciclo, con una línea de qué es cada uno.
- Si es programa: **tabla de ciclos con estado**.
- Puntero al estado vivo (`CLAUDE.md`) y a los handoffs.

CC lo **actualiza al crear cada documento** y lo consolida en el cierre. No duplica el estado vivo (eso es de `CLAUDE.md`) ni la historia con evidencia (eso es de los handoffs): el README es el **mapa**, no el diario ni el marcador.

### El índice global `docs/cambios/README.md`

Puerta de entrada al árbol de cambios del proyecto. Tabla: **fecha · slug · qué es (1 línea) · tipo (cambio | programa) · estado (activo | cerrado) · enlaces** (a la carpeta y a su README/handoff). Cabecera que fija la jerarquía (estado vivo en `CLAUDE.md`; doc por carpeta; historia en handoffs). CC añade una fila al **abrir** un cambio nuevo y actualiza el estado al **cerrar**. Especialmente valioso con varios cambios en vuelo y con más de una persona en el equipo.

**Es además el autoritativo del estado de merge/PR** (novedad v1.3): como el merge suele ocurrir después de cerrar la sesión, el handoff queda como foto pre-merge honesta ("PR abierto") y no se reedita; el estado definitivo se refleja aquí, y la **reconciliación de apertura** de la siguiente sesión lo pone al día si el merge ya ocurrió.

---

## Las fases (+ cierre)

Cada fase **describe** su objetivo y deja un artefacto; el **prompt operativo vive en su command** (global, `~/.claude/commands/jcc-*.md`). El estado y los índices son locales al proyecto.

> **Respaldo de los commands.** La copia versionada vive en [`commands/`](../commands/) de este repo y es la **fuente de verdad**. En una máquina nueva, instálalos con `commands\install.ps1`; `commands\install.ps1 -Check` te dice si la copia viva y la del repo han divergido.

| Fase | Command | Objetivo | Artefacto | Puerta |
|---|---|---|---|---|
| **1. Análisis** | `/jcc-design` | Diseñar juntos | `DESIGN.md` | (si hay código) confirmas que entendió + apruebas el diseño |
| **2. Especificación** | `/jcc-spec` | Diseño → spec técnico | `SPEC.md` (uno o varios) | apruebas las decisiones (sobre todo las estructurales) + el spec |
| **3. Implementación** | `/jcc-implement` | Construir según el spec | código + `CLAUDE.md` | apruebas el plan + verificación real |
| **4. Revisión adversarial** | `/jcc-review` | Refutar que cumple y no rompe | `REVIEW.md` + veredicto | bucle 3↔4 hasta veredicto limpio |
| **Cierre de sesión** | `/jcc-handoff` | Traspasar estado técnico **y** metodológico | handoff + índices + estado en `CLAUDE.md` | tú disparas el cierre |

**Ubicación:** producto nuevo → `DESIGN.md` y `SPEC.md` en la raíz. Cambio sobre código existente → `docs/cambios/AAAAMMDD_<slug>/` (o estructura de programa si aplica).

En cada fase, además de su artefacto, CC **registra el documento creado en el README del cambio** y, al avanzar, **sobrescribe** la "Fase actual" de `CLAUDE.md`.

---

### Fase 1 — Análisis (entrevista socrática) → `DESIGN.md`

- **Command:** `/jcc-design` (tu descripción va como argumento, o pégala/dícta­la a continuación).
- **Objetivo:** llegar al mejor diseño mediante un análisis conjunto entre pares, y plasmarlo en `DESIGN.md`.
- **Sesión/modo:** sesión **nueva**, **plan mode**, **Opus**. La entrevista es de solo lectura; tu visto bueno escribe `DESIGN.md`.
- **Cómo funciona:** (1) orientación sobre el código existente si lo hay, hasta que confirmes que CC entendió la zona y la superficie de regresión; (2) entrevista socrática abierta por tandas cortas, `AskUserQuestion` solo para cerrar forks acotados, profundidad ajustada al cambio; si ve que son **varios cambios**, propone trocearlos (esto puede indicar un **programa**); si el DESIGN que va a escribir sería el **segundo de una carpeta plana**, propone la promoción a programa **antes de escribirlo** (v1.3); (3) con tu visto bueno, escribe `DESIGN.md` y lo registra en el README del cambio.
- **Puerta humana:** si hubo orientación, confirmas que CC entendió la zona; luego apruebas `DESIGN.md`.

> **Ojo al destilado.** Si tu descripción viene destilada de un dictado, puede traer ruido que no detectaste. La entrevista socrática es la red: si el destilado mintió, las contradicciones afloran al entrevistarte — pero solo si la fase corre de verdad.

---

### Fase 2 — Especificación → `SPEC.md`

- **Command:** `/jcc-spec` (lee `DESIGN.md`; no pegas nada).
- **Objetivo:** convertir `DESIGN.md` en una especificación técnica autocontenida. CC decide el stack (producto nuevo) o especifica el delta dentro del stack dado (código existente).
- **Sesión/modo:** continuar o sesión fresca, **plan mode**, **Opus**.
- **Granularidad (guía, no regla):** **sigue la descomposición que el DESIGN ya encontró.** Descompuesto → varios `SPEC-NN_<slug>.md`, cada uno autocontenido y trazado a su decisión de DESIGN; indivisible → un `SPEC.md`.
- **Contenido:** resumen; stack y arquitectura; estructura/delta (ADDED/MODIFIED/REMOVED); interfaces y contratos; **qué se PRESERVA** (regresión); migración si aplica; fuera de alcance; **verificación** end-to-end (incluida la regresión). Los apartados *Verificación* y *Qué se PRESERVA* se escriben autocontenidos, pensados para poder compilarse algún día en un catálogo de regresión.
- **Puerta humana:** apruebas las decisiones —en especial las estructurales— y el `SPEC.md`.

> Si `SPEC.md` y `DESIGN.md` se contradicen, manda `SPEC.md`.

---

### Fase 3 — Implementación → código + `CLAUDE.md`

- **Command:** `/jcc-implement` (lee `CLAUDE.md` y `SPEC.md`; no pegas nada).
- **Objetivo:** construir siguiendo el `SPEC.md`, con puerta de verificación que cierre el bucle.
- **Sesión/modo:** continuar o sesión fresca, **plan mode** para explorar/planificar, **Opus**.
- **Ciclo Explorar → Planificar → Codificar → Commit:** plan por pasos (en plan mode) que, si había código, diga EXPLÍCITAMENTE cómo preserva lo listado en "Qué se PRESERVA"; esperas tu visto bueno; codifica imitando los patrones existentes; **puerta de verificación** con evidencia REAL (y regresión verde); cierre con `CLAUDE.md` actualizado si cambió el contrato, y commit.
- **Coherencia si la realidad cambia el diseño:** cambio **estructural** → mesa común; en todo caso, **ADDENDUM fechado en `DESIGN.md`** y enmienda/creación del SPEC afectado. Así el rastro no miente.
- **Puerta humana:** apruebas el plan; **exiges evidencia real** antes de aceptar "hecho".

---

### Fase 4 — Revisión adversarial → `REVIEW.md`

- **Command:** `/jcc-review` (lee `SPEC.md`, `CLAUDE.md` y el repo).
- **Objetivo:** chequeo técnico **independiente** que intenta **refutar** que el trabajo cumple el `SPEC.md` y que no rompió nada. Es la QA independiente del proceso.
- **Sesión/modo:** **independiente obligatorio** — sesión fresca o subagente. **Opus**.
- **Qué busca, en orden:** regresión (nº1, si había código); cumplimiento del SPEC; correctitud y casos límite; que la verificación pasa de verdad; fuera de alcance tocado. No revisa estilo. Entrega `REVIEW.md`: por hallazgo (qué falla, fichero, gravedad, tipo) + veredicto claro.
- **Bucle de cierre:** los hallazgos vuelven a la Fase 3 y se re-verifica. **Itera 3↔4 hasta veredicto limpio.**

---

### Cierre de sesión → `/jcc-handoff`

- **Command:** `/jcc-handoff`. **Lo disparas tú** al cerrar una sesión para abrir otra fresca.
- **Qué hace** (funde tu ritual de cierre en un acto deliberado y ordena los tres hogares):
  1. Escribe el **handoff** (cambio plano → `HANDOFF.md` o `HANDOFF-AAAA-MM-DD.md` en la carpeta del cambio; programa → en `handoffs/`): qué se hizo, qué se verificó **con evidencia real**, y una cabecera **"Estado metodológico"** (fase · siguiente command · restricciones activas · evidencia del estado). Describe el estado **al cerrar**, no uno futuro.
  2. **Antes de recortar, preserva:** cualquier hecho durable que solo viviera en "Fase actual" se mueve a su handoff/README.
  3. **Sobrescribe** la línea "Fase actual" de `CLAUDE.md` con el puntero corto.
  4. Actualiza el **README del cambio** y el **índice global** `docs/cambios/README.md` (incluido el estado de merge/PR: si queda para después del cierre, el índice lo dice y la siguiente sesión lo reconcilia).
  5. Lleva los **pendientes durables** al `### Backlog` de `CLAUDE.md` (podándolo a la vez) y te **recuerda actualizar la memoria**.
- **Fuente de verdad:** `CLAUDE.md` = estado vivo; README = mapa; handoff = foto fechada con evidencia. No divergen por diseño.

---

## Transversal

- **Contrato de pares.** CC conduce lo técnico; tú, estrategia/alcance/restricciones. Ante lo irreversible o que condiciona el futuro, CC lo **sube a la mesa común**.
- **Regresión.** *"No romper lo que ya iba"* es parte de la definición de hecho.
- **Los tres hogares + índice global + backlog.** Estado vivo (`CLAUDE.md`, corto, se sobrescribe) · mapa (`README` del cambio) · historia (`handoffs/`) · puerta de entrada y estado de merge (`docs/cambios/README.md`) · pendientes durables (`### Backlog` de `CLAUDE.md`, curado). CC los mantiene; nunca se apila historia en `CLAUDE.md`, y la evidencia vive una sola vez (en el handoff).
- **Trazabilidad.** Cada cambio guarda su `DESIGN`/`SPEC`/`REVIEW`/`HANDOFF` en su carpeta; el índice global lista todo. Es el rastro de auditoría — valioso al no haber revisor humano, y cada vez más al crecer el equipo.
- **Sesiones.** Continúa en la misma mientras el trabajo sea corto. Sesión fresca **recomendada** cuando el contexto creció; **independiente obligatoria** solo en la revisión. Tú disparas el cierre con `/jcc-handoff`.
- **QA (no es una fase; artefacto derivado a demanda).** La metodología es regresiva por diseño: cada cambio produce su superficie de regresión (*"Qué se PRESERVA"*) y sus criterios (*"Verificación"*), y la **Fase 4** es la QA independiente. Esos apartados se pueden compilar en un catálogo de regresión cuando un gatillo real lo pida (traspaso formal, hito SaaS). Hasta entonces no se construye nada.
- **Alertador de complejidad.** Señales de que el proyecto pide disciplina formal de spec (p. ej. Spec Kit): el spec se vuelve inmanejable; dependencias cruzadas; re-explicar la arquitectura en cada sesión fresca. Sin umbral fijo; se calibra al cerrar cada trabajo.

---

## Estado del documento

- **v1.3 (2026-07-27):** cierra la cola acumulada de las adopciones v1.2 en el parque y del análisis de las guías de prompting de Opus 5/Fable 5. Núcleo intacto (fases, gate, contrato de pares); lo que cambia es la gestión documental y la mantenibilidad:
  - **Backlog canónico:** sección `### Backlog` en `CLAUDE.md`, **curada** (una línea por pendiente durable decidido no-ahora; se poda; la historia queda en los handoffs). Resuelve la divergencia observada en las adopciones: unos repos lo tenían en `CLAUDE.md`, otros en "pendientes heredados" del handoff.
  - **Estado de merge autoritativo en el índice global:** el handoff es foto pre-merge (el merge suele ocurrir tras cerrar la sesión) y no se reedita; el estado definitivo vive en `docs/cambios/README.md` y la reconciliación de apertura lo pone al día. Mata el "estado mentiroso" recurrente de PRs declarados abiertos ya mergeados.
  - **Promoción temprana a programa:** el disparador salta en `/jcc-design` **antes** de escribir el 2º DESIGN en carpeta plana (retroactivamente sale caro y suele acabar en no reestructurar).
  - **Principio de autoridad** en el bloque JCC: las convenciones no se improvisan — se consulta el doc (ahora alcanzable por **URL pública estable**, repo `jcc-metodologia-claude-code`) o van a mesa común. Origen: un agente fijó una convención de handoffs contraria a la metodología sin consultarla (el doc era inalcanzable en la práctica) y hubo que deshacerla al día siguiente.
  - **La evidencia vive una sola vez**, en el handoff; DESIGN, README e índices enlazan, no duplican (se observó la misma tabla de evidencia duplicada en DESIGN y handoff).
  - **Capa de calibración etiquetada completa:** toda instrucción de los commands atada a un modelo lleva `calibración vX.Y para <modelo>; revisar al cambiar de modelo`; la migración a un modelo nuevo se convierte en una auditoría acotada de etiquetas.
  - **Diferido conscientemente:** adelgazar los bloques de higiene repetidos en los commands — la evidencia de uso muestra que la higiene funciona con la redundancia actual; una cosa por versión.
- **v1.2.2 (2026-07-27):** ajustes tras el análisis conjunto de las guías de prompting de Opus 5/Fable 5 y el feedback de uso real del primer programa multi-ciclo del parque. (1) Reformulada la **puerta de verificación** de `/jcc-implement`: de instrucción de acción ("ejecuta la verificación…") a **requisito de reporte** ("no declares 'hecho' sin mostrar la evidencia") — la guía de Opus 5 señala que las instrucciones explícitas de verificación causan sobre-verificación; la puerta conserva su función (evidencia real en la mesa para la aprobación humana) sin prescribir cuándo ni cómo verificar. La v1.2.1 la había dejado deliberadamente intacta; el análisis la reclasificó como calibración conductual reformulable. (2) **Pauta de effort revisada**: `high` como estándar de sesión (a `xhigh` los turnos conversacionales se perciben torpes) + `ultrathink` en el turno que lanza la codificación; `xhigh` solo al abrir una sesión fresca dedicada a implementar; la Fase 4 rinde a effort bajo. (3) **Recordatorios de arranque** en `/jcc-design` (recomendación vigente de modelo/effort + effort activo + aviso de no tocar el dial a mitad de sesión) y `/jcc-implement` (recordar `ultrathink` al pedir la aprobación del plan), ambos **etiquetados como calibración perecedera** ("calibración v1.2.2 para Opus 5; revisar al cambiar de modelo") — estreno del etiquetado de la capa de calibración previsto para v1.3.
- **v1.2.1 (2026-07-25):** ajuste al modelo **Opus 5** (liberado el 2026-07-24), sin cambios en el núcleo metodológico (fases, hogares, gate, contrato y estructura siguen igual). (1) Nueva sección **Modelo y effort**, con rango propio y marcada como recomendación fechada y caducable: Opus 5 recomendado en todas las fases, `high` como estándar, `xhigh` solo al lanzar implementaciones grandes, `ultrathink` para un turno, y no tocar el dial a mitad de sesión (coste de caché). El *tiering* con un modelo más barato queda como opción abierta, no como recomendación por defecto. (2) **Calibración de longitud de los documentos**, en los commands que escriben artefactos y en el contrato de copiloto del bloque `CLAUDE.md`: Opus 5 escribe ficheros más largos que Opus 4.8, y sin freno eso reabre la degradación documental que originó la v1.2. (3) `/jcc-review`: reporta TODO con nivel de confianza —un filtro de gravedad en el prompt reduce el recall en Opus 5— y **subagente, nunca un fork** (un fork hereda la historia de quien implementó y rompe la independencia). (4) `/jcc-implement`: declara el effort activo al arrancar. (5) Los commands pasan a estar **respaldados y versionados** en `commands/` de este repo, lo que además los hace distribuibles al equipo. Lo que deliberadamente NO se tocó: la puerta de verificación de la Fase 3 (es evidencia para el humano, no auto-verificación) y la disciplina de alcance (ya la aporta el propio prompt de sistema de Claude Code).
- **v1.2 (2026-07-21):** tras 4 proyectos con muchas iteraciones. La v1.1 funcionó (copiloto, commands autoejecutados, subagente en la revisión), pero la gestión documental se degradó: la "Fase actual" se convirtió en un changelog append-only de todo el proyecto, la estructura de carpetas divergió (el artefacto de cierre llegó a tener 5 nombres), y hubo que crear un README reactivo para no perder el control. Cambios de la v1.2:
  - **Los tres hogares + índice global:** estado vivo (`CLAUDE.md`, corto, **se sobrescribe**), mapa (`README` por cambio), historia (`handoffs/`), puerta de entrada (`docs/cambios/README.md`). Resuelve de un tiro la "Fase actual" inflada y la pérdida de control documental.
  - **Estructura declarada:** cambio (plano) vs. programa (multi-ciclo con subcarpetas `ciclo-N-<slug>/`); nombres canónicos (**`HANDOFF`** para el cierre); artefactos de apoyo reconocidos (`BRIEF`/`INVESTIGACION`/`RUNBOOK`/`DESIGN-SYSTEM`/`eval/`). Todo como **convenciones que escalan**, sin rigidez para lo pequeño.
  - **El README pasa a ser elemento central:** mapa autodescriptivo que CC mantiene al crear cada documento — para que una sesión nueva o un compañero sepan qué hay leyendo un solo doc.
  - **Copiloto con higiene documental:** sobrescribe "Fase actual", registra docs en el README, escribe el handoff describiendo el estado **al cerrar** (no en futuro).
- **v1.1 (2026-06-24):** prompts de fase → slash commands globales; CC copiloto vía bloque en `CLAUDE.md` + reconciliación en apertura; handoff con cabecera de estado; specs por descomposición; QA como catálogo derivado. Archivada en `_archivo/`.
- **v1.0 (2026-06-22):** primera versión unificada (un solo flujo, gate binario, contrato de pares, entrevista socrática). Archivada.
- **Por crecer con el uso:** todo. Cada uso real que revele una desviación alimenta la siguiente versión.
