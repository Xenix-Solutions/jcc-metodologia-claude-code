# JCC — Agentic Dev Methodology

> **Versión:** v1.5 (2026-09-04)
> **Tipo:** documento vivo y operativo — **"invoca y avanza"**.
> **Para qué:** desarrollar con Claude Code (CC) un producto nuevo o un cambio sobre código existente, mediante un diseño conjunto que lleva al mejor resultado y luego lo ejecuta con control — con una estructura documental (`jccdocs/`) que cualquier sesión o compañero puede recorrer.
> **Para quién:** cualquiera del equipo. No necesitas leerte la teoría; mira el gate, y si entras, recorre las fases invocando su command. CC mantiene la documentación al día para que cualquiera —tú, un compañero o una sesión nueva— sepa, leyendo un índice, qué hay y dónde.

---

## Idea de fondo (30 segundos)

- **Un solo flujo** para producto nuevo y para cambios sobre código existente. El "sabor" (greenfield / brownfield) lo **autodetecta CC** preguntándose *¿hay código que respetar?* — tú no clasificas nada por adelantado.
- **Diseño conjunto entre pares.** CC es el especialista técnico; tú decides estrategia, alcance y restricciones. Las decisiones **irreversibles o que condicionan el futuro** se deciden en la **mesa común**, no las absorbe CC en silencio.
- **La profundidad la fija la entrevista, no una etiqueta previa.** Se agota rápido en lo simple y profundiza en lo complejo.
- **Vocabulario** *(v1.5)*: todo lo que cuelga de `jccdocs/` es un **work item** — un **Epic**, un **Feature** o un **Analysis**; las cuatro fases (Design → Spec → Implementation → Review) son los **estados** de un work item en el **workflow JCC**; lo único cíclico es el review loop.
- **El artefacto es el puente de contexto.** Cada fase deja un documento (`DESIGN.md`, `SPEC.md`, código) que permite continuar sin arrastrar la conversación.
- **Cada fase es una skill.** Los prompts de fase viven en **skills globales** que se invocan como slash commands (`/jcc-design`, `/jcc-spec`, `/jcc-implement`, `/jcc-review`, `/jcc-handoff`). Un toque en vez de un copy-paste. La superficie completa: **4 fases + cierre + 4 herramientas fuera del workflow** (`/jcc-start`, `/jcc-analysis`, `/jcc-query`, `/jcc-audit`) **+ 1 de mantenimiento** (`/jcc-upgrade`) = **10 commands**, más la definición de agente del revisor. Convención: **los commands se nombran en inglés** (`jcc-query`, `jcc-audit`), como el vocabulario de la ontología.
- **El modelo es un parámetro, no la metodología.** La tabla de *Perfil por fase* es la fuente única de modelo y effort; los commands la verifican al arrancar, no la recitan.
- **CC opera consciente del marco (copiloto).** Sabe en qué fase estás, te avisa en las transiciones y te ofrece el command que toca. Tú decides; él nunca bloquea.
- **Cada cosa tiene un hogar** (v1.2), y todos los hogares viven bajo **`jccdocs/`** (v1.5). El estado vivo, el mapa de la documentación y la historia con evidencia viven en sitios distintos y no se mezclan. CC los mantiene al día. (Ver *Los tres hogares* y *Estructura de `jccdocs/`*.)

---

## Perfil por fase (modelo, effort y dónde corre cada cosa)

La metodología **no depende de un modelo concreto**: las fases, los hogares y el contrato de pares funcionan igual con cualquiera. Lo de abajo es el perfil **vigente a la fecha de esta versión**, no un requisito. Es la **fuente única**: los commands ya no recitan modelo ni effort, solo **verifican** contra esta tabla ("dime modelo y effort activos; si no coinciden con la tabla, señálalo y sigue"). El effort activo lo inyecta el sistema en el command (`${CLAUDE_EFFORT}`); el modelo lo compruebas con `/model` al abrir.

### La tabla (perfil v2, 2026-09-04)

| Fase / herramienta | Dónde corre | Modelo (ID completo) | Effort | Nota |
|---|---|---|---|---|
| **Design** (`/jcc-design`) | sesión | `claude-fable-5-1` | `high` | entrevista interactiva: a effort máximo delibera de más |
| **Spec** (`/jcc-spec`) | sesión | `claude-fable-5-1` | `high` | suele seguir a Design en la misma sesión; en frío verifica igual |
| **Implementation** (`/jcc-implement`) | sesión | `claude-fable-5-1` | `high` | puerta de verificación **activa** (calibración Fable 5.1); edición dirigida y batching (ver la skill) |
| **Review** (`/jcc-review`) | **subagente con definición de agente** (`agents/jcc-review.md` del kit) | `claude-opus-5` | `high` | **otra familia que el implementador**: la diversidad es el argumento. Si se corre en sesión aparte, mismo modelo y effort |
| **Analysis** (`/jcc-analysis`) | sesión | `claude-fable-5-1` | `high` | misma técnica socrática que Design; responde "¿QUÉ hacemos?" |
| **Cierre** (`/jcc-handoff`) | la sesión que cierra | el de esa sesión | el de esa sesión | hereda el perfil de la sesión que cierra; la calibración de longitud vale en Fable 5.1 y en Opus 5 |
| **Query** (`/jcc-query`) | sesión | `claude-fable-5-1` | `high` | solo lectura; cualquier modelo sirve, este es el estándar |
| **Audit** (`/jcc-audit`) | sesión o subagente | `claude-fable-5-1` | `high` | en sesión o en subagente según convenga; independiente de quien escribió la documentación; su calibración de recall está pendiente de revalidar en el modelo en que corra |
| **Start** (`/jcc-start`) · **Upgrade** (`/jcc-upgrade`) | sesión | `claude-fable-5-1` | `high` | la sesión del operador; `start` recuerda modelo/effort del command que ofrece leyendo esta tabla |
| **Sesiones de metodología** (este repo) | sesión | `claude-fable-5-1` | `high` | mismo perfil que las fases |

- **Por qué `high` y no `xhigh`:** la documentación oficial de Fable 5.1 recomienda `high` por defecto y reserva `xhigh` para trabajo *capability-sensitive*; a effort alto en trabajo rutinario delibera más de lo que la tarea necesita. Ningún uso de la metodología queda hoy en `xhigh` (tampoco la revisión adversarial externa de la propia metodología: su charter lo fijó en `high` el 04-09).
- **Por qué Opus 5 en Review y no Fable:** no por capacidad sino por **diversidad de revisor** — el primer piloto (A20, 04-09) mostró que un revisor de otra familia cazó un cruce de datos que el implementador dio por bueno. El mecanismo recomendado es el **subagente en la sesión implementadora** con la definición de agente del kit; el bucle fix → re-review corre igual (subagente fresco acotado al fix, sección aditiva en `REVIEW.md`).
- **Palancas guardadas, fuera de la tabla** (no son recomendación): Fable 5.1 `medium` en Implementation como palanca de coste (sin A/B todavía) y Opus 4.8 como revisor alternativo. Entran cuando haya dato, no antes.
- **IDs completos en lo durable, alias solo en interactivo.** La tabla, las definiciones de agente y `CLAUDE.md` llevan el ID completo; el alias (`fable`, `opus`) saltó de versión sin aviso en una sesión real (A15) — en un fichero durable, un alias es una fecha de caducidad sin fecha.

### Doctrina del workflow multi-sesión

- **Sesión fresca por frontera de fase** (recomendada, no obligatoria): higiene de contexto y autocontención del artefacto. Ya no la fuerza el cambio de modelo (todas las fases de sesión corren en el mismo); la sostiene la calidad del SPEC.
- **Frontera de fase = corte natural SIN handoff completo.** La higiene de cierre de fase (artefacto registrado en el README + puntero "Fase actual") **es** el cierre. Medido en un Feature real: la siguiente fase abrió en sesión fresca desde el artefacto solo, sin pérdida (A14, 100%). Por eso Design y Spec cierran con la frase *"la siguiente fase puede abrirse en sesión fresca y con otro modelo: todo lo que necesite debe estar en el artefacto"*.
- **Una fase no se parte entre sesiones sin `/jcc-handoff`.** El corte sin handoff solo vale en la frontera; a mitad de fase el estado vive en la conversación y hay que fotografiarlo.
- **El patrón multi-sesión NO es obligatorio.** Un cambio pequeño recorre el workflow entero en una sesión y eso sigue siendo lo correcto.
- **La instrucción de arranque ES el comando:** la sesión siguiente arranca con `/jcc-<fase>` al inicio del mensaje y el contexto extra detrás, en el mismo mensaje. No se generan prompts de arranque aparte.
- **Ritual `/usage` al cierre.** Cada sesión de fase termina con `/usage` y una línea con los números en su handoff. Es la telemetría mínima que permite decidir las palancas de coste con dato y no con impresión.

### Doctrina de subagentes

