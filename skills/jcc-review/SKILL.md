---
name: jcc-review
description: "JCC Fase 4 — Review: revisión adversarial INDEPENDIENTE que intenta refutar que cumple el SPEC y no rompe nada"
disable-model-invocation: true
---

Esta es una revisión adversarial e INDEPENDIENTE (Fase 4, Review, de la metodología JCC): la
hace quien NO escribió el código. Tu trabajo es intentar REFUTAR que el trabajo está bien
hecho, no aprobarlo. Es la QA independiente del proceso: sin revisor humano, es la red de
seguridad.

RESULTADO DE ESTA FASE: UN ÚNICO informe `REVIEW.md` con TODOS los hallazgos y UN veredicto
(¿cumple el SPEC y no rompe nada, sí o no, y con qué huecos?), sobre el que el operador dispone.
Lo que NO haces: no corriges código, no propones refactors que el SPEC no exija, no tocas la
"Fase actual" ni los artefactos del trabajo revisado. El filtro de qué se arregla es del
operador, no tuyo.

INDEPENDENCIA Y PERFIL: esta fase corre en sesión fresca o como subagente — y si es subagente,
con la definición de agente del kit (`jcc-review`: `claude-opus-5`, `high`, otra familia que la
sesión implementadora; la diversidad de revisor es el argumento; copia del perfil vigente,
calibración v1.5 — si la tabla cambia, cambia esta línea). Un subagente sin definición
HEREDA el effort de la sesión padre, así que no lo lances sin ella. Dime modelo y effort activos
y contrástalos con la tabla "Perfil por fase" (Review = `claude-opus-5`, `high`, en subagente o
en sesión aparte; copia del perfil vigente, calibración v1.5 — si la tabla cambia, cambia esta
línea y la definición de agente); si no coinciden, anótalo en la cabecera del informe y sigue. Si corres como
subagente, UNO solo — un informe con veredicto único es el contrato, para que el operador
disponga sobre una sola lista — y un subagente de verdad: NUNCA un fork del contexto actual. Un
fork hereda la historia de conversación de quien implementó, y eso destruye justamente la
independencia que da valor a esta fase. Si el modelo con el que corres no es el de la tabla (p.
ej. fallback automático del clasificador de Claude Code, que re-ejecuta en Opus 4.8 las
peticiones marcadas como *cybersecurity* o *biology* y deja la sesión en ese modelo), dilo en la
cabecera: el lector debe saber con qué ojos se revisó. Si el mensaje de lanzamiento dice que la
sesión implementadora sufrió ese fallback, dilo también: ya no sois "otra familia".

Lee el/los SPEC (el contrato) y CLAUDE.md, y revisa la implementación del repo contra ellos.
Postura por defecto: escéptica. Asume que hay huecos y búscalos.

Busca, en este orden:
1. REGRESIÓN (solo si había código existente): ¿sigue funcionando todo lo de "Qué se PRESERVA"?
   ¿Se cambió alguna interfaz o comportamiento que debía quedar intacto? Si hubo migración de
   datos, ¿conserva lo existente sin pérdida ni corrupción?
2. Cumplimiento: ¿está implementado TODO lo que el SPEC exige? Señala lo que falte o esté a
   medias.
3. Correctitud: bugs, casos límite del SPEC no contemplados.
4. Verificación: ¿la verificación del SPEC pasa de verdad (incluida la de regresión)? Ejecútala,
   o di explícitamente que no puedes y por qué. No des por buena la evidencia del implementador:
   la tuya es la que cuenta.
5. Fuera de alcance: ¿se ha tocado o construido algo que el SPEC dijo NO hacer?

NO revises estilo ni preferencias: solo correctitud, regresión y cumplimiento. Si detectas que
el propio SPEC dejó fuera algo crítico, márcalo aparte, como hallazgo sobre el SPEC.

INFORME: escríbelo en `REVIEW.md`, junto al SPEC en la carpeta del work item (Feature plana o
`feature-NN_<slug>/` de un Epic); si ya hay una review de una pasada anterior, la nueva es
`REVIEW-02_<slug>.md` (luego `-03`…) y la primera conserva `REVIEW.md`, nunca se renombra
— un REVIEW por pasada de implementación, no por SPEC. Criterio: FIX = corrige hallazgos de una
review sin cambiar el SPEC → sección aditiva en el REVIEW original (abajo); NUEVA PASADA = el SPEC
cambió o hay código nuevo fuera de los hallazgos → `REVIEW-NN_` nuevo. Por cada hallazgo: qué falla, en qué fichero, tipo (regresión ·
incumplimiento del SPEC · bug · hueco del SPEC), GRAVEDAD, tu nivel de CONFIANZA y la CLÁUSULA
DEL SPEC que incumple (o "sin cláusula" si es un bug fuera de lo especificado). Etiquetar no es
filtrar: REPORTA TODO lo que encuentres, incluido aquello de lo que dudes o que consideres menor;
NO filtres por importancia, el filtro lo hago yo (calibración v1.2.1 nacida para Opus 5,
revalidada en Opus 4.8 en v1.3.2, vigente para Opus 5 — un filtro de gravedad en el prompt
reduce el recall; revisar al cambiar de modelo). Termina con el veredicto claro. Registra el
informe en el README del work item; si no existe, créalo (regla única del doc: el README es
obligatorio desde el primer documento que no sea DESIGN ni SPEC) con qué es el work item y su
índice de documentos.

RE-REVIEW DE UN FIX: si te invocan para re-revisar los fixes de una review anterior, el alcance
es el fix y su regresión, no el trabajo entero; escribe el resultado como SECCIÓN FECHADA
ADITIVA al final del `REVIEW.md` original ("Re-review yyyy-mm-dd: hallazgos H1, H3 cerrados; H2
sigue abierto porque…"), sin reescribir la foto de la review. La cadena hallazgos → fixes →
re-review debe leerse en orden en el mismo fichero.

LONGITUD DEL INFORME (calibración v1.5, revalidada para Fable 5.1 y vigente para Opus 5, el modelo de esta fase; revisar al cambiar de modelo): cada
hallazgo, breve y al grano — recorta relleno, no conectivas ni contexto: el hallazgo tiene que
entenderse de corrido sin descifrar telegramas. Esto NO es licencia para omitir hallazgos:
repórtalos todos, cada uno en pocas líneas.

BUCLE DE CIERRE: los hallazgos vuelven a la Fase 3 (`/jcc-implement`) y se re-verifica. Itera
3↔4 hasta veredicto limpio. Quien registra el veredicto en los hogares NO eres tú: la sesión
orquestadora (la que te lanzó, o la que lea tu informe si corriste en sesión aparte) sobrescribe
"Fase actual" con el veredicto y el siguiente command; el estado "cerrado" del work item lo
escribe `/jcc-handoff` en el índice global. Tú entregas el informe y su fila en el README, y paras.
