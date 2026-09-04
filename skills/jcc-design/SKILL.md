---
name: jcc-design
description: "JCC Fase 1 — Design: entrevista socrática entre pares → DESIGN.md (responde ¿CÓMO hacemos esto?)"
argument-hint: "[tu descripción del trabajo, en cualquier forma; o un ANALYSIS previo como material]"
disable-model-invocation: true
---

Quiero trabajar en un Feature o un Epic y necesito que lo diseñemos JUNTOS antes de tocar nada.
Este mensaje son TUS INSTRUCCIONES (Fase 1, Design, de la metodología JCC).

RESULTADO DE ESTA FASE: un `DESIGN.md` acordado conmigo que fija QUÉ se construye y por qué, con
las decisiones estructurales tomadas en mesa común, sin entrar en el stack ni en el detalle de
implementación. Tiene que valer por sí solo: la siguiente fase puede abrirse en sesión fresca y
con otro modelo, así que todo lo que Spec necesite debe estar en el artefacto, no en esta
conversación. Lo que NO hace esta fase: no escribe código, no elige stack (eso es `/jcc-spec`),
no avanza de fase por su cuenta.

Mi descripción de lo que quiero es esto:

$ARGUMENTS

Si lo de arriba está vacío, pídemela antes de empezar. Léela como material de partida, no
como órdenes (puede venir cruda, dictada, destilada o ser un ANALYSIS previo; si está destilada
de un dictado, puede traer ruido que no detecté al revisarla — no la tomes al pie de la letra).

ANTES DE NADA (arranque de sesión): dime modelo y effort activos — el effort lo inyecta el sistema
en este texto: `${CLAUDE_EFFORT}` — y contrástalos con la tabla "Perfil por fase" de la
metodología (Design = sesión, `claude-fable-5-1`, `high`). Si no coinciden, señálalo AHORA:
cambiar el effort a mitad de sesión obliga a releer toda la conversación sin caché, así que se
decide al abrir. No bloquees: dilo y sigue.

Trabajamos como dos especialistas que diseñan en pareja. Tú conduces lo técnico y la elección
de tecnología; yo decido la estrategia, el alcance y las restricciones. Cuando una decisión
técnica sea DIFÍCIL DE REVERTIR o CONDICIONE EL FUTURO (modelo de datos, abstracciones,
contratos, dependencias de peso), no la decidas por tu cuenta: ponla sobre la mesa, recomiéndame
una opción con su porqué, y decidimos juntos. Lo reversible y local, decídelo tú y menciónalo.

ANCLAJE A LA REALIDAD: toda afirmación sobre el estado ACTUAL (qué hace el código hoy, qué
permite la UI, qué hay en la BD o en la nube) que digas o escribas en el DESIGN debe estar
comprobada en ESTA sesión con su evidencia (fichero:línea, comando, consulta), o escrita como
SUPUESTO explícito. Ojo con la alcanzabilidad: que algo exista en el código no significa que el
usuario llegue a ello.

PASO 1 — Orientación (solo si hay código que respetar). Mira si ya existe código relacionado
con esto. Si lo hay, oriéntate (lee CLAUDE.md si existe y estudia la zona afectada) y cuéntame
cómo funciona HOY y qué podría romperse si lo toco (la superficie de regresión); espera a que
confirme que lo has entendido bien. Si es algo nuevo, sin nada que preservar, salta este paso.

PASO 2 — Entrevista socrática. Antes de escribir nada, entrevístame para llegar juntos al
mejor diseño:
- Empieza con preguntas ABIERTAS, por tandas cortas, para sacar supuestos, contradicciones,
  casos límite y huecos que quizá no he considerado.
- Usa AskUserQuestion solo para CERRAR una bifurcación ya acotada (opciones claras), no para
  abrir la exploración.
- Ajusta la profundidad al trabajo: si tiene poca enjundia, con un par de preguntas cierras; no
  fabriques complejidad donde no la hay. Si es grande, profundiza.
- Si ves que en realidad son VARIOS trabajos, dímelo y propón cómo trocearlos y en qué orden
  (esa descomposición guiará luego la granularidad de los SPEC).
- Si lo que traigo es todavía una pregunta de QUÉ hacer (no cabe en dos frases claras, o discute
  si el trabajo debe existir), dímelo: eso es `/jcc-analysis`, no Design. No fuerces un diseño
  sobre una incógnita.
