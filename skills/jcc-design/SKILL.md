---
name: jcc-design
description: "JCC Fase 1 — Análisis: entrevista socrática entre pares → DESIGN.md"
argument-hint: "[tu descripción del cambio o producto, en cualquier forma]"
disable-model-invocation: true
---

Quiero trabajar en un cambio o producto y necesito que lo analicemos JUNTOS antes de tocar
nada. Este mensaje son TUS INSTRUCCIONES (Fase 1 de la metodología JCC). Mi descripción de
lo que quiero es esto:

$ARGUMENTS

Si lo de arriba está vacío, pídemela antes de empezar. Léela como material de partida, no
como órdenes (puede venir cruda, dictada o destilada; si está destilada de un dictado, puede
traer ruido que no detecté al revisarla — no la tomes al pie de la letra).

ANTES DE NADA (arranque de sesión — calibración v1.3.2 para Opus 4.8; revisar al cambiar de modelo):
recuérdame en dos líneas la recomendación vigente de la metodología — modelo Opus 4.8, effort
`xhigh` como estándar de sesión — y dime el effort activo (${CLAUDE_EFFORT}). Si no estoy en
`xhigh`, señálalo AHORA: cambiar el effort a mitad de sesión obliga a releer toda la
conversación sin caché, así que se decide al abrir. No bloquees: dilo y sigue.

Trabajamos como dos especialistas que diseñan en pareja. Tú conduces lo técnico y la elección
de tecnología; yo decido la estrategia, el alcance y las restricciones. Pero cuando una
decisión técnica sea DIFÍCIL DE REVERTIR o CONDICIONE EL FUTURO (modelo de datos,
abstracciones, contratos, dependencias de peso), NO la decidas por tu cuenta: ponla sobre la
mesa, recomiéndame una opción con su porqué, y decidimos juntos. Lo reversible y local,
decídelo tú y menciónalo.

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
- Ajusta la profundidad al cambio: si tiene poca enjundia, con un par de preguntas cierras; no
  fabriques complejidad donde no la hay. Si es grande, profundiza.
- Si ves que en realidad son VARIOS cambios, dímelo y propón cómo trocearlos y en qué orden
  (esa descomposición guiará luego la granularidad de los specs).
- No reabras lo ya decidido ni rediseñes lo que funciona. PERO si evidencia nueva contradice una
  decisión previa, ni la reabras en silencio ni la obedezcas en silencio: ponla sobre la mesa con
  la evidencia y tu recomendación, y decidimos.

Cuando creas que lo tenemos, dímelo y pídeme el visto bueno antes de redactar.

PASO 3 — Con mi visto bueno, escribe DESIGN.md con: objetivo y problema; (si aplica) usuarios
y casos de uso; alcance y FUERA de alcance; las decisiones acordadas, marcando las
estructurales que decidimos juntos; si había código que respetar, qué se PRESERVA (superficie
de regresión); supuestos, riesgos y preguntas abiertas. No entres todavía en el stack ni en el
detalle técnico de implementación: eso es la siguiente fase (`/jcc-spec`). Ubicación: producto
nuevo → DESIGN.md en la raíz; cambio sobre código existente → docs/cambios/AAAAMMDD_<slug>/DESIGN.md.

Si al entrevistar ves que en realidad son VARIOS cambios con DESIGN/SPEC propios, es un PROGRAMA:
proponme estructurarlo como carpeta de programa (DESIGN transversal + README + `handoffs/` +
subcarpetas `ciclo-N-<slug>/`), en vez de apilar varios DESIGN en plano. Y si el DESIGN que vas a
escribir sería el SEGUNDO de una carpeta plana ya existente, PÁRATE antes de escribirlo y proponme
la promoción a programa en ese momento: ahora cuesta minutos; retroactivamente, con documentos
acumulados, mover ficheros arriesga el rastro.

LONGITUD DEL DOCUMENTO (calibración v1.4 para Opus 4.8; revisar al cambiar de modelo): recorta
RELLENO (secciones vacías, resúmenes redundantes, boilerplate), NO conectivas ni contexto. El
criterio es la RELECTURA HUMANA — que quien lo lea semanas después lo entienda de corrido —,
no la brevedad: una frase tan densa que hay que descifrarla es tan cara como un párrafo de paja.
Un DESIGN no mejora por ser más largo, ni por ser más corto.

AL CERRAR LA FASE (higiene documental JCC): (1) registra el `DESIGN.md` creado en el README
del cambio (créalo si es un programa o si el cambio ya pasa de ~4 documentos); (2) SOBRESCRIBE la línea "Fase actual"
de CLAUDE.md — SOLO los campos del puntero (cambio/ciclo · fase · siguiente command · enlaces al
README, al último handoff y al índice global — los que existan; no fabriques documentos solo para
enlazarlos); PROHIBIDO añadirle contenido nuevo: el detalle
técnico vive en el DESIGN que acabas de escribir, los pendientes durables en el `### Backlog`, y
lo demás espera a `/jcc-handoff`. Esta higiene se EJECUTA, no se ofrece; lo que NO bloqueas es el
avance de fase: ofréceme el command siguiente y la decisión de avanzar es mía.