- **Frase de la casa:** *subagente para juicio independiente sin derechos de decisión (review, audit); sesión para trabajo donde el operador tiene derechos de decisión (design, spec, implement, analysis).*
- **Implementación en subagente: NO.** **Orquestador de fases en sesión: NO.** El orquestador es el operador, las sesiones son las fases y el bus son los artefactos.
- **Herencia de effort (hallazgo técnico A20, confirmado después por la doc oficial de subagentes: «Default: inherits from session»):** un subagente sin definición propia **hereda el effort de la sesión padre**, y no existe override por invocación documentado (petición abierta en el issue #39220 de `anthropics/claude-code`). Por eso el revisor tiene definición de agente con `model` y `effort` fijados; es el único sitio donde fijarlos. **Asimetría a vigilar:** las definiciones de agente no tienen equivalente a `disable-model-invocation`, así que el agente es, en principio, invocable por el modelo por su cuenta; lo frena su `description` («NUNCA lo lances por iniciativa propia») y la doctrina del bloque (la Review la dispara el operador). Si un piloto muestra una auto-invocación, sube a incidencia. La definición del kit vive en `agents/jcc-review.md` (fuente de verdad) y se instala en `~/.claude/agents/` con `install.ps1`; un proyecto puede sobreescribirla en `.claude/agents/` (precedencia de proyecto verificada en la documentación oficial).
- **Tres guardas del revisor (vinculantes para `jcc-review` y su definición de agente):**
  1. **Etiquetar ≠ filtrar.** La mitigación del sobredimensionado de Opus 5 es gravedad + confianza + cláusula del SPEC por hallazgo, y la prohibición de refactors no exigidos. **Jamás** "reporta solo lo importante": un filtro de gravedad en el prompt reduce el recall.
  2. **IDs completos** en definiciones durables (arriba).
  3. **Vigilancias declaradas:** (a) el clasificador de Claude Code puede degradar Opus 5 → 4.8 en código de auth/cripto; si ocurre, el hallazgo lo anota; (b) el prompt de consentimiento de créditos podría matar subagentes en background — **sin verificar**, no se afirma como hecho.

### Lo que no cambia

- **No toques el dial a mitad de sesión.** El effort forma parte de la clave de caché: el turno siguiente reprocesaría toda la conversación sin un solo acierto. Elige al abrir. El nivel **persiste entre sesiones** una vez fijado y la escala está **calibrada por modelo**: comprueba `/model` al arrancar si vienes de otra fase o de otro modelo.
- **Patrón sucesor, gateado:** mono-modelo con effort variable por fase dentro de una misma sesión. Depende de que Claude Code adopte el effort por mensaje (hoy existe solo en la API). Vigilancia del changelog; el día que llegue entra **cambiando la columna Effort**, no la doctrina.
- **Capa de calibración etiquetada** (desde v1.3). Toda instrucción de las skills atada a un modelo concreto lleva **`calibración vX.Y para <modelo>; revisar al cambiar de modelo`**. En una transición de modelo la auditoría de migración es acotada: recorrer las etiquetas, probar a quitar cada una, conservar solo las que el modelo nuevo siga necesitando. Las fases, los hogares y el contrato de pares no llevan etiqueta porque no caducan. La transición 4.8 → Fable 5.1 de esta versión se hizo exactamente así (prompt-audit del 03-09, en `evolucion-metodologia/` del repo privado).
- **Esta sección es lo primero que caduca del documento.** Es la única atada a modelos concretos: si la lees y ya existe una generación posterior a Fable 5.1 / Opus 5, trátala como **pendiente de revisar**, no como vigente. Lo que hay que rehacer entonces es la tabla (modelos, effort disponibles y su rendimiento) y las calibraciones etiquetadas de las skills. Las fases no se tocan. La historia de los perfiles anteriores (Opus 5 → Opus 4.8 `xhigh` → Fable 5.1) vive en *Estado del documento*.

---

## ¿Merece metodología? (gate único)

Lo único que se decide antes de analizar, y es barato y reversible:

- **¿Es trivial?** Lo describes en una frase, toca un punto localizado y no ves riesgo de romper nada (p. ej. cambiar un color) → **directo a CC**, sin esto (en plan mode si quieres).
- **¿Hay algo que diseñar / alguna duda sobre el CÓMO?** → **entra en la metodología**, y empieza **siempre** por la entrevista (`/jcc-design`). No hay carriles ni clasificación de tamaño: de eso ya se encarga la propia entrevista.
- **¿La duda es todavía QUÉ hacer, o si seguimos bien?** → `/jcc-analysis`: deliberación con rastro; si de ahí sale trabajo, `/jcc-design` lo recibe como material. Regla práctica: si lo que le darías a `/jcc-design` cabe en dos frases claras, no necesitas Analysis.
- **¿No sabes por dónde entrar** (día 0, vuelta tras días, sesión sin command claro, compañero nuevo)? → `/jcc-start` te lo dice. Es opcional: quien sabe a qué viene entra directo por su command.

Si al explorar un caso "trivial" resulta que tenía más miga, súbelo a la metodología. El coste de equivocarse en este gate es mínimo.

---

## Los tres hogares (+ índice global)

La lección del uso real (4 proyectos, muchas iteraciones): cuando no hay un sitio claro para cada tipo de información, **todo se apila en el sitio que CC lee siempre (`CLAUDE.md`)** y la "Fase actual" degenera en un changelog interminable. La v1.2 lo arregló dando **tres hogares** con comportamientos distintos, más un índice global; la v1.5 solo les cambia el contenedor (`jccdocs/`, ver *Estructura*):

| Rol | Hogar | Comportamiento |
|---|---|---|
| **Estado vivo** — qué está activo AHORA | línea **"Fase actual"** en `CLAUDE.md` | **corto**, se **SOBRESCRIBE** en cada transición; **nunca acumula** |
| **Mapa / índice** — qué documentos existen y dónde | **`README.md` del work item** | durable; **crece** al crear cada documento |
| **Historia + evidencia** — qué pasó cada sesión | **`HANDOFF`(s) del work item** (en su carpeta; en un Epic, agrupados en `handoffs/`) | fechado; **se acumula** (uno por sesión de cierre) |
| **Puerta de entrada** — todos los work items del proyecto | **`jccdocs/README.md`** (índice global) | tabla estable de navegación; una fila por work item; **autoritativo para el estado de merge/PR** |
| **Backlog** — pendientes durables (decidido no-ahora) | sección **`### Backlog`** de `CLAUDE.md` | **curado**: una línea por pendiente; **se poda** — lo hecho o caducado se borra (su historia ya vive en los handoffs) |

Regla mental que lo resume: **la "Fase actual" es un puntero, no un diario.** Si te descubres pegando historia en `CLAUDE.md`, va al handoff. Si describes qué documentos hay, va al README. Los tres hogares se sostienen mutuamente: porque el README carga el mapa y los handoffs cargan la historia, la "Fase actual" puede por fin ser tres líneas.

Reglas anejas (v1.3–v1.5, de la evidencia de las adopciones):

- **Mapas vivos vs fotos** *(v1.4)*. Los índices y punteros (README, índice global, "Fase actual", Backlog) son **mapas vivos**: se corrigen cuando la realidad cambia. Los documentos fechados (HANDOFF, REVIEW, BRIEF, AUDIT, ANALYSIS) son **fotos**: no se reeditan — lo que los supera se registra en un documento nuevo o en un ADDENDUM fechado.
- **Enmienda ADITIVA del handoff vivo** *(v1.5)*. Un handoff propio **aún vigente** que resulta impreciso no se reescribe: recibe una **nota fechada al final** y un **backport selectivo honesto** de los documentos vigentes que contradiga. Los documentos cuyas cifras eran ciertas para su fecha **no se tocan**: son fotos. Resuelve la tensión entre "los handoffs no se reeditan" y "backport completo": el backport alcanza a lo vigente, no a la historia.
- **Re-review ADITIVA** *(v1.5)*. La re-review acotada de un fix se registra como **sección fechada al final de `REVIEW.md`**, sin reescribir la foto de la review original. La cadena queda legible: hallazgos → fixes → re-review, en el mismo fichero y en orden.
- **El backlog tampoco es un diario.** Ahí entra solo lo durable que se decidió *no hacer ahora* (endurecimientos, deudas conscientes, decisiones diferidas). Los pendientes de simple continuidad ("retomar por X") van al handoff. Al añadir, **poda**: cada entrada hecha o caducada se borra de la lista.
- **El handoff es una foto pre-merge.** El merge/PR suele ocurrir después de cerrar la sesión, así que el handoff dice honestamente "PR abierto" y ahí se queda. El **estado definitivo de merge vive en el índice global**, y la **reconciliación de apertura** de la siguiente sesión lo actualiza si el merge ya ocurrió.

---

## Precondición: el bloque JCC en `CLAUDE.md`

`CLAUDE.md` (raíz del proyecto, lo lee CC en cada sesión) es el **ancla por-proyecto**. No alberga la metodología (eso vive solo en este doc); alberga un **bloque fino** con el estado vivo y el contrato de copiloto.

> **El bloque nace con el PROYECTO, no con el primer documento** *(regla B1, v1.5)*. Lleva una **línea de versión** (`Bloque JCC v1.5`) que `/jcc-start` compara con la de su skill para avisar del desfase y que `/jcc-upgrade` reescribe al migrar. En un proyecto nuevo lo crea `/jcc-start` en el **bootstrap día-0** (bloque + esqueleto `jccdocs/` + `anexos/` + portada + `.gitignore` + `git init`, con tu visto bueno). En un proyecto con código existente sin `CLAUDE.md`, créalo con `/init` + curación y `/jcc-start` le añade el bloque. La plantilla la escribe `jcc-start` y la migra `/jcc-upgrade`; a mano solo si no tienes el kit.

```markdown
## Metodología (JCC)

- **Bloque JCC v1.5** (esta línea la reescribe `/jcc-upgrade`; no la edites a mano). Este proyecto se
  desarrolla con la metodología JCC. Doc (URL estable, consultable en sesión):
  https://raw.githubusercontent.com/Xenix-Solutions/jcc-metodologia-claude-code/main/docs/JCC_Metodologia.md
- **Fase actual:** ninguno; el siguiente arranca con `/jcc-design`, `/jcc-analysis` o `/jcc-start`.
  <cuando haya trabajo activo, un puntero CORTO: work item activo · fase (Design / Spec /
  Implementation / Review) · siguiente command con la barra al inicio · enlace al README del work
  item y a su último handoff · enlace al índice global `jccdocs/README.md`. Esta línea se
  SOBRESCRIBE en cada transición; NUNCA acumula historia.>
- **Arranque: reconstruye antes de opinar.** Si tu tarea toca el trabajo en curso — aunque sea
  una sesión suelta, sin command JCC —, sigue los punteros ANTES de afirmar nada sobre el
  estado: índice global `jccdocs/README.md` → README del work item activo → su último handoff,
  y contrasta con `git log`. "Leo lo que necesite" no funciona: para saber qué necesitas,
  primero mira el mapa. Y OJO: reconstruir contexto NO es entrar en las fases — una sesión que
  SOLO consulta o comprueba no avanza fases, no toca "Fase actual" y no ofrece `/jcc-handoff`
  al terminar (si acaba tocando código o documentos, ya no es solo-consulta: aplica el
  contrato de abajo).
- **Detección de command no disparado.** Un `/jcc-*` solo se ejecuta como command si el mensaje
  EMPIEZA por él. Si un mensaje contiene `/jcc-<algo>` y no se te han inyectado sus
  instrucciones, el mecanismo no disparó: avísalo y ofrece dos salidas — reenviarlo al inicio
  del mensaje, o la ruta degradada (lee `~/.claude/skills/jcc-<nombre>/SKILL.md` y síguelo).
  No bloquees.
- **Operas como COPILOTO.** En las transiciones de fase, recuerda y ofrece el command que toca
  (`/jcc-design` → `/jcc-spec` → `/jcc-implement` → `/jcc-review`; fuera del workflow:
  `/jcc-analysis`, `/jcc-query`, `/jcc-audit`, `/jcc-start`; cierre: `/jcc-handoff`;
  mantenimiento: `/jcc-upgrade`); **no bloquees**, el usuario decide. Las decisiones **estructurales o difíciles de revertir** van a
  la **mesa común**: no las absorbas. **Mantienes la documentación al día sin que te lo pidan**:
  sobrescribes "Fase actual" (la historia va a los HANDOFF + índice global, NO a esta línea), y
  registras cada documento nuevo en el README del work item. **Ajustas la longitud de cada
  documento a lo que el trabajo pide**: recorta relleno, no conectivas ni contexto — el criterio
  es que un humano pueda releerlo, no la brevedad.
- **Este bloque tiene DOS lectores: tú y el clasificador de permisos (auto mode).** Las
  restricciones operativas durables — qué no se toca, qué no se ejecuta, qué conectores no se
  usan, dónde hace falta checkpoint humano — viven en este fichero o en las reglas
  `permissions.ask`/`deny` de settings, **nunca solo en la conversación** (se pierden con la
  compactación). Una regla fuerte que se decida en mesa se escribe aquí EN EL MOMENTO.
- **Las convenciones JCC no se improvisan.** Si una situación documental (dónde vive un documento,
  cómo se llama, qué hogar le toca) no está cubierta por lo que tienes en contexto, **consulta el
  doc de arriba** antes de fijar una convención; si no puedes acceder, es decisión de **mesa común**.
- **Reconciliación al arrancar.** Contrasta la "Fase actual" con los artefactos reales del repo
  (¿qué SPEC existen?, ¿qué está implementado/verificado?). Si no cuadran, **dilo**. Si el índice
  global declara un merge/PR pendiente que ya ocurrió, **actualízalo**: el handoff es foto pre-merge;
  el estado definitivo de merge vive en el índice global. Canta también las **contradicciones
  internas** de este CLAUDE.md (afirmaciones de épocas distintas que convivan) y el **trabajo
  posterior al último handoff sin bitácora**.
- **`### Backlog`** (sección aparte de este fichero; existe solo si hay pendientes durables): una
  línea por pendiente decidido no-ahora; **se poda** — lo hecho o caducado se borra (su historia ya
  vive en los handoffs).

## Reglas operativas (INVIOLABLES)

- **Conectores MCP opt-in.** Este proyecto USA solo los conectores declarados aquí: <lista, o
  "ninguno">. Cualquier otro conector disponible en la sesión NO se consulta, NO se lista y NO se
  conecta, bajo ninguna circunstancia: puede apuntar a sistemas de otros clientes.
- <solo proyectos de cliente> **Confidencialidad en dos niveles.** El material del CLIENTE
  (documentos, datos, grabaciones, código suyo) NUNCA sale de este repo local: ni a repos públicos,
  ni a despliegues, ni a servicios externos. Los ENTREGABLES PROPIOS con datos ficticios son
  publicables solo por decisión de mesa registrada en el handoff.
```

(La sección **Reglas operativas** la escribe el bootstrap: la línea de conectores MCP siempre — el ritual opt-in es de todo proyecto —, la de confidencialidad solo en proyectos de cliente. Son reglas de clase INVIOLABLE con los dos lectores de arriba. La plantilla que instala `/jcc-start` es copia de esta; si difieren, manda este documento.)

---

## Cómo opera CC (copiloto)

Contrato de comportamiento transversal. La causa de los fallos del pasado fue que la metodología —y luego la propia documentación— vivía fuera de un sitio con reglas claras.

- **Copiloto, no guardia.** CC conoce el marco y la fase actual. En cada **transición** te lo recuerda y te ofrece el command. **Nunca bloquea.**
- **Reconciliación en apertura (automática, no es un command).** Al abrir una sesión fresca, CC contrasta la "Fase actual" con los artefactos del disco y **canta la discrepancia** si no cuadran. Es la defensa contra el "estado mentiroso".
- **Higiene documental (novedad v1.2).** CC mantiene los tres hogares al día por su cuenta: **sobrescribe** "Fase actual" (no la engorda; edición dirigida), **registra en el README del work item** cada documento que crea, y al cerrar **escribe el handoff y actualiza el índice global**. Los handoffs describen el estado **al cerrar**, no un estado futuro que aún no ha ocurrido. **La evidencia de ejecución se escribe una sola vez, en el handoff** (novedad v1.3): DESIGN, README e índices **enlazan** a ella, no la duplican — dos copias de una evidencia viva divergen.
- **Autoridad de la metodología (novedad v1.3).** Las convenciones JCC no se improvisan: ante una situación documental no cubierta por el contexto, CC **consulta el doc de metodología** (URL estable del bloque JCC) antes de fijar una convención; si no puede acceder, la trata como decisión de **mesa común**. Origen: un agente fijó por criterio propio una convención de handoffs contraria a la metodología —el doc era inalcanzable en la práctica— y hubo que deshacerla un día después con seis documentos que reapuntar.
- **Contrato de pares.** Ante una decisión irreversible o que condiciona el futuro, CC la **sube a la mesa común** con su recomendación. Lo reversible y local lo decide y lo reporta.
- **Regresión = parte de la definición de hecho.** En código existente, *"no romper lo que ya iba"* no es un extra.
- **Regla de oro:** lo **deliberado** (avanzar de fase, cerrar sesión) es un **command** que invocas tú; lo **automático** (saber el marco, reconciliar, mantener la documentación) vive en `CLAUDE.md` y ocurre sin que teclees nada.

---

## Estructura de `jccdocs/`: contenedor, ontología y convenciones

Las rutas son **contratos de automatización**: los commands leen rutas fijas, el índice se construye con un `Glob`, la migración se hace por subárbol. Por eso el naming es rígido. **Rigidez de ESTRUCTURA ≠ corsé de PENSAMIENTO**: la libertad está en el análisis y en el diseño, no en dónde se guarda el fichero ni cómo se llama. Un cambio de tres ficheros no lleva README ni `handoffs/`; un Epic sí. Si una convención te obliga a burocracia en algo pequeño, es señal de que te has pasado.

### El contenedor: `jccdocs/` y `anexos/`

- **`jccdocs/`** es el contenedor único de la documentación metodológica **en todos los proyectos** (muere "producto nuevo → raíz" y muere `docs/` como cajón de sastre). El nombre es API estable: legible para terceros, casa con el prefijo `jcc-` de los commands y sobrevive a rebrandings.
- **`anexos/`** guarda lo que NO es metodología: material que aporta el operador (transcripciones, hojas de cálculo, imágenes), entregables sueltos que genera CC (exports, maquetas) y subcarpetas ad hoc. Deliberadamente **sin prefijo `jcc`**: la asimetría señala qué es metodología y qué no.
- **Portada ≠ mapa** *(P1)*. La raíz del repo lleva un `README.md` **portada mínima** (qué es el proyecto + enlaces a `jccdocs/README.md` y a `CLAUDE.md`). El **mapa** vive en `jccdocs/README.md`. Contenidos distintos, sin riesgo de divergencia.
- **Test leer-vs-ejecutar** *(P4)*, para lo que no encaja a primera vista: *¿esto se vuelve a LEER (rastro → `jccdocs/`) o a EJECUTAR (herramienta → fuera de `jccdocs/`, registrada en el README del work item que la usa)?* Scripts de preparación de datos, fixtures y utillaje de demo viven fuera. No es taxonomía dura: lo ambiguo, a mesa común.
- **El hogar lo decide el TIPO**, no el momento: una decisión va al DESIGN (o a un ADDENDUM suyo), la evidencia al handoff, un pendiente durable al Backlog, una vista para humanos a un BRIEF.

### Ontología: work items y workflow JCC

El vocabulario es el de Agile/ALM, **en inglés como nombres propios** (la prosa sigue en castellano):

| Término | Qué es | Forma en disco |
|---|---|---|
| **work item** | paraguas genérico para todo lo que cuelga de `jccdocs/` (uso de Azure DevOps; no es un nivel) | carpeta con vida propia |
| **Epic** | varios trabajos con DESIGN/SPEC propios bajo un diseño transversal (ex-programa) | carpeta con DESIGN transversal + `README.md` + `handoffs/` único + `feature-NN_<slug>/` |
| **Feature** | un trabajo que recorre el workflow JCC entero, incluido el puramente técnico (refactor, migración, corte) (ex-cambio y ex-ciclo) | carpeta plana con DESIGN, SPEC(s), REVIEW(s), HANDOFF(s) |
| **Analysis** | deliberación sobre el QUÉ, con rastro (≈ *Spike* ampliado); produce un ANALYSIS, nunca código | carpeta si es standalone; fichero si es sobre un Epic existente |
| **SPEC ≈ PBI** | solo como vocabulario: el artefacto sigue llamándose `SPEC` | fichero plano junto al DESIGN, sin subcarpeta |
| **Task** | no se formaliza: son los pasos del plan de Implementation y los commits | — |

Initiative y Theme quedan fuera: JCC no gestiona cartera en un repo.

- **"Ciclo" muere → workflow JCC.** Design → Spec → Implementation → Review son **estados** de un work item, no vueltas de un ciclo. Lo único genuinamente cíclico es el **review loop** (3↔4). Se escribe calificado, "workflow JCC" (la colisión con GitHub Actions es inofensiva). Rechazados con razón: *pipeline* (línea que se detiene; aquí una falla transiciona), *iteration* (= sprint en ADO/GitHub Projects: sembraría la confusión exacta que se evita), *lifecycle*, *round/process*, *playbook*, *chain/flow*.
- **Fase 1 se llama Design** (antes "Análisis"), para no colisionar con `jcc-analysis`. Las cuatro fases son **Design / Spec / Implementation / Review** en toda la superficie: doc, skills y bloque JCC.
- **Discriminador Design vs Analysis:** *Design responde "¿CÓMO hacemos esto?"; Analysis responde "¿QUÉ hacemos?" (o "¿seguimos bien?")*. Si lo que le darías a `/jcc-design` cabe en dos frases claras, no necesitas Analysis. Y si en un Analysis empiezas a fijar modelo de datos, contratos o alcance concreto, eso ya es Design: se cierra el ANALYSIS y se abre `/jcc-design` con él como material.
- **REVIEW por pasada de implementación, no por PBI.** El invariante es que todo lo implementado pasa review antes de cerrar la Feature; cuántos REVIEW salgan lo dicta cómo se troceó la implementación.

### Naming

- **Raíz de `jccdocs/`: `yyyymmdd_<tipo>_<slug>/`**, con `<tipo>` ∈ `epic` | `feature` | `analysis`. El **underscore separa campos** y el **guion separa palabras dentro de un campo**: parseable con un `split('_')`; `Glob 2026*_feature_*` es el índice de Features del año. La fecha es la de apertura y da el orden humano gratis. **Sin ID secuencial global**: un contador es estado a policiar y la fecha da el 95 % del valor.
- **Dentro de un Epic: `feature-NN_<slug>/`.** Ahí el orden que el lector necesita es el del **roadmap**, no el cronológico (herencia directa de `ciclo-N`).
- **Partición de namespace.** Todo work item empieza por dígito → **cualquier nombre que empiece por letra está reservado para estructura**: `README.md` hoy; `regression/`, `audits/` cuando lleguen (candidatos reales: el catálogo de regresión que anticipa `jcc-spec`, y las auditorías "proyecto entero"). Sin nivel intermedio ni reorganización jamás.
- **Ficheros fechados: `TIPO_yyyymmdd_<slug>.md`** (tipo primero: dentro de una carpeta el lector agrupa por tipo; las carpetas ya ordenan por fecha). Prefijos en inglés y en mayúsculas. **Fecha unificada `yyyymmdd`** en todo nombre nuevo: `HANDOFF-AAAA-MM-DD.md` y los híbridos `BRIEF_AAAA-MM-DD_` quedan normalizados en el esquema; los ficheros existentes **no se renombran**.
- **Solo lo ACTIVO se renombra.** En cualquier migración (incluida la de `/jcc-upgrade`), lo cerrado conserva nombre y enlaces: renombrar historia cerrada es riesgo sin beneficio.

### Nombres canónicos

| Artefacto | Nombre | Dónde | Notas |
|---|---|---|---|
| Feature | `yyyymmdd_feature_<slug>/` | raíz de `jccdocs/` | carpeta plana: DESIGN, SPEC(s), REVIEW(s), HANDOFF(s) directamente dentro; **sin `handoffs/`** aunque dure varias sesiones |
| Epic | `yyyymmdd_epic_<slug>/` | raíz de `jccdocs/` | DESIGN transversal + `README.md` + `handoffs/` + `feature-NN_<slug>/`. **Siempre carpeta de Epic**, también cuando el proyecto entero es un único Epic |
| Feature de un Epic | `feature-NN_<slug>/` | dentro del Epic | numeración de roadmap; sus handoffs van al `handoffs/` del Epic |
| Analysis standalone | `yyyymmdd_analysis_<slug>/` con `ANALYSIS.md` (+ BRIEFs que lo alimenten) | raíz de `jccdocs/` | registrada en `jccdocs/README.md`; si desemboca en trabajo, el Feature/Epic que nace la enlaza como material |
| Analysis sobre un Epic | `ANALYSIS_yyyymmdd_<slug>.md` | carpeta del Epic | registrado en el README del Epic; suele desembocar en ADDENDUM al DESIGN transversal |
| Diseño | `DESIGN.md` | Feature o Epic | uno por work item; cambios acordados al implementar → **ADDENDUM fechado** dentro; registra las tensiones del encargo y su resolución |
| Especificación | `SPEC.md` **o** `SPEC-NN_<slug>.md` | junto a su DESIGN | monolítico si es indivisible; modular si el DESIGN se descompuso; **nunca en subcarpeta** |
| Revisión adversarial | `REVIEW.md` (o `REVIEW-NN_<slug>.md` si hay varias pasadas) | junto al SPEC | por pasada de implementación; la re-review de un fix es **sección fechada aditiva** al final |
| Cierre de sesión | `HANDOFF_yyyymmdd_<slug>.md` | Feature: en su carpeta · Epic: en `handoffs/` | foto fechada; nunca se reedita (enmienda aditiva si sigue vigente) |
| Auditoría de la documentación | `AUDIT_yyyymmdd_<slug>.md` | carpeta del work item auditado; "proyecto entero" → `jccdocs/audits/` (nombre reservado) | salida de `/jcc-audit`; foto; solo reporta |
| Índice del work item | `README.md` | Feature o Epic | mapa de sus documentos; obligatorio en Epics, opcional en Features triviales |
| Índice global | `jccdocs/README.md` | raíz de `jccdocs/` | tabla de todos los work items; autoritativo para merge/PR |
| Portada | `README.md` | raíz del repo | qué es + enlaces; no es el mapa |
| Reservados | cualquier nombre que empiece por letra | raíz de `jccdocs/` | estructura futura (`regression/`, `audits/`) |

### Artefactos de apoyo (lista abierta)

El trabajo real produce más que DESIGN/SPEC. Se reconocen como legítimos, con convención `TIPO_yyyymmdd_<slug>.md` si son fotos fechadas y `TIPO_<slug>.md` si son mapas vivos; todos en mayúsculas, todos registrados en el README del work item (o en el índice global si viven en un nombre reservado como `jccdocs/audits/`), ninguno obligatorio:

- `BRIEF_yyyymmdd_<slug>.md` — material de partida (de negocio, de un tercero, para una herramienta de diseño), una comprobación ligera sin deliberación, la vista materializada por `/jcc-query`, o el dossier narrativo de un cierre con sucesor (`/jcc-handoff`). Foto: no se mantiene.
- `AUDIT_yyyymmdd_<slug>.md` — informe de `/jcc-audit` (hallazgos sobre la propia documentación; solo reporta).
- `ANALYSIS_yyyymmdd_<slug>.md` — salida de `/jcc-analysis` sobre un Epic existente (arriba).
- `RUNBOOK_<slug>.md` — pasos de operación (cutover, provisión, migración manual, recuperación de un backup). Mapa vivo: se corrige.
- `DESIGN-SYSTEM_<slug>.md` — sistema de diseño destilado (tokens, componentes).
- `eval/` — banco de evaluación (golden, prompts, salidas) cuando se afinan prompts o se comparan modelos. Se relee como evidencia, por eso vive dentro; el utillaje que lo ejecuta, fuera (P4).

`INVESTIGACION_` **muere como tipo**: una comprobación ligera sin deliberación es un `BRIEF_`; una con deliberación es `/jcc-analysis`. Un solo nombre para la misma cosa.

### Feature o Epic: cuándo promover

- **ANTES de escribir el segundo DESIGN, no después.** El disparador salta en `/jcc-design` en el momento en que el DESIGN que va a escribir sería el segundo de una carpeta plana: promover ahí cuesta minutos. Retroactivamente, con varios DESIGN apilados y trabajo hecho, mover ficheros arriesga el rastro y suele acabar en "no tocar y taparlo con el README". No apiles `DESIGN-02/03` en plano: eso es un Epic pidiendo `feature-NN/`.
- **Un proyecto que ES un solo Epic también va en carpeta de Epic** (`jccdocs/yyyymmdd_epic_<slug>/`), no suelto en la raíz de `jccdocs/`. Uniformidad: `/jcc-audit` y `/jcc-upgrade` leen una sola forma, y el día que aparece un segundo work item no hay reorganización.
- **Un Feature que acumula tantos SPEC que su carpeta se vuelve ilegible** está pidiendo la promoción a Epic que `/jcc-design` ya sabe proponer.

### Receta de migración por subárbol (P2)

Mover el contenedor **completo** preserva la geometría relativa interna: las fotos fechadas no se editan (sus enlaces internos siguen valiendo); solo se **repuntan los enlaces que cruzan la frontera** (desde `CLAUDE.md`, la portada, o hacia `anexos/`). Es la receta que ejecuta `/jcc-upgrade` al llevar un proyecto de `docs/cambios/` a `jccdocs/`, y la que aplica cualquier reorganización futura. Los cierres ya archivados conservan su nombre.

### Epics de demos: repos hermanos

Cada demo es un work item con su `/jcc-design` propio (que el análisis pueda matar una demo es la Fase 1 funcionando). Los **backups y ensayos son repos hermanos independientes** (p. ej. `<raíz>/demos/<caso>`), no carpetas anidadas: anidar un proyecto CC dentro de otro rompe git y el rastro, y el backup debe ser indistinguible de un proyecto real ante la audiencia. Desde el work item se deja un **puntero** (ruta + commit bueno + guion de recuperación) en su README o en un `RUNBOOK_`. El utillaje de preparación (datasets, BD de prueba) vive fuera de `jccdocs/` (P4).

### El README del work item

El README de un Feature o Epic es su **mapa autodescriptivo**, para que cualquier sesión nueva —y cualquier humano— sepa qué hay leyendo un solo documento. Contiene:

- Qué es el work item en una frase, y si es Feature o Epic.
- La convención de layout de esa carpeta (para no confundir ejes de numeración, etc.).
- **Índice de documentos** existentes, agrupado por fase o por Feature, con una línea de qué es cada uno.
- Si es Epic: **tabla de Features con estado**.
- Puntero al estado vivo (`CLAUDE.md`) y a los handoffs; punteros a herramientas o repos hermanos que el work item usa (P4).

CC lo **actualiza al crear cada documento** y lo consolida en el cierre. No duplica el estado vivo (eso es de `CLAUDE.md`) ni la historia con evidencia (eso es de los handoffs): el README es el **mapa**, no el diario ni el marcador.

### El índice global `jccdocs/README.md`

Puerta de entrada al árbol de work items del proyecto. Tabla: **fecha · tipo (Epic | Feature | Analysis) · slug · qué es (1 línea) · estado (activo | cerrado) · enlaces** (a la carpeta y a su README/handoff). Cabecera que fija la jerarquía (estado vivo en `CLAUDE.md`; mapa por work item; historia en handoffs). CC añade una fila al **abrir** un work item y actualiza el estado al **cerrar**.

- **Es el autoritativo del estado de merge/PR:** el handoff queda como foto pre-merge honesta y no se reedita; el estado definitivo se refleja aquí, y la reconciliación de apertura lo pone al día.
- **Se refresca en handoffs, no en cierres de fase** *(declarado por diseño, v1.5)*: el cierre de fase solo registra el artefacto en el README del work item y sobrescribe "Fase actual". Que el índice global vaya una fase por detrás entre handoffs es tolerable y conocido.
- **Medir antes que ingeniar:** cuando el índice crezca hasta doler, se parte como un changelog (`ARCHIVE.md` por año, nombre reservado por empezar con letra). No antes.

---

## Las fases (+ cierre)

Cada fase **describe** su objetivo y deja un artefacto; el **prompt operativo vive en su skill** (global, `~/.claude/skills/jcc-<nombre>/SKILL.md`, invocada como slash command). El estado y los índices son locales al proyecto. Modelo y effort de cada fase: en la tabla de *Perfil por fase*; cada skill lo verifica al arrancar y no lo recita.

> **Respaldo del kit.** La copia versionada vive en [`skills/`](../skills/) (10 skills) y [`agents/`](../agents/) (definición del revisor) de este repo y es la **fuente de verdad**. En una máquina nueva, instálalo con `skills\install.ps1`; `skills\install.ps1 -Check` te dice si la copia viva y la del repo han divergido (skills y agente). Todas las skills llevan `disable-model-invocation: true`: las invocas tú, nunca se autodisparan.

| Fase | Command | Objetivo | Artefacto | Puerta |
|---|---|---|---|---|
| **1. Design** | `/jcc-design` | Diseñar juntos: ¿CÓMO hacemos esto? | `DESIGN.md` | (si hay código) confirmas que entendió + apruebas el diseño |
| **2. Spec** | `/jcc-spec` | Diseño → spec técnico autocontenido | `SPEC.md` (uno o varios) | apruebas las decisiones (sobre todo las estructurales) + el spec |
| **3. Implementation** | `/jcc-implement` | Construir según el spec | código + `CLAUDE.md` | apruebas el plan + verificación real |
| **4. Review** | `/jcc-review` | Refutar que cumple y no rompe | `REVIEW.md` + veredicto | review loop 3↔4 hasta veredicto limpio |
| **Cierre de sesión** | `/jcc-handoff` | Traspasar estado técnico **y** metodológico | handoff + índices + estado en `CLAUDE.md` | tú disparas el cierre |

Las cuatro fases son los **estados** de un work item en el **workflow JCC**; lo único cíclico es el review loop. Fuera del workflow hay **cuatro herramientas**, también skills: `/jcc-start` (el vestíbulo: detecta el estado del proyecto y te ofrece el command que toca), `/jcc-analysis` (deliberar el QUÉ con rastro), `/jcc-query` (leer la documentación como historia) y `/jcc-audit` (auditarla); y **una de mantenimiento**, `/jcc-upgrade` (migrar un proyecto al canon vigente). Ninguna avanza fases; las de lectura no tocan los hogares. Total: **10 commands**. Todas se describen en *Transversal*.

**Ubicación:** siempre bajo `jccdocs/`: un Feature en `jccdocs/yyyymmdd_feature_<slug>/`, un Epic en `jccdocs/yyyymmdd_epic_<slug>/` con sus `feature-NN_<slug>/`. No hay "producto nuevo → raíz": el proyecto nuevo nace con `jccdocs/` en el bootstrap día-0 (`/jcc-start`). Detalle en *Estructura de `jccdocs/`*.

En cada fase, además de su artefacto, CC **registra el documento creado en el README del work item** y, al avanzar, **sobrescribe** la "Fase actual" de `CLAUDE.md` con edición dirigida. **La instrucción de arranque ES el comando:** cada cierre de fase te deja el siguiente command listo para pegar, con la barra al inicio y el contexto detrás, en el mismo mensaje.

---

### Fase 1 — Design (entrevista socrática) → `DESIGN.md`

- **Command:** `/jcc-design` (tu descripción va como argumento — cruda, dictada, destilada o un ANALYSIS previo — o la pegas a continuación).
- **Objetivo:** llegar al mejor diseño mediante un análisis conjunto entre pares, y plasmarlo en `DESIGN.md`. Responde *¿CÓMO hacemos esto?*; si tu pregunta es todavía *¿QUÉ hacemos?*, la fase te deriva a `/jcc-analysis`.
- **Sesión/modo:** sesión **nueva**, **plan mode** durante la entrevista (solo lectura; tu visto bueno escribe `DESIGN.md`). Perfil: tabla.
- **Cómo funciona:** (1) orientación sobre el código existente si lo hay, hasta que confirmes que CC entendió la zona y la superficie de regresión; (2) entrevista socrática abierta por tandas cortas, `AskUserQuestion` solo para cerrar forks acotados, profundidad ajustada al trabajo; si ve que son **varios trabajos**, propone trocearlos (esto puede indicar un **Epic**); si el DESIGN que va a escribir sería el **segundo de una carpeta plana**, propone la promoción a Epic **antes de escribirlo**; (3) con tu visto bueno, escribe `DESIGN.md` — incluidas las **tensiones y contradicciones del encargo con su resolución**, que solo quedan registradas aquí — y lo registra en el README del work item (y en el índice global si el work item es nuevo).
- **Autocontención:** el DESIGN cierra sabiendo que *la siguiente fase puede abrirse en sesión fresca y con otro modelo: todo lo que necesite debe estar en el artefacto*.
- **Puerta humana:** si hubo orientación, confirmas que CC entendió la zona; luego apruebas `DESIGN.md`.

> **Ojo al destilado.** Si tu descripción viene destilada de un dictado, puede traer ruido que no detectaste. La entrevista socrática es la red: si el destilado mintió, las contradicciones afloran al entrevistarte — pero solo si la fase corre de verdad.

---

### Fase 2 — Spec → `SPEC.md`

- **Command:** `/jcc-spec` (lee `DESIGN.md`; no pegas nada).
- **Objetivo:** convertir `DESIGN.md` en una especificación técnica autocontenida. CC decide el stack (producto nuevo) o especifica el delta dentro del stack dado (código existente). Un **SPEC ≈ un PBI**, solo como vocabulario: el artefacto no cambia de nombre.
- **Sesión/modo:** continuar o sesión fresca (verifica el perfil igual en frío), **plan mode**.
- **Granularidad (guía, no regla):** **sigue la descomposición que el DESIGN ya encontró.** Descompuesto → varios `SPEC-NN_<slug>.md`, cada uno autocontenido y trazado a su decisión de DESIGN; indivisible → un `SPEC.md`. Siempre **planos junto al DESIGN**, sin subcarpeta.
- **Contenido:** resumen; stack y arquitectura; estructura/delta (ADDED/MODIFIED/REMOVED); interfaces y contratos; **qué se PRESERVA** (regresión); migración si aplica; fuera de alcance; **verificación** end-to-end (incluida la regresión). Los apartados *Verificación* y *Qué se PRESERVA* se escriben autocontenidos, pensados para poder compilarse algún día en un catálogo de regresión.
- **Autocontención:** misma frase que en Design; es lo que hace posible la frontera de fase sin handoff.
- **Puerta humana:** apruebas las decisiones —en especial las estructurales— y el `SPEC.md`.

> Si `SPEC.md` y `DESIGN.md` se contradicen, manda `SPEC.md`.

---

### Fase 3 — Implementation → código + `CLAUDE.md`

- **Command:** `/jcc-implement` (lee `CLAUDE.md` y `SPEC.md`; no pegas nada).
- **Objetivo:** construir siguiendo el `SPEC.md`, con puerta de verificación que cierre el bucle. Nada más que lo que el SPEC pide: lo que aparezca de paso se reporta como seguimiento, no se arregla en este cambio.
- **Sesión/modo:** continuar o sesión fresca, **plan mode** para explorar/planificar. Perfil: tabla (calibración v1.5 para Fable 5.1: la puerta de verificación se mantiene **activa**; edición dirigida y agrupación de lecturas independientes en un turno).
- **Ciclo Explorar → Planificar → Codificar → Commit:** plan por pasos (en plan mode) que, si había código, diga EXPLÍCITAMENTE cómo preserva lo listado en "Qué se PRESERVA"; esperas tu visto bueno; codifica imitando los patrones existentes; **puerta de verificación** con evidencia REAL (salida de comando, y regresión verde); cierre con `CLAUDE.md` actualizado si cambió el contrato, y commit (push según la política del proyecto).
- **Coherencia si la realidad cambia el diseño:** cambio **estructural** → mesa común; en todo caso, **ADDENDUM fechado en `DESIGN.md`** y enmienda/creación del SPEC afectado. Así el rastro no miente.
- **Puerta humana:** apruebas el plan; **exiges evidencia real** antes de aceptar "hecho". La fase cierra ofreciéndote la Review, **una por pasada de implementación**.

---

### Fase 4 — Review → `REVIEW.md`

- **Command:** `/jcc-review` (lee `SPEC.md`, `CLAUDE.md` y el repo).
- **Objetivo:** chequeo técnico **independiente** que intenta **refutar** que el trabajo cumple el `SPEC.md` y que no rompió nada. Es la QA independiente del proceso. Entrega UN informe con UN veredicto: el operador dispone sobre una sola lista.
- **Sesión/modo:** **independiente obligatorio** — **subagente con la definición de agente del kit** (`agents/jcc-review.md`: `claude-opus-5`, `high`, otra familia que el implementador; nunca un fork) o sesión aparte con el mismo modelo y effort. Un subagente sin definición heredaría el effort de la sesión: por eso existe la definición. Tres guardas, vinculantes: *etiquetar ≠ filtrar* (gravedad + confianza + cláusula del SPEC por hallazgo; jamás "solo lo importante"), IDs completos en lo durable, vigilancias declaradas (ver *Perfil por fase*).
- **Qué busca, en orden:** regresión (nº1, si había código); cumplimiento del SPEC; correctitud y casos límite; que la verificación pasa de verdad (la ejecuta él, no se fía de la del implementador); fuera de alcance tocado. No revisa estilo ni propone refactors no exigidos. Entrega `REVIEW.md` junto al SPEC (`REVIEW-NN_` si hay varias pasadas): por hallazgo (qué falla, fichero, tipo, gravedad, confianza, cláusula) + veredicto claro.
- **Review loop:** los hallazgos vuelven a la Fase 3 y se re-verifica. **Itera 3↔4 hasta veredicto limpio.** La **re-review de un fix es aditiva**: sección fechada al final del `REVIEW.md` original, sin reescribir la foto; la cadena hallazgos → fixes → re-review se lee en orden en el mismo fichero.

---

### Cierre de sesión → `/jcc-handoff`

- **Command:** `/jcc-handoff`. **Lo disparas tú** al cerrar una sesión para abrir otra fresca.
- **Qué hace** (funde tu ritual de cierre en un acto deliberado y ordena los tres hogares):
  1. Escribe el **handoff** (`HANDOFF_yyyymmdd_<slug>.md`: Feature → en su carpeta, sin subcarpeta; Epic → en su `handoffs/` único): qué se hizo, qué se verificó **con evidencia real**, **qué pasó en qué orden** (hipótesis corregidas y caminos descartados, legible por quien no estuvo: es el hilo temporal del trabajo y solo vive aquí), el **linaje de los recursos operativos** que nombra (de dónde salió cada BD, entorno o despliegue), y una cabecera **"Estado metodológico"** (fase · siguiente command · restricciones activas · evidencia del estado). Describe el estado **al cerrar**, no uno futuro. Si el cierre es **con sucesor** (otra persona, lector externo), ofrece un dossier narrativo generado mientras la conversación vive.
  2. **Antes de recortar, preserva:** cualquier hecho durable que solo viviera en "Fase actual" se mueve a su handoff/README.
  3. **Backport** de lo corregido a TODOS los documentos vigentes que contradiga; un handoff propio aún vigente se **enmienda de forma aditiva** (nota fechada), nunca reescribiendo.
  4. **Sobrescribe** la línea "Fase actual" de `CLAUDE.md` con el puntero corto (edición dirigida; el siguiente command con la barra al inicio).
  5. Actualiza el **README del work item** y el **índice global** `jccdocs/README.md` (incluido el estado de merge/PR: si queda para después del cierre, el índice lo dice y la siguiente sesión lo reconcilia).
  6. Lleva los **pendientes durables** al `### Backlog` de `CLAUDE.md` (podándolo a la vez), te pide **`/usage`** y anota la línea con los números en el handoff, y te **recuerda actualizar la memoria**.
- **Fuente de verdad:** `CLAUDE.md` = estado vivo; README = mapa; handoff = foto fechada con evidencia. No divergen por diseño.
- **El cierre de sesión no es una fase** *(doctrina v1.4)*. El orden de fases es fijo (tras implementar, la siguiente fase es SIEMPRE la review), pero el cierre puede caer **entre cualesquiera fases**: un handoff anterior al veredicto declara honestamente "pendiente de Review". Los handoffs **nunca se reeditan** — la cadena es fotos: handoff pre-veredicto → `REVIEW.md` → fixes → siguiente handoff.
- **Trabajo posterior al propio handoff** *(doctrina v1.4)*: en la **misma** sesión → **ADDENDUM fechado al handoff**; en **otra** sesión → **handoff nuevo**. Nunca se reedita la foto.
- **El handoff ES la instrucción de arranque** de la siguiente sesión: no se generan prompts de arranque aparte; la sesión siguiente abre con el command de su fase al inicio del mensaje y la reconciliación de apertura lee el resto.

---

## Transversal

- **Contrato de pares.** CC conduce lo técnico; tú, estrategia/alcance/restricciones. Ante lo irreversible o que condiciona el futuro, CC lo **sube a la mesa común**.
- **Regresión.** *"No romper lo que ya iba"* es parte de la definición de hecho. **La verificación independiente de transformaciones de DATOS** (anonimizaciones, migraciones, cargas) es la misma cultura que la review de código: quien transforma no es quien comprueba.
- **Los tres hogares + índice global + backlog.** Estado vivo (`CLAUDE.md`, corto, se sobrescribe) · mapa (`README` del work item) · historia (`HANDOFF_` del work item; `handoffs/` en un Epic) · puerta de entrada y estado de merge (`jccdocs/README.md`) · pendientes durables (`### Backlog` de `CLAUDE.md`, curado). CC los mantiene; nunca se apila historia en `CLAUDE.md`, y la evidencia vive una sola vez (en el handoff).
- **Trazabilidad.** Cada work item guarda su `DESIGN`/`SPEC`/`REVIEW`/`HANDOFF` en su carpeta; el índice global lista todo. Es el rastro de auditoría — valioso al no haber revisor humano, y cada vez más al crecer el equipo.
- **Sesiones.** Continúa en la misma mientras el trabajo sea corto. Sesión fresca **recomendada** en cada frontera de fase; **independiente obligatoria** solo en la Review. La **frontera de fase es corte natural sin handoff completo** (la higiene de cierre de fase ES el cierre; medido al 100% en un Feature real); **una fase no se parte entre sesiones sin `/jcc-handoff`**; el patrón multi-sesión **no es obligatorio**. Cada sesión termina con `/usage` y su línea en el handoff. Doctrina completa en *Perfil por fase*.
- **Sesiones fuera del workflow: qué documento produce cada clase.** Tercera aparición de este hueco en el uso real; queda escrito:

  | Clase de sesión | Cómo se abre | Qué produce | Qué hogar toca |
  |---|---|---|---|
  | **Vestíbulo** (día 0, vuelta tras días, sin command claro, compañero nuevo) | `/jcc-start` | nada; en proyecto virgen, el **bootstrap día-0** con tu visto bueno | ninguno (el bootstrap crea los hogares) |
  | **Lectura** (orientación, ponerse al día, historia, vista para otra audiencia) | `/jcc-query` | nada; `BRIEF_yyyymmdd_<slug>.md` solo si pides materializar | README del work item, solo si materializa |
  | **Deliberación del QUÉ** | `/jcc-analysis` | `ANALYSIS` (carpeta standalone o fichero en un Epic) | README/índice sí; "Fase actual" no |
  | **Auditoría de la documentación** | `/jcc-audit` | `AUDIT_yyyymmdd_<slug>.md` | README del work item; nada más |
  | **Comprobación / investigación ligera** (sin command; bajo la línea de arranque del bloque) | sesión suelta | `BRIEF_yyyymmdd_<slug>.md` si la foto merece guardarse; si hubo deliberación, era un Analysis | README, si escribe el BRIEF |
  | **Uso operativo** (correr la herramienta, no desarrollarla) | sesión suelta | **HANDOFF a demanda**: qué se corrió, con qué linaje, qué pasó | README + índice si escribe handoff; "Fase actual" no |
  | **Mantenimiento** | `/jcc-upgrade` | commit de migración + línea en el mapa | punteros y bloque JCC; contenido de los artefactos no |

  La regla de fondo (v1.4) sigue: *reconstruir contexto no es entrar en las fases*. Lo que exime es el tipo de actividad, no la etiqueta de la sesión: si una sesión suelta acaba tocando código o documentos, aplica el contrato del bloque.
- **`/jcc-start` (el vestíbulo; no es una fase).** Detecta el estado del proyecto en tres casos — **virgen** → bootstrap día-0 (bloque JCC + `jccdocs/` + `anexos/` + portada + `.gitignore` de medios antes del primer commit + reglas operativas + `git init`, con visto bueno); **desfasado** (versión del bloque anterior a la de la skill) → avisa y ofrece `/jcc-upgrade`, sin bloquear; **al día** → reconciliación de apertura + mapa corto — y cierra con un **menú de copiloto**: el siguiente command natural y las bifurcaciones según lo que traigas, cada uno con su modelo/effort de la tabla y como instrucción lista para pegar. Recomienda; tú disparas. **Es opcional:** quien sabe a qué viene entra directo por su command de fase, que ya reconcilia. Sin esta línea degeneraría en peaje ritual.
- **`/jcc-analysis` (deliberar el QUÉ; no es una fase).** Entrevista socrática con anclaje, como Design, pero la pregunta es *¿QUÉ hacemos?* o *¿seguimos bien?*, y la salida es un **ANALYSIS fechado registrado** (≈ *Spike*): rastro de primera clase, la diferencia nuclear con query. Prohibido tocar "Fase actual", código o abrir workflow. Cierra con bifurcación: `/jcc-design` con el ANALYSIS como material · ADDENDUM al DESIGN de un Epic · muere documentado. Guardarraíl: si empieza a fijar modelo de datos, contratos o alcance concreto, ya es diseño.
- **`/jcc-query` (vistas para humanos; no es una fase).** La documentación JCC está optimizada para retomar el trabajo; la lectura fácil —ponerse al día, la historia de un work item, el estado para una reunión, un brief para cliente— se **pide, no se mantiene**: un documento-resumen mantenido sería un cuarto hogar duplicando verdad. `/jcc-query` genera la vista bajo demanda al nivel, tono y audiencia que toque (sin argumentos: orientación). La consulta **"historia"** narra a la **altitud y audiencia** pedidas desde lo que los hogares ya capturan: las tensiones del DESIGN, sus ADDENDA, el hilo temporal de los handoffs, la REVIEW — sin inventar el hilo donde falte. Si la vista debe viajar, se **materializa** como `BRIEF_yyyymmdd_<slug>.md` registrado en el README: una **foto** que no se mantiene. Query es *"quiero LEER"*: tiene prohibido ofrecer commands al terminar; para *"vengo a TRABAJAR"* está `/jcc-start`.
- **`/jcc-audit` (auditoría de la documentación; tampoco es una fase).** Revisión independiente y adversarial de los propios documentos ("asume que la documentación miente"): capas **mecánica** (ahora contra el esquema `jccdocs/`: naming, `handoffs/` solo en Epic, letras reservadas, línea de versión del bloque; lo cerrado con nombre antiguo no es hallazgo) y **semántica** siempre; **contraste con la realidad** solo **opt-in** y con alcance acotado, por coste. Solo lectura: entrega `AUDIT_yyyymmdd_<slug>.md` (hallazgos con `fichero:línea`, todo reportado con nivel de confianza) y **no corrige**. Momentos típicos: cierre de Feature o Epic, síntoma de documentación mentirosa, antes de un onboarding, tras un `/jcc-upgrade`; la capa de realidad, antes de un traspaso o un corte.
- **Capa narrativa del camino: capturar / sintetizar / materializar.** No hay hogar narrativo nuevo (una crónica mantenida divergiría). Se **captura** una vez donde ya se escribe: el DESIGN registra las tensiones del encargo y su resolución; el HANDOFF registra qué pasó en qué orden. Se **sintetiza** bajo demanda con `/jcc-query` ("historia", a la altitud pedida). Se **materializa** solo cuando viaja: dossier narrativo en cierres con sucesor o lector externo, generado mientras la conversación vive.
- **`/jcc-upgrade` y el mantenimiento del parque.** La migración de un proyecto al canon vigente es **por proyecto, a demanda, cuando se abre**: `install.ps1` actualiza el kit, `/jcc-start` avisa del desfase, `/jcc-upgrade` propone el plan (receta P2) y lo ejecuta con visto bueno y commit propio, reescribiendo la línea `Bloque JCC vX.Y`. El "sweep" central muere como sesión; queda como opción para repos dormidos, conducido por el mismo command. **La mezcla de versiones en el parque se tolera por diseño**: la doctrina declarada en el `CLAUDE.md` de cada proyecto gana al texto de los skills. La línea de versión lleva la de la **plantilla del bloque**: un patch que no toque el bloque no la cambia, y `jcc-start` no avisará porque no hay nada que migrar.
- **Auto mode: el bloque JCC tiene dos lectores.** Claude y el clasificador de permisos. Las **restricciones operativas durables** (qué no se toca, qué no se ejecuta, qué conectores no se usan, dónde hace falta checkpoint humano) viven en `CLAUDE.md` o en reglas `permissions.ask`/`deny`, **nunca solo en la conversación** (se pierden con la compactación). Las **reglas fuertes** (clase INVIOLABLE) se deciden en mesa y se escriben **en el momento**. Si algún repo tuyo despliega en push, pon el checkpoint: `permissions.ask` para `git push` y `gh pr create`. Las paradas JCC bajo el nudge de auto mode **sostienen**: vigilancia 4/4 positiva documentada en los handoffs del arco (la memoria del proyecto cuenta 5+); validado, sin cambio en las skills.
- **Conectores MCP: opt-in.** Cada proyecto **declara** qué conectores USA (en sus reglas operativas); lo no declarado no entra. La v1.5 fija el principio y lo escribe en el bootstrap; el mecanismo de plataforma que lo haga cumplir es trabajo aparte.
- **Confidencialidad en proyectos de cliente, dos niveles.** El material del cliente nunca sale del repo local; los entregables propios con datos ficticios son publicables por decisión de mesa registrada. El bootstrap lo escribe como regla INVIOLABLE si el proyecto es de cliente.
- **"Slash al inicio" y ruta degradada canónica.** La barra solo dispara el command si el mensaje **EMPIEZA** por ella; mencionarla en prosa o al final no dispara (el coloreado del editor es cosmético). Si la fase te llega como texto sin invocación, la ruta degradada es *leer `~/.claude/skills/jcc-<fase>/SKILL.md` y seguirlo*: el doc público sostiene la estructura, los pasos finos solo viven en el skill (medido: la ruta degradada recupera ~95%; los huecos, memoria y curación de Backlog). El bloque JCC lleva la línea de detección que avisa y ofrece ambas salidas sin bloquear.
- **QA (no es una fase; artefacto derivado a demanda).** La metodología es regresiva por diseño: cada work item produce su superficie de regresión (*"Qué se PRESERVA"*) y sus criterios (*"Verificación"*), y la **Review** es la QA independiente. Esos apartados se pueden compilar en un catálogo de regresión (`jccdocs/regression/`, nombre reservado) cuando un gatillo real lo pida (traspaso formal, hito SaaS). Hasta entonces no se construye nada.
- **Alertador de complejidad.** Señales de que el proyecto pide disciplina formal de spec (p. ej. Spec Kit): el spec se vuelve inmanejable; dependencias cruzadas; re-explicar la arquitectura en cada sesión fresca. Sin umbral fijo; se calibra al cerrar cada trabajo.

---

## Estado del documento

- **v1.5 (2026-09-04): el lado del parque — estructura y workflow.** Contrato de la versión: `evolucion-metodologia/20260904_ALCANCE_CERRADO_v1_5_contrato_ejecutora.md` (solo en el repo privado; consolida los addenda A5–A22 del handoff del 15-08 y el prompt-audit del 03-09; 7 ambigüedades resueltas en mesa antes de ejecutar; 7 paradas de mesa durante la ejecución). Cambios: (1) **Contenedor `jccdocs/` + `anexos/`** en todos los proyectos: muere "producto nuevo → raíz" y `docs/` como cajón de sastre; portada ≠ mapa; test leer-vs-ejecutar; receta de migración por subárbol; doctrina *rigidez de estructura ≠ corsé de pensamiento*; repos hermanos para demos. (2) **Ontología Agile/ALM en inglés como nombres propios**: work item · Epic · Feature · Analysis; SPEC ≈ PBI solo como vocabulario (los nombres de artefacto no cambian); "ciclo" muere → **workflow JCC** con review loop; la Fase 1 pasa a llamarse **Design** y las fases son Design / Spec / Implementation / Review; discriminador Design (CÓMO) vs Analysis (QUÉ). (3) **Naming**: `yyyymmdd_<tipo>_<slug>/` en la raíz de `jccdocs/`, `feature-NN_<slug>/` dentro de un Epic, ficheros `TIPO_yyyymmdd_<slug>.md` con prefijos en inglés (`AUDIT_`, `ANALYSIS_`; `INVESTIGACION_` muere), fecha unificada, partición de namespace (letras reservadas para estructura), siempre carpeta de Epic, **solo lo activo se renombra**; índice global = `jccdocs/README.md`, refrescado en handoffs. (4) **Perfil por fase v2 como fuente única** (sustituye a *Modelo y effort*): Fable 5.1 `high` en todas las sesiones, Opus 5 `high` como revisor **por definición de agente** (`agents/jcc-review.md`, instalada por `install.ps1`; la diversidad de revisor es el argumento, piloto positivo A20); los commands verifican contra la tabla y dejan de recitar modelo/effort; doctrina multi-sesión (frontera de fase sin handoff, medida al 100%; una fase no se parte sin handoff; multi-sesión no obligatorio), doctrina de subagentes (juicio sin derechos de decisión → subagente; trabajo con derechos → sesión), herencia de effort, tres guardas del revisor, ritual `/usage`, patrón sucesor multi-effort gateado. La transición Opus 4.8 → Fable 5.1 se hizo por etiquetas (prompt-audit del 03-09: H1–H6 aplicados, F1 = contrato, F2 añadido, F3 no tocado; keep list K1–K10 con K1 enmendada porque la fase cambió de modelo). (5) **Tres commands nuevos**: `/jcc-analysis` (deliberar el QUÉ con rastro; bifurcación design / ADDENDUM / muere), `/jcc-start` (el vestíbulo: virgen → **bootstrap día-0** (regla B1) · desfasado → ofrece upgrade · al día → reconciliación + menú de copiloto; opcional por diseño), `/jcc-upgrade` (migración por proyecto al canon; muere el sweep central; línea `Bloque JCC vX.Y`; mezcla de versiones tolerada). (6) **Renombrados** `jcc-consulta` → `jcc-query` y `jcc-auditoria` → `jcc-audit` (convención: los commands se nombran en inglés); `install.ps1` retira las copias vivas viejas, instala el agente y `-Check` cubre ambos. (7) **Skills reescritas outcome-first para Fable 5.1** (contrato de resultado y fronteras primero; puertas del operador, numeración de pasos y format-pinning intactos; edición dirigida y batching como calibraciones etiquetadas). (8) **Doctrina escrita**: tabla de sesiones fuera del workflow (vestíbulo, lectura, deliberación, auditoría, comprobación, uso operativo → HANDOFF a demanda, mantenimiento); enmienda aditiva del handoff vivo; re-review aditiva; linaje de recursos e hilo temporal en el handoff; tensiones del encargo en el DESIGN; capa narrativa capturar/sintetizar/materializar; auto mode con dos lectores, restricciones durables en `CLAUDE.md`/ask-rules, reglas fuertes en el momento y receta de checkpoint de push; verificación independiente de transformaciones de datos; conectores MCP opt-in (principio); confidencialidad en dos niveles; "slash al inicio", ruta degradada canónica (~95%) y línea de detección; "la instrucción de arranque ES el comando". (9) **Bloque JCC v1.5**: línea de versión, detección de command no disparado, copiloto con los 10 commands, dos lectores, sección de reglas operativas; la plantilla la escribe `jcc-start` y la migra `jcc-upgrade`. **Vigilancia auto mode**: paradas sostenidas 4/4 en los handoffs del arco (5+ en la memoria del proyecto): validado, sin cambio en las skills. **Verificación**: `install.ps1 -Check` en verde con 10 skills + agente; smoke test en repo desechable (`claude -p`): las 10 skills resuelven por nombre, `$ARGUMENTS` y `${CLAUDE_EFFORT}` sustituyen, ninguna es auto-invocable, el agente aparece con su descripción y herramientas; revisión independiente del diff completo contra el contrato en subagente Opus 5 (otra familia que la ejecutora): 18 hallazgos, 3 bloqueantes corregidos antes de cerrar (copiloto con 9 commands en la plantilla, verificación afirmada sin rastro, auto-invocabilidad del agente no declarada), el resto erratas y huecos menores corregidos o anotados; detalle en `evolucion-metodologia/20260904_HANDOFF_sesion_ejecutora_v1_5.md`. **Post-liberación, misma versión** (con rastro en el contrato §7): publicación al repo público (barrido PII + infra privada); revisión adversarial externa (Fable 5.1 `high`, charter del 04-09) → patches v1.5.x; suite-esqueleto (deuda consciente: la primera versión que protegerá es la v1.6); migración del parque por proyecto con `/jcc-upgrade`; sesión aparte para el mecanismo de conectores MCP opt-in. **Diferido a v1.6 con rastro**: fuente única compilada · doctrina de propiedad por capas · telemetría de válvula · kit de compañero completo (perfil global) · scriptado de la capa mecánica de audit · lectura comparativa de BMAD · GitHub Projects como espejo derivado · orquestación real (N SPECs en worktrees) · crónica narrativa (solo si la captura falla) · hallazgos de redacción #4–#7 y #9 del informe del 30-07 · Fable `medium` en Implementation · Opus 4.8 como revisor alternativo · patrón multi-effort mono-modelo. **Rechazados con razón registrada** (no se reabren sin evidencia nueva): GitHub Projects como almacén, RAG/recuperación semántica, `IMPLEMENTATION.md`, variantes de command por modelo, implementación en subagente, orquestador de fases en sesión, crónica mantenida, hook/capa ejecutable.
- **v1.4 (2026-08-11): el lado de lectura** — cómo se consume y se verifica la documentación (humanos, sesiones frescas, compañeros nuevos). Contrato de la versión: sección "ALCANCE CERRADO" del expediente `evolucion-metodologia/20260802_Expediente_casos_reales_para_v1_4.md` (solo en el repo privado) + §8 del informe externo del 30-07. Cambios: (0) **migración commands→skills** — los prompts de fase pasan a `skills/<nombre>/SKILL.md` (formato vigente tras la fusión de Claude Code v2.1.3), con `disable-model-invocation: true` en todas (invocación explícita por mecanismo, no por defecto de plataforma) y `install.ps1` que además retira las copias legacy; smoke test en repo de juguete antes del resto. (1) **`/jcc-consulta`** nueva: la documentación como historia consultable — sin argumentos, apertura de orientación (el mapa del proyecto); con argumentos, pregunta o vista (historia de un cambio, estado para reunión, brief para cliente); fuera del ciclo de fases, solo lectura salvo materialización `BRIEF_` (foto). (2) **`/jcc-auditoria`** nueva: auditoría independiente y adversarial de la documentación (codifica el charter del 28-jul) en tres capas — mecánica y semántica siempre, contraste con la realidad opt-in y acotada; solo reporta, no corrige. (3) **Línea de arranque en el bloque JCC**: si la tarea toca el trabajo en curso, seguir los punteros antes de opinar; salvaguarda "reconstruir contexto no es entrar en las fases", eximiendo por tipo de actividad (solo-consulta), no por etiqueta de sesión — cubre sesiones ad-hoc y compañeros nuevos (casos 1 y 9 del expediente). (4) **Recalibración de longitud** (etiquetas a v1.4): recortar relleno, no conectivas ni contexto; el criterio es la relectura humana, no la brevedad (caso 10: la calibración anti-verbosidad de la era Opus 5, mantenida bajo 4.8, sobre-condensaba); solo hacia adelante. (5) **Retoques a `/jcc-handoff`**: backport con barrido de TODOS los documentos que la corrección contradiga (caso 4, dos víctimas reales); apunte-receta estática en la memoria del proyecto; "este handoff ES la instrucción de arranque de la siguiente sesión". (6) **Doctrina escrita**: el cierre de sesión no es una fase (y los handoffs nunca se reeditan); mapas vivos vs fotos; trabajo post-handoff (misma sesión → ADDENDUM, otra → handoff nuevo); vistas para humanos. Absorbidos los hallazgos de redacción #2 y #8 del informe externo. **Diferido a v1.5 con rastro** (expediente): fuente única compilada, suite de regresión, doctrina de propiedad por capas, telemetría de válvula, kit de compañero, scriptado de la capa mecánica de la auditoría, hallazgos #4–#7 y #9.
- **v1.3.2 (2026-07-30):** conmutación del perfil de calibración a **Opus 4.8 + effort `xhigh`** (downgrade operativo de estabilización mientras el ecosistema Opus 5 madura), tras la segunda revisión adversarial externa (`evolucion-metodologia/20260730_Analisis_externo_JCC_v1_3_1_ecosistema_y_downgrade_Opus_4_8.md`, solo en el repo privado). Primer uso real de la capa de calibración etiquetada, en sentido inverso: se conmutan SOLO las líneas etiquetadas; todo lo durable de v1.3/v1.3.1 (autoridad, hogares, anclaje, válvula, solo-puntero, backport) queda intacto. Cambios: (1) recordatorios de arranque de `/jcc-design` y `/jcc-implement` conmutados al perfil 4.8 (`xhigh` estándar de sesión); retirado el recordatorio de `ultrathink` (nació para dar profundidad puntual desde `high`; con `xhigh` permanente aporta poco) — la pauta Opus 5 completa queda documentada en *Modelo y effort* para la reentrada. (2) **Puerta de verificación de `/jcc-implement` restaurada a formulación activa** ("ejecuta la verificación"): el riesgo de 4.8 es sub-verificación, no sobre-verificación; y **ahora etiquetada** — la reformulación de v1.2.2 era calibración sin etiqueta (meta-hallazgo del revisor). (3) Etiquetas de longitud y reporta-todo **revalidadas** para 4.8 sin cambio de conducta (disciplinas durables). (4) Dos parches de redacción independientes del modelo, en commit propio: el MODELO de `/jcc-handoff` ya no sugiere `handoffs/` como esquema genérico (contradecía su paso 1) y el "PROHIBIDO añadir contenido nuevo" del cierre de `/jcc-implement` queda acotado a la línea "Fase actual" (chocaba con su paso 4); además, retirada una cita de versión residual en `/jcc-handoff`. Verificado contra disco antes de conmutar: ningún CLAUDE.md del parque replica pauta de modelo/effort (sin sweep). El resto del informe externo (hallazgos de redacción 2, 4–9; suite de regresión de la metodología; migración commands→skills; fuente única compilada) queda **aparcado con rastro** en el propio informe (§8–§9) como insumo de v1.4.
- **v1.3.1 (2026-07-28):** calibración **anti-deferencia**, tras una auditoría de integridad documental sobre un programa real (sesión independiente, evidencia citada) y un análisis externo de los commands. Diagnóstico unificado: Opus 5 difiere a la **autoridad externa** por encima de su juicio anclado en evidencia, en dos direcciones — obedece en silencio decisiones escritas que la evidencia contradice (las reglas anti-reapertura, sin válvula, eran raíles), y capitula ante la duda del usuario sin verificar (una "corrección" falsa llegó a escribirse en un SPEC). Cambios: (1) **válvula de escape** en `/jcc-design` y `/jcc-spec`: si evidencia nueva contradice una decisión previa, ni reabrirla en silencio ni obedecerla en silencio — mesa común con la evidencia; (2) **cierre de fase = solo puntero**: prohibido añadir contenido nuevo a "Fase actual" al cerrar design/spec/implement (el detalle va al artefacto recién creado, los durables al Backlog, el resto espera a `/jcc-handoff`) — mata el mecanismo real de inflación del puntero (cierres de fase sin handoff no daban destino a la información nueva); (3) **"actualizar es también borrar"** en `/jcc-implement`: al tocar CLAUDE.md se elimina lo que el cambio deja obsoleto (dos verdades temporales conviviendo envenenan todas las sesiones futuras); (4) **backport de correcciones** en `/jcc-handoff` (paso 3): lo descubierto que contradice un documento vigente se enmienda ahí antes de cerrar; (5) **cierre de preguntas abiertas** en `/jcc-spec` (fuente primaria o SPEC bloqueado); (6) **anclaje a la realidad** en `/jcc-design` y `/jcc-spec`: afirmaciones sobre el estado actual con evidencia de la sesión o como supuesto explícito (alcanzabilidad ≠ existencia); (7) **reconciliación ampliada** en el bloque JCC: contradicciones internas de CLAUDE.md y trabajo posterior al último handoff sin bitácora. Acompaña (fuera de este repo) un **CLAUDE.md global de usuario** (`~/.claude/CLAUDE.md`) con la regla de anclaje para toda sesión de Claude Code, incluidas las ad-hoc. Verificado contra la documentación oficial: `${CLAUDE_EFFORT}` es sustitución soportada en commands (low/medium/high/xhigh/max). Diferido de nuevo, conscientemente: desduplicar la higiene entre capas (primera candidata de v1.4 si el síntoma de sobre-adherencia persiste). Sin etiqueta de calibración: estos cambios completan el contrato de pares y la higiene (durables), no calibran un modelo concreto.
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
