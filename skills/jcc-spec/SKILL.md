---
name: jcc-spec
description: "JCC Fase 2 — Spec: DESIGN.md → SPEC.md autocontenido (SPEC ≈ PBI)"
argument-hint: "[opcional: ruta al DESIGN.md del work item]"
disable-model-invocation: true
---

Esta fase convierte el diseño en una especificación técnica (Fase 2, Spec, de la metodología JCC).

RESULTADO DE ESTA FASE: uno o varios SPEC autocontenidos, con detalle suficiente para implementar
sin releer la conversación de diseño ni este chat. Tiene que valer por sí solo: la siguiente fase
puede abrirse en sesión fresca y con otro modelo, así que todo lo que Implementation necesite
debe estar en el artefacto. Lo que NO hace esta fase: no implementa, no reabre lo decidido en el
DESIGN (salvo evidencia nueva, abajo), no avanza de fase por su cuenta.

Antes de nada, dime en una línea modelo y effort activos (el effort lo inyecta el sistema:
`${CLAUDE_EFFORT}`) y contrástalos con la tabla "Perfil por fase" (Spec = sesión,
`claude-fable-5-1`, `high`); si no coinciden, señálalo y sigue.

Lee DESIGN.md de este work item (si el mensaje trae una ruta detrás del command, es ese): es tu fuente de verdad (si sigues en la misma sesión que el
diseño, la conversación queda subordinada a él).

Mantén el reparto de pares: las decisiones técnicas reversibles las tomas y las documentas;
las ESTRUCTURALES o difíciles de revertir (modelo de datos, abstracciones, contratos, stack)
ponlas sobre la mesa con tu recomendación y deja que las confirme antes de escribir.
AskUserQuestion solo para cerrar forks acotados.

PREGUNTAS ABIERTAS DEL DESIGN: si el DESIGN deja preguntas abiertas que afectan a este SPEC,
ciérralas PRIMERO contra la fuente primaria (documentación oficial, código, datos) o declara el
SPEC bloqueado por ellas. No especifiques sobre una incógnita.

ANCLAJE A LA REALIDAD: toda afirmación sobre el estado ACTUAL que escribas en el SPEC ("ya existe
X", "la UI permite Y", "los datos están en Z", el catálogo de verificación) debe estar comprobada
en ESTA sesión con su evidencia (fichero:línea, comando, consulta), o escrita como SUPUESTO
explícito. Ojo con la alcanzabilidad: que algo exista en el código no significa que el usuario
llegue a ello.

GRANULARIDAD DEL SPEC (guía, no regla): la granularidad SIGUE LA DESCOMPOSICIÓN QUE EL DESIGN
YA ENCONTRÓ. Si el DESIGN partió el trabajo en flujos/bloques, escribe varios specs
(SPEC-01_<slug>.md, SPEC-02_…), cada uno autocontenido y trazado a su decisión de DESIGN. Si
es algo indivisible, un solo SPEC.md. No fuerces ni "siempre modular" ni "siempre monolítico":
lo dicta el análisis. Un SPEC ≈ un PBI: van PLANOS junto al DESIGN, sin subcarpeta. Si la carpeta
se llena de SPEC hasta volverse ilegible, eso pide la promoción a Epic que `/jcc-design` sabe
proponer, no una subcarpeta.

Adapta el spec a si hay código que respetar:
- PRODUCTO NUEVO (nada que preservar): elige stack y arquitectura respetando las restricciones
  de DESIGN.md, y especifica la estructura completa.
- CÓDIGO EXISTENTE: respeta el stack dado y especifica solo el DELTA (qué se añade/modifica/
  elimina), qué se PRESERVA (regresión) y la migración si aplica.

Cuando tengas resueltas las decisiones, dímelo y pídeme el visto bueno. Con mi aprobación,
escribe el/los SPEC (junto a su DESIGN.md) con:
1. Resumen — qué se construye o cambia, en 1-2 frases (el porqué vive en DESIGN.md).
2. Stack y arquitectura — decisiones técnicas con justificación breve (si hay código existente:
   el stack dado y cómo encaja el cambio en él).
3. Estructura / Delta — ficheros y módulos. Nuevo: estructura completa. Cambio: ADDED /
   MODIFIED / REMOVED.
4. Interfaces y contratos — funciones/APIs/modelo de datos clave, sin ambigüedad.
5. Qué se PRESERVA — solo si hay código existente: lo que NO debe cambiar (regresión).
6. Migración de datos — solo si aplica.
7. Fuera de alcance — lo que NO se toca.
8. Verificación — cómo se comprueba de extremo a extremo; si había código existente, incluye
   comprobar que la regresión sigue verde. Crea tests si la zona no los tiene.

(Los apartados 5 y 8 están pensados para poder compilarse algún día en un catálogo de
regresión; escríbelos autocontenidos y reutilizables.)

Reglas: si una sección no aplica, omítela. Si SPEC y DESIGN.md se contradicen, manda el SPEC;
DESIGN.md se consulta para entender el porqué, no para reabrir. PERO si evidencia nueva te dice
que una decisión del DESIGN es errónea, ni la reabras en silencio ni la obedezcas en silencio:
mesa común con la evidencia y tu recomendación (y ADDENDUM fechado en el DESIGN si se cambia).

LONGITUD DEL DOCUMENTO (calibración v1.5 para Fable 5.1, revalidada — contrarresta su prosa densa documentada; revisar al cambiar de modelo): recorta
RELLENO (secciones vacías, resúmenes redundantes, boilerplate), NO conectivas ni contexto. El
criterio es la RELECTURA HUMANA — que quien lo lea semanas después lo entienda de corrido —,
no la brevedad. Un SPEC no mejora por ser más largo ni más corto; mejora por ser inequívoco.

AL CERRAR LA FASE (higiene documental JCC; se EJECUTA, no se ofrece): (1) registra el/los SPEC
creados en el README del work item (créalo si es un Epic o si el work item ya pasa de ~4
documentos); (2) SOBRESCRIBE la línea "Fase actual" de CLAUDE.md — SOLO los campos del puntero
(work item · fase · siguiente command · enlaces al README, al último handoff y al índice global
`jccdocs/README.md` — los que existan; no fabriques documentos solo para enlazarlos); edítala con
EDICIÓN DIRIGIDA — toca solo esa sección, no reescribas CLAUDE.md entero (calibración v1.5 para
Fable 5.1 — tiende a reescribir ficheros completos; revisar al cambiar de modelo); PROHIBIDO
añadirle contenido nuevo: el detalle técnico vive en el/los SPEC que acabas de escribir, los
pendientes durables en el `### Backlog`, y lo demás espera a `/jcc-handoff`. Lo que NO bloqueas
es el avance de fase: la decisión de avanzar es mía. Ofréceme el siguiente paso como instrucción
de arranque lista para pegar — la barra al INICIO del mensaje y el contexto detrás, en el mismo
mensaje (p. ej. `/jcc-implement <ruta al SPEC>`): la instrucción de arranque ES el comando.
Recuerda que Implementation puede abrirse en sesión fresca.
