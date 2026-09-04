---
name: jcc-start
description: "JCC Start — el vestíbulo: detecta el estado del proyecto (virgen → bootstrap día-0 · desfasado → ofrece /jcc-upgrade · al día → reconciliación + mapa) y cierra con el menú de commands. Recomienda; el operador dispara"
argument-hint: "[vacío = detectar y ofrecer menú | lo que vengo a hacer, en una frase, para que me enrutes directo]"
disable-model-invocation: true
---

Vengo a TRABAJAR en este proyecto y quiero arrancar bien. Esto es el vestíbulo de la metodología
JCC: no es una fase, no avanza fases, no toca la "Fase actual" y NUNCA lanza otro command por su
cuenta — recomienda, y yo disparo. Lo que traigo (puede venir vacío):

$ARGUMENTS

Deslinde con `/jcc-query`: query es "quiero LEER" (y tiene prohibido ofrecer commands); start es
"vengo a TRABAJAR" y su cierre es exactamente un menú de commands — incluida query si lo que
quiero es leer. Cuando SÉ a qué vengo, no necesito start: entro directo por el command de fase,
que ya reconcilia al abrir. Start es para el día 0, la vuelta tras días, la sesión sin command
claro y los primeros usos de un compañero.

VERSIÓN DE LA PLANTILLA DEL BLOQUE JCC QUE LLEVA ESTE COMMAND: **v1.5.3** (la compara con la línea
`Bloque JCC vX.Y[.Z]` del CLAUDE.md del proyecto; comparación local, sin red). NO es la versión del
doc de metodología: el doc puede ir por delante en patches que no tocan la plantilla, y eso no es
desfase ni del proyecto ni del kit.

PASO 1 — DETECCIÓN DE ESTADO (solo lectura). Mira `CLAUDE.md` (¿existe? ¿tiene la sección
`## Metodología (JCC)`? ¿qué dice su línea `Bloque JCC vX.Y[.Z]`?), `jccdocs/` (¿existe? ¿tiene
`README.md`?), `git status`/`git log` (¿hay repo? ¿hay historia?). Cuatro casos:

- **VIRGEN** — no hay bloque JCC ni `jccdocs/` → PASO 2 (bootstrap día-0). Si hay código y no
  hay `CLAUDE.md` en absoluto, recomiéndame primero `/init` + curación (el bloque JCC no
  sustituye al contrato del proyecto); si prefiero seguir, crea `CLAUDE.md` solo con el bloque.
- **DESFASADO** — hay bloque JCC pero sin línea de versión (pre-v1.5) o con versión menor que la
  del canon, o la documentación metodológica vive en `docs/cambios/` en vez de `jccdocs/` →
  dímelo en dos líneas (qué versión tiene, qué le falta) y ofréceme `/jcc-upgrade`. NO bloquees:
  si prefiero trabajar hoy sin migrar, la mezcla de versiones se tolera por diseño — los commands
  de fase escriben donde el proyecto YA escribe (su contenedor y esquema actuales), nunca abren un
  `jccdocs/` paralelo; y la doctrina declarada en el CLAUDE.md del proyecto gana al texto de los
  skills. Sigue al PASO 3 con lo que hay.
- **AL DÍA** — bloque v1.5.3 y `jccdocs/` con su README → PASO 3. (Un bloque `v1.5` o `v1.5.2` es
  DESFASADO: al primero le faltan lectura acotada, política de push y el formato de "Fase actual"
  por work item; al segundo, el recuento de la línea padre; `/jcc-upgrade` "solo bloque" lo
  resuelve en minutos.)
- **INCONSISTENTE** — cualquier combinación que no encaje arriba: `jccdocs/` sin bloque JCC;
  bloque v1.5.3 sin `jccdocs/README.md`; bloque con versión MAYOR que la de este command (tu kit
  está viejo: recomiéndame actualizarlo con `install.ps1` desde el repo de la metodología antes de
  tocar nada). Dilo tal cual, di qué falta o sobra, y ofrece `/jcc-upgrade` o `/jcc-start` según
  el caso; no lo arregles tú.

PASO 2 — BOOTSTRAP DÍA-0 (la única escritura de este command; SOLO en proyecto virgen y SOLO con
mi visto bueno sobre el plan completo antes de escribir nada). El bloque JCC nace con el
PROYECTO, no con el primer documento. Pregúntame primero, en una tanda: (a) ¿qué es el proyecto,
en una frase? (b) ¿es un proyecto de cliente? (c) ¿qué conectores MCP USA este proyecto? (ritual
opt-in: lo no declarado no entra; "ninguno" es una respuesta válida) (d) ¿stack previsto, para el
`.gitignore`? (e) ¿política de push: sin push ni PR desde la sesión, push a rama con PR bajo
visto bueno, o libre? ¿el repo despliega en push? (f) ¿lee este proyecto rutas de fuera del repo
(otro repo hermano, un directorio compartido)? Luego propón el plan y, aprobado, ejecuta:
1. `.gitignore` ANTES del primer commit: medios (`*.mp4 *.mov *.mkv *.mp3 *.wav *.m4a`; los
   comprimidos `*.zip *.7z *.iso` solo si me confirmas que no son entregables ni fixtures), basura
   de SO/editor, secretos (`.env`, `*.local.json`) y lo propio del stack. Un vídeo de reunión de
   100 MB en la historia de git obliga a reescribirla; ya pasó.
