---
name: jcc-consulta
description: "JCC Consulta — leer la documentación como historia: orientación, historia de un cambio, estado para reunión, brief para cliente. Fuera del ciclo de fases; solo lectura"
argument-hint: "[vacío = orientación | pregunta libre | historia de <cambio> | estado para reunión | brief para cliente | ruta a otro proyecto]"
disable-model-invocation: true
---

Quiero CONSULTAR la documentación del proyecto, no avanzar el trabajo. Esto NO es una fase de
la metodología JCC y no entra en su ciclo: no avanza fases, no toca la "Fase actual", ni los
índices, ni ningún artefacto. SOLO LECTURA — con una única excepción, la MATERIALIZACIÓN, y
solo si te la pido (abajo). Mi consulta es esto (puede venir vacía):

$ARGUMENTS

MODO A — SIN CONSULTA (lo de arriba está vacío): apertura de orientación. Yo no tengo el mapa
en la cabeza; dámelo tú. Sigue los punteros (índice global `docs/cambios/README.md` → README
del cambio/programa → último handoff) y contrasta con `git log`. Preséntame en pocas líneas:
qué cambios/programas existen, en qué ciclo y estado está cada uno, y qué hay activo AHORA.
Termina preguntando: ¿sobre qué quieres hablar? De ahí seguimos en conversación libre.

MODO B — CON CONSULTA: responde leyendo la documentación (y el código o `git log` si la
pregunta lo pide), siguiendo los mismos punteros. Consultas típicas que debes reconocer:
- "ponme al día" — el estado del trabajo en curso, para retomar yo el hilo.
- "historia de <cambio>" — el arco completo: qué se pidió, qué se diseñó y por qué, qué se
  implementó, qué dio de sí (review, handoffs). Es narración de lo que los documentos ya
  dicen, al nivel que te pida.
- "estado para reunión" / "brief para cliente" — una vista para OTRA audiencia. Antes de
  redactar, cierra conmigo tono, audiencia y nivel de detalle (AskUserQuestion sirve para
  cerrar estos parámetros).

El alcance por defecto es este proyecto: el cambio activo, uno cerrado o todos. Si te doy una
ruta a otro proyecto, consulta allí con los mismos punteros.

ANCLAJE A LA REALIDAD: lo que afirmes sale de los documentos y se cita (documento concreto, o
`fichero:línea` si entras al código). Si la documentación se contradice entre sí, o con el
código, o con `git log`, NO lo alises en la narración: señálalo como discrepancia (es materia
de `/jcc-auditoria`, no tuya — tú no corriges nada).

MATERIALIZACIÓN (la única escritura permitida, SOLO si te la pido explícitamente): si la vista
debe viajar (reunión, cliente, compañero), escríbela como `BRIEF_AAAAMMDD_<slug>.md` en la
carpeta del cambio/programa consultado y añade su fila al README de ese cambio. Si la vista
abarca varios cambios o el proyecto entero, proponme la ubicación (normalmente la carpeta del
programa o cambio más pertinente) y ciérrala conmigo antes de escribir. Es una FOTO: no se
mantiene ni se reedita; si hace falta otra, se regenera desde la verdad.

RECONSTRUIR CONTEXTO NO ES ENTRAR EN LAS FASES: al terminar no ofrezcas commands de fase ni
`/jcc-handoff` — una sesión de consulta no deja rastro metodológico.

TONO Y LONGITUD: la vista se ajusta al nivel y la audiencia pedidos; el criterio es que un
humano la lea de corrido, no la brevedad ni la completitud del inventario.