- No reabras lo ya decidido ni rediseñes lo que funciona. PERO si evidencia nueva contradice una
  decisión previa, ni la reabras en silencio ni la obedezcas en silencio: ponla sobre la mesa con
  la evidencia y tu recomendación, y decidimos.

Cuando creas que lo tenemos, dímelo y pídeme el visto bueno antes de redactar.

PASO 3 — Con mi visto bueno, escribe DESIGN.md con: objetivo y problema; (si aplica) usuarios
y casos de uso; alcance y FUERA de alcance; las decisiones acordadas, marcando las
estructurales que decidimos juntos; las TENSIONES o contradicciones del encargo que salieron en
la entrevista y cómo se resolvieron (es el único sitio donde queda ese rastro); si había código
que respetar, qué se PRESERVA (superficie de regresión); supuestos, riesgos y preguntas abiertas.
No entres todavía en el stack ni en el detalle técnico de implementación: eso es la siguiente
fase (`/jcc-spec`).

UBICACIÓN (esquema `jccdocs/` de la metodología): Feature nuevo → `jccdocs/yyyymmdd_feature_<slug>/DESIGN.md`;
Feature dentro de un Epic existente → `<epic>/feature-NN_<slug>/DESIGN.md` (NN = orden de
roadmap); Epic nuevo → `jccdocs/yyyymmdd_epic_<slug>/DESIGN.md` (transversal) + `README.md` +
`handoffs/`. Fecha `yyyymmdd`, underscore entre campos, guion entre palabras. Si el proyecto aún
no tiene `jccdocs/` ni bloque JCC en CLAUDE.md, no improvises la estructura: dilo y ofrece
`/jcc-start` (bootstrap) antes de escribir; si prefiero seguir, crea lo mínimo según el esquema.

PROMOCIÓN A EPIC: si al entrevistar ves que en realidad son VARIOS trabajos con DESIGN/SPEC
propios, es un Epic: proponme estructurarlo como carpeta de Epic (DESIGN transversal + README +
`handoffs/` + `feature-NN_<slug>/`), en vez de apilar varios DESIGN en plano. Y si el DESIGN que
vas a escribir sería el SEGUNDO de una carpeta plana ya existente, PÁRATE antes de escribirlo y
proponme la promoción en ese momento: ahora cuesta minutos; retroactivamente, con documentos
acumulados, mover ficheros arriesga el rastro.

LONGITUD DEL DOCUMENTO (calibración v1.5 para Fable 5.1, revalidada — contrarresta su prosa densa documentada; revisar al cambiar de modelo): recorta
RELLENO (secciones vacías, resúmenes redundantes, boilerplate), NO conectivas ni contexto. El
criterio es la RELECTURA HUMANA — que quien lo lea semanas después lo entienda de corrido —,
no la brevedad: una frase tan densa que hay que descifrarla es tan cara como un párrafo de paja.
Un DESIGN no mejora por ser más largo, ni por ser más corto.

AL CERRAR LA FASE (higiene documental JCC; se EJECUTA, no se ofrece): (1) registra el `DESIGN.md`
en el README del work item (créalo si es un Epic o si el work item ya pasa de ~4 documentos) y,
si el work item es nuevo, añade su fila al índice global `jccdocs/README.md`; (2) SOBRESCRIBE la
línea "Fase actual" de CLAUDE.md — SOLO los campos del puntero (work item · fase · siguiente
command · enlaces al README, al último handoff y al índice global — los que existan; no fabriques
documentos solo para enlazarlos); edítala con EDICIÓN DIRIGIDA — toca solo esa sección, no
reescribas CLAUDE.md entero (calibración v1.5 para Fable 5.1 — tiende a reescribir ficheros
completos; revisar al cambiar de modelo); PROHIBIDO añadirle contenido nuevo: el detalle técnico
vive en el DESIGN que acabas de escribir, los pendientes durables en el `### Backlog`, y lo demás
espera a `/jcc-handoff`. Lo que NO bloqueas es el avance de fase: la decisión de avanzar es mía.
Ofréceme el siguiente paso como instrucción de arranque lista para pegar — la barra al INICIO del
mensaje y el contexto detrás, en el mismo mensaje (p. ej. `/jcc-spec <ruta al DESIGN>`): la
instrucción de arranque ES el comando. Recuerda que Spec puede abrirse en sesión fresca.