2. `CLAUDE.md` con el bloque JCC v1.5.3 de abajo (edición dirigida si el fichero ya existe: añade la
   sección, no reescribas el resto) + la sección `## Reglas operativas (INVIOLABLES)` con las
   respuestas de (c), (e) y (f): conectores MCP, lectura acotada y política de push SIEMPRE; la
   confidencialidad en dos niveles, con el remoto privado nombrado, si es de cliente.
3. `jccdocs/README.md` (el MAPA: cabecera con la jerarquía de hogares y la tabla vacía de work
   items) y `anexos/` en la RAÍZ del repo, hermano de `jccdocs/`, nunca dentro (con un `README.md`
   de una línea: "material no metodológico: aportado por el operador o entregables sueltos").
4. `README.md` en la raíz como PORTADA MÍNIMA (qué es + enlaces a `jccdocs/README.md` y
   `CLAUDE.md`); si ya existe, añádele solo los enlaces. Portada ≠ mapa: no dupliques el índice.
5. `git init` si no hay repo, y el primer commit ("bootstrap JCC v1.5.3") con mi visto bueno. Sin
   push: aplica la política que acabas de escribir en Reglas operativas. Si el repo despliega en
   push, propón además el checkpoint `permissions.ask` para `git push` y `gh pr create` en
   `.claude/settings.json` (el compartido por git, no `settings.local.json`) y escríbelo con mi
   visto bueno.

