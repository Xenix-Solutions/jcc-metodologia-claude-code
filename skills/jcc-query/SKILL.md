---
name: jcc-query
description: "JCC Query — leer la documentación como historia: orientación, historia de un work item, estado para reunión, brief para cliente. Fuera del workflow; solo lectura"
argument-hint: "[vacío = orientación | pregunta libre | historia de <work item> | estado para reunión | brief para cliente | ruta a otro proyecto]"
disable-model-invocation: true
---

Quiero CONSULTAR la documentación del proyecto, no avanzar el trabajo. Esto NO es una fase del
workflow JCC: no avanza fases, no toca la "Fase actual", ni los índices, ni ningún artefacto.
SOLO LECTURA — con una única excepción, la MATERIALIZACIÓN, y solo si te la pido (abajo).
Deslinde con `/jcc-start`: query es "quiero LEER"; start es "vengo a TRABAJAR" y termina con un
menú de commands. Por eso query tiene PROHIBIDO ofrecer commands al terminar; si de la lectura
sale trabajo, soy yo quien abre `/jcc-start` o el command de fase. Mi consulta es esto (puede
venir vacía):

$ARGUMENTS

MODO A — SIN CONSULTA (lo de arriba está vacío): apertura de orientación. Yo no tengo el mapa
en la cabeza; dámelo tú. Sigue los punteros (índice global `jccdocs/README.md` → README del
work item → último handoff) y contrasta con `git log`. Preséntame en pocas líneas: qué work
items (Epics, Features, Analyses) existen, en qué fase y estado está cada uno, y qué hay activo
AHORA. Termina preguntando: ¿sobre qué quieres hablar? De ahí seguimos en conversación libre.

MODO B — CON CONSULTA: responde leyendo la documentación (y el código o `git log` si la
pregunta lo pide), siguiendo los mismos punteros. Consultas típicas que debes reconocer:
- "ponme al día" — el estado del trabajo en curso, para retomar yo el hilo.
- "historia de <work item>" — el arco completo, narrado a la ALTITUD y para la AUDIENCIA que te
  pida (de "tres líneas para mí" a "para alguien que llega nuevo"): qué se pidió, qué tensiones
  salieron y cómo se resolvieron (las registra el DESIGN), qué se decidió y por qué (DESIGN y sus
  ADDENDA), qué se implementó, qué pasó en qué orden — hipótesis corregidas y caminos descartados
  (lo registran los handoffs) —, qué dio de sí (REVIEW). Es narración desde esos fragmentos que
  los documentos ya guardan; no inventes el hilo donde los documentos no lo tengan: di que falta.
- "estado para reunión" / "brief para cliente" — una vista para OTRA audiencia. Antes de
  redactar, cierra conmigo tono, audiencia y nivel de detalle (AskUserQuestion sirve para
  cerrar estos parámetros).

El alcance por defecto es este proyecto: el work item activo, uno cerrado o todos. Si te doy una
ruta a otro proyecto, consulta allí con los mismos punteros.

ANCLAJE A LA REALIDAD: lo que afirmes sale de los documentos y se cita (documento concreto, o
`fichero:línea` si entras al código). Si la documentación se contradice entre sí, o con el
código, o con `git log`, NO lo alises en la narración: señálalo como discrepancia (es materia
de `/jcc-audit`, no tuya — tú no corriges nada).

MATERIALIZACIÓN (la única escritura permitida, SOLO si te la pido explícitamente): si la vista
debe viajar (reunión, cliente, compañero), escríbela como `BRIEF_yyyymmdd_<slug>.md` en la
carpeta del work item consultado y añade su fila al README de ese work item. Si la vista abarca
varios work items o el proyecto entero, proponme la ubicación (normalmente la carpeta del Epic o
Feature más pertinente) y ciérrala conmigo antes de escribir. Es una FOTO: no se mantiene ni se
reedita; si hace falta otra, se regenera desde la verdad.

RECONSTRUIR CONTEXTO NO ES ENTRAR EN LAS FASES: al terminar no ofrezcas commands de fase, ni
`/jcc-handoff`, ni `/jcc-start` — una sesión de consulta no deja rastro metodológico.

TONO Y LONGITUD: la vista se ajusta al nivel y la audiencia pedidos; el criterio es que un
humano la lea de corrido, no la brevedad ni la completitud del inventario.
