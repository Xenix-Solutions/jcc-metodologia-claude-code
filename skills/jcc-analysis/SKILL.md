---
name: jcc-analysis
description: "JCC Analysis — deliberar el QUÉ con rastro: entrevista socrática → ANALYSIS fechado (≈ Spike). Fuera del workflow; no abre fases ni toca código"
argument-hint: "[la pregunta o el tema a analizar, en cualquier forma: ¿qué hacemos con X? ¿seguimos bien con Y? ¿merece la pena Z?]"
disable-model-invocation: true
---

Quiero PENSAR contigo qué hacer, antes de decidir si hay algo que diseñar. Esto es un Analysis
de la metodología JCC (≈ un *Spike* ampliado: deliberación con rastro, no exploración técnica
suelta). NO es una fase del workflow: no avanza fases, no toca la "Fase actual", no escribe
código y no abre ningún Feature ni Epic (el Analysis es un work item de deliberación, no de trabajo). Mi tema es esto:

$ARGUMENTS

Si lo de arriba está vacío, pídemelo antes de empezar.

RESULTADO: un ANALYSIS fechado, registrado en su índice (standalone → fila en el índice global
`jccdocs/README.md`; sobre un Epic → README del Epic), que deja escrito qué se preguntó, qué se
comprobó, qué opciones se sopesaron y a qué se llegó — y un cierre con bifurcación explícita
(abajo). La diferencia con `/jcc-query` es esta: query lee y no deja rastro; analysis delibera y
SÍ deja rastro de primera clase. La diferencia con `/jcc-design`: design responde "¿CÓMO hacemos
esto?"; analysis responde "¿QUÉ hacemos?" (o "¿seguimos bien?"). Si mi tema ya cabe en dos frases
claras de encargo, dímelo: no necesito analysis, necesito `/jcc-design`.

Antes de nada, dime en una línea modelo y effort activos (el effort lo inyecta el sistema:
`${CLAUDE_EFFORT}`) y contrástalos con la tabla "Perfil por fase" (Analysis = sesión,
`claude-fable-5-1`, `high`; copia del perfil vigente, calibración v1.5 — si la tabla cambia,
cambia esta línea); si no coinciden, señálalo y sigue.

CÓMO TRABAJAMOS (la misma técnica que en design, porque la entrevista socrática es técnica
compartida, no lo que distingue las dos): entrevístame por tandas cortas de preguntas ABIERTAS
para sacar supuestos, restricciones, contradicciones y lo que no estoy viendo; AskUserQuestion
solo para cerrar una bifurcación ya acotada. Ajusta la profundidad al tema. Si necesitas datos
(código, documentación, BD, mercado), ve a la fuente primaria y cítala.

ANCLAJE A LA REALIDAD: toda afirmación sobre el estado ACTUAL que hagas o escribas debe estar
comprobada en ESTA sesión con su evidencia (fichero:línea, comando, consulta, documento), o
escrita como SUPUESTO explícito. Un análisis sobre supuestos no declarados es una opinión con
formato.

GUARDARRAÍL DE DERIVA: si empiezas a fijar modelo de datos, contratos, arquitectura o alcance
concreto, esto ya es diseño — dilo, propón cerrar el ANALYSIS con lo deliberado hasta ahí y abrir
`/jcc-design` con él como material. No conviertas el analysis en un DESIGN encubierto: el DESIGN
tiene su fase, sus puertas y su hogar.

Cuando creas que lo tenemos, dímelo y pídeme el visto bueno antes de escribir.

EL ARTEFACTO Y SU HOGAR (esquema `jccdocs/`):
- Analysis STANDALONE (aún no hay Epic al que pertenezca; típico pre-proyecto o "¿abrimos esto?")
  → carpeta `jccdocs/yyyymmdd_analysis_<slug>/` con `ANALYSIS.md` (y los `BRIEF_yyyymmdd_<slug>.md`
  que lo alimenten, si los hay), registrada con su fila en el índice global `jccdocs/README.md`.
  Regla única del README aplicada al Analysis: el `ANALYSIS.md` hace el papel del DESIGN; la
  carpeta lleva `README.md` desde el primer documento que no sea él (un BRIEF, un HANDOFF), y lo
  crea quien escribe ese documento.
- Analysis SOBRE UN EPIC existente ("¿seguimos bien con este Epic?", replanteamiento)
  → fichero `ANALYSIS_yyyymmdd_<slug>.md` en la carpeta del Epic, registrado en el README del Epic.
- Si el proyecto aún no tiene `jccdocs/` ni bloque JCC, no improvises estructura: dilo y ofrece
  `/jcc-start` (bootstrap) antes de escribir; si prefiero seguir, crea lo mínimo según el esquema.
- Si el proyecto TIENE bloque JCC pero su documentación metodológica vive FUERA de `jccdocs/`
  (p. ej. `docs/cambios/`; bloque anterior a v1.5), NO escribas en `jccdocs/`: dilo, ofrece
  `/jcc-upgrade`, y si prefiero seguir sin migrar, escribe donde el proyecto ya escribe y con su
  esquema — nunca un segundo contenedor.

CONTENIDO DEL ANALYSIS: la pregunta tal como quedó formulada tras la entrevista (suele cambiar);
el contexto comprobado, con su evidencia; las opciones consideradas con sus pros, contras y
riesgos; tu recomendación con su porqué; lo decidido (si decidimos) o las preguntas que quedan
abiertas y a quién corresponden; y "qué sigue": la rama de la bifurcación que elegimos.

LONGITUD DEL DOCUMENTO (calibración v1.5 para Fable 5.1, revalidada — contrarresta su prosa densa documentada; revisar al cambiar de modelo): recorta
RELLENO (secciones vacías, resúmenes redundantes, boilerplate), NO conectivas ni contexto. El
criterio es la RELECTURA HUMANA — que quien lo lea semanas después lo entienda de corrido —,
no la brevedad: una frase tan densa que hay que descifrarla es tan cara como un párrafo de paja.

CIERRE CON BIFURCACIÓN (ofrécemela explícitamente; yo elijo y yo disparo):
(a) Hay trabajo que diseñar → instrucción de arranque lista para pegar, con la barra al inicio y el
    ANALYSIS como material detrás: `/jcc-design <ruta al ANALYSIS>` (design acepta material en su
    argumento). Recuérdame que puede abrirse en sesión fresca.
(b) Cambia una decisión de un Epic existente → propón el texto de un ADDENDUM fechado al DESIGN
    transversal de ese Epic; se escribe solo con mi visto bueno explícito, y es lo único del
    DESIGN del Epic que este command puede tocar (el README del Epic sí lo actualizas, para
    registrar el ANALYSIS).
(c) Muere documentado → el ANALYSIS registra la decisión de no seguir y su porqué; su fila en el
    índice queda como "cerrado"; nada más que hacer.
Registra el ANALYSIS en su índice (arriba) ANTES de ofrecer la bifurcación (esta higiene se EJECUTA, no
se ofrece). No toques la "Fase actual" de CLAUDE.md: un analysis no es trabajo activo del
workflow; si de él nace un Feature o Epic, será `/jcc-design` quien la escriba.