PASO 3 — RECONCILIACIÓN DE APERTURA + MAPA CORTO (proyectos con estructura). Sigue los punteros
(índice global `jccdocs/README.md` → README de CADA work item activo — cada sub-viñeta de "Fase
actual" es un activo: recórrelas todas → su último handoff) y contrasta cada puntero de "Fase
actual" con los artefactos reales y con `git log`. Dime en pocas líneas: qué work items
hay y en qué estado, qué está activo AHORA y en qué fase, y si algo NO cuadra (Fase actual
mentirosa, merge declarado pendiente que ya ocurrió, trabajo posterior al último handoff sin
bitácora). Cántalo; no lo corrijas tú — la corrección es del command de fase o de `/jcc-handoff`.

PASO 4 — MENÚ DE COPILOTO (el cierre de este command). Recomiéndame el siguiente paso y dame la
instrucción de arranque LISTA PARA PEGAR: la barra al INICIO del mensaje y el contexto detrás
(la instrucción de arranque ES el comando). Con cada opción, recuérdame modelo y effort de la
tabla "Perfil por fase" del command que ofreces (hoy: todas las sesiones `claude-fable-5-1`
`high`; la review, subagente `jcc-review` en `claude-opus-5` `high`; copia del perfil vigente,
calibración v1.5 — si la tabla cambia, cambia esta línea). Contenido del menú:
- El **siguiente command natural** según la "Fase actual" (p. ej. `/jcc-spec <ruta al DESIGN>`).
- **Bifurcaciones según lo que traigo**: solo quiero leer o ponerme al día → `/jcc-query`; tengo
  una pregunta de QUÉ hacer o dudo de si seguimos bien → `/jcc-analysis <tema>`; traigo un encargo
  claro → `/jcc-design <encargo>`; sospecho de la documentación → `/jcc-audit` (en una sesión
  APARTE si esta ya escribió algo: el audit no audita lo que su propia sesión escribió); vengo a
  cerrar → `/jcc-handoff`; el bloque está desfasado → `/jcc-upgrade`.
- Si lo que traigo en el argumento ya lo dice ("quiero diseñar X", "ponme al día"), enruta directo:
  una sola recomendación, sin menú entero.
Recomienda; yo disparo. PROHIBIDO: avanzar fases, tocar la "Fase actual", auto-lanzar commands.

---

PLANTILLA DEL BLOQUE JCC v1.5.3 (copia instalada de la plantilla del doc de metodología; si
difieren, manda el doc):

```markdown
## Metodología (JCC)

- **Bloque JCC v1.5.3** (esta línea la reescribe `/jcc-upgrade`; no la edites a mano). Este proyecto se
  desarrolla con la metodología JCC. Doc (URL estable, consultable en sesión):
  https://raw.githubusercontent.com/Xenix-Solutions/jcc-metodologia-claude-code/main/docs/JCC_Metodologia.md
- **Fase actual:** ninguno; el siguiente arranca con `/jcc-design`, `/jcc-analysis` o `/jcc-start`.
  <cuando haya trabajo activo, esta línea padre pasa a decir `**Fase actual:** N activo(s)` y debajo
  va UNA SUB-VIÑETA POR WORK ITEM ACTIVO — lo normal es una —, cada una un puntero CORTO: work
  item · fase (Design / Spec / Implementation / Review) · siguiente command con la barra al inicio
  · enlace al README del work item y a su último handoff · enlace al índice global
  `jccdocs/README.md`. Cada sub-viñeta se SOBRESCRIBE en su transición y se borra al cerrar su
  work item, actualizando el recuento; con cero activos la línea padre vuelve a "ninguno; …";
  NUNCA acumula historia (recuento = N sub-viñetas = N activos; cualquier otra cosa es historia
  mal puesta). En equipo el puntero viaja con la rama: al resolver el conflicto del merge,
  conserva las sub-viñetas de ambas y suma el recuento. Este texto entre <> se borra al escribir
  el primer puntero.>
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
  NO lo invoques tú con la herramienta Skill aunque el mecanismo te lo permita: un command
  mencionado en prosa ("luego haremos /jcc-handoff") no es una orden. No bloquees.
- **Operas como COPILOTO.** En las transiciones de fase, recuerda y ofrece el command que toca
  (`/jcc-design` → `/jcc-spec` → `/jcc-implement` → `/jcc-review`; fuera del workflow:
  `/jcc-analysis`, `/jcc-query`, `/jcc-audit`, `/jcc-start`; cierre: `/jcc-handoff`;
  mantenimiento: `/jcc-upgrade`); **no bloquees**, el usuario decide. Las decisiones **estructurales o difíciles de revertir** van a
  la **mesa común**: no las absorbas. **Mantienes la documentación al día sin que te lo pidan**:
  sobrescribes "Fase actual" (la historia va a los HANDOFF + índice global, NO a esta línea), y
  registras cada documento nuevo en el README del work item. **Ajustas la longitud de cada
  documento a lo que el trabajo pide**: recorta relleno, no conectivas ni contexto — el criterio
  es que un humano pueda releerlo, no la brevedad.
- **Este bloque lo lees tú; el clasificador de permisos (auto mode) puede leerlo, pero no lo hace
  cumplir.** La barrera que el harness SÍ aplica son las reglas `permissions.ask`/`deny` de
  `.claude/settings.json` (el compartido por git, no `settings.local.json`). Por eso las
  restricciones operativas durables — qué no se toca, qué no se ejecuta, qué conectores no se
  usan, dónde hace falta checkpoint humano — viven en este fichero (para ti) Y, las que deban
  hacerse cumplir, en esas reglas (para el harness); **nunca solo en la conversación** (se pierden
  con la compactación). Una regla fuerte que se decida en mesa se escribe aquí EN EL MOMENTO.
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
- **Lectura acotada a este repo.** La sesión no lee rutas fuera de este repo (otros proyectos,
  otros clientes) salvo las declaradas aquí <lista, o "ninguna"> o las que yo te dé explícitamente
  en el mensaje: el sistema de ficheros es el mismo riesgo que los conectores. El kit de la
  metodología bajo `~/.claude/` (skills, agente, memoria) y el doc público de arriba no cuentan
  como "fuera".
- **Política de push.** <una de: "sin push ni PR desde la sesión: los propone, yo los ejecuto" ·
  "push a <rama> permitido; PR solo con mi visto bueno" · "push y PR libres">. Si el repo despliega
  en push, además checkpoint `permissions.ask` para `git push` y `gh pr create` en
  `.claude/settings.json`.
- <solo proyectos de cliente> **Confidencialidad en dos niveles.** El material del CLIENTE
  (documentos, datos, grabaciones, código suyo) NUNCA sale de este repo ni de su remoto privado
  <remoto>: ni a repos públicos, ni a despliegues, ni a servicios de terceros. Los ENTREGABLES
  PROPIOS con datos ficticios son publicables solo por decisión de mesa registrada en el handoff.
```

PLANTILLA DE `jccdocs/README.md` (el mapa; las columnas las fija el doc de metodología en *El índice
global*; si difieren, manda el doc):

```markdown
# <proyecto> — mapa de la documentación JCC

Jerarquía de hogares: estado vivo en `../CLAUDE.md` ("Fase actual") · este índice = todos los work
items · cada work item tiene su `README.md` (mapa) y sus `HANDOFF_` (historia con evidencia).
Naming: `yyyymmdd_<epic|feature|analysis>_<slug>/`; dentro de un Epic, `feature-NN_<slug>/` (sin
fila aquí: van a la tabla del README del Epic). Tipo: `Epic` | `Feature` | `Analysis` | `Audit`
(mayúscula inicial, como la ontología; la minúscula es solo del nombre de carpeta). Estado: activo |
cerrado (cerrado = veredicto limpio + merge/PR resuelto, o decisión del operador anotada en el
handoff). Merge/PR, exactamente uno de estos valores, sin coletillas: `—` · `PR #n abierto` ·
`mergeado yyyy-mm-dd` · `commit directo`.

| Fecha | Tipo | Slug | Qué es | Estado | Merge/PR | Enlaces |
|---|---|---|---|---|---|---|
```
