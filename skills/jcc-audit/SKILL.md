---
name: jcc-audit
description: "JCC Audit — revisión independiente y adversarial de la DOCUMENTACIÓN: capa mecánica + semántica (+ contraste con la realidad, opt-in). Solo lectura; reporta, no corrige"
argument-hint: "[work item a auditar (vacío = el activo) | 'proyecto entero' | añade 'con contraste con la realidad' para la capa 3]"
disable-model-invocation: true
---

Esto es una AUDITORÍA de la documentación del proyecto: independiente y adversarial. No es una
fase del workflow JCC; se dispara deliberadamente. La hace quien NO escribió esa documentación:
una SESIÓN APARTE, nunca la sesión cuyo trabajo se audita y NUNCA un fork del contexto actual
(hereda la historia de quien escribió y destruye la independencia). Tampoco un subagente
genérico: en v1.5.1 no hay definición de agente para audit, y un subagente sin definición hereda
el effort de la sesión y no carga esta skill. Tu
postura: ASUME QUE LA DOCUMENTACIÓN MIENTE, y busca demostrarlo. Alcance pedido (puede venir
vacío):

$ARGUMENTS

Si viene vacío: audita el/los work items ACTIVOS (los que apuntan las sub-viñetas de "Fase
actual"; si hay varias, todos). "Proyecto entero"
solo si se pide con esas palabras. La capa 3 solo corre si se pidió explícitamente.

RESULTADO: un informe con TODOS los hallazgos (cada uno con `fichero:línea`, capa, gravedad y
confianza) y un veredicto: ¿se puede retomar el trabajo fiándose de esta documentación, sí o no,
y con qué huecos? El operador decide qué se corrige.

QUÉ NO HACES: no corriges NADA — ni un enlace roto. No tocas la "Fase actual", ni los
artefactos, ni el código. Tus únicas escrituras son el informe y su fila en el README (abajo).
Quien lo corrija después aplicará el backport COMPLETO (todos los documentos que la corrección
contradiga, no solo el primero).

CAPA 1 — MECÁNICA (siempre; es barata), contra el esquema `jccdocs/` de la metodología: enlaces
rotos (salvo los declarados como "rotos aceptados" en la cabecera del índice global tras una
migración o promoción: informativo); documentos en disco sin fila en su README; README del work
item ausente cuando ya hay un documento que no es DESIGN ni SPEC (en un Analysis standalone, que
no es `ANALYSIS.md`); sección `## Reglas operativas
(INVIOLABLES)` de CLAUDE.md ausente o sin sus líneas fijas (conectores MCP, lectura acotada,
política de push); columna Merge/PR del índice global ausente o con valores fuera del cerrado; filas de README sin fichero en disco; work
items ACTIVOS con nombre fuera del canon (raíz de `jccdocs/`: `yyyymmdd_<tipo>_<slug>/` con tipo
epic | feature | analysis; dentro de un Epic: `feature-NN_<slug>/`; ficheros fechados
`TIPO_yyyymmdd_<slug>.md`); `handoffs/` fuera de un Epic, o handoffs de Epic sueltos por
`feature-NN_` (salvo los HANDOFF anteriores a una promoción a Epic: fotos, listadas como aceptadas
en la cabecera del índice global — informativo); nombres que empiezan por letra en la raíz de `jccdocs/` que no sean estructura
declarada (`README.md`, `regression/`, `audits/`, `ARCHIVE.md`); documentación metodológica fuera
de `jccdocs/` (en `docs/`, en la raíz) o utillaje ejecutable dentro; portada de raíz que duplica el
mapa; formato de la "Fase actual" (recuento de la línea padre = N sub-viñetas = N work items
activos, cada una un puntero corto; con cero, "ninguno; …"; cualquier otra cosa es historia
acumulada); línea de versión
del bloque JCC ausente o anterior a la de la skill instalada; columna Tipo del índice global con
valores fuera de `Epic` | `Feature` | `Analysis` | `Audit` (mayúscula inicial). Los work items
CERRADOS con nombre de un esquema anterior NO son hallazgo (solo lo activo se renombra), y tampoco
lo son los FICHEROS anteriores al esquema (`HANDOFF-NN_`, `BITACORA_`, `INVESTIGACION-`…) aunque
vivan dentro de un work item activo: los ficheros existentes no se renombran (doc, *Naming*).
Lístalos aparte como informativo.

CAPA 2 — SEMÁNTICA (siempre): dos verdades temporales conviviendo (documentos vigentes que
afirman cosas incompatibles); decisiones superadas sin ADDENDUM en el documento superado;
handoffs vigentes enmendados reescribiendo el cuerpo en vez de con nota fechada; re-reviews que
reescribieron la review original en vez de añadir sección fechada; estado declarado vs `git log`
(merges "pendientes" ya hechos, fechas imposibles); evidencia duplicada (vive UNA vez, en el
handoff; el resto enlaza); preguntas abiertas de DESIGN/SPEC que nadie cerró; recursos operativos
nombrados sin linaje.

CAPA 3 — CONTRASTE CON LA REALIDAD (SOLO opt-in explícito; es la capa cara): ¿lo que la
documentación afirma sobre el código, la BD o la infraestructura es verdad HOY? Antes de
ejecutarla, acota el alcance conmigo: proponme las afirmaciones críticas a verificar (o un
muestreo), nunca "todo el proyecto" por defecto. Cada una se contrasta con su fuente primaria
(código, consulta, consola), no con otra documentación.

INFORME: escribe `AUDIT_yyyymmdd_<slug>.md` en la carpeta del work item auditado (si es
"proyecto entero", proponme la ubicación: `jccdocs/audits/` es el nombre reservado para ello) y
registra su fila en el README correspondiente (el del work item; si no existe, créalo — regla
única del doc —; en "proyecto entero", el índice global con Tipo `Audit`). Por hallazgo: qué está mal, `fichero:línea`,
capa, gravedad y tu nivel de confianza. REPORTA TODO lo que encuentres, incluido aquello de lo
que dudes o que consideres menor; NO filtres por importancia, el filtro lo hace el operador
(calibración v1.2.1 heredada de /jcc-review, PENDIENTE de revalidar en el modelo en que corra —
un filtro de gravedad en el prompt reduce el recall; revisar al cambiar de modelo).
Cada hallazgo breve y al grano — esto no es licencia para omitir: repórtalos todos, cada uno
en pocas líneas. Termina con el veredicto claro.

CUÁNDO SE INVOCA (guía para el humano; tú nunca te autoinvocas): al cerrar un Feature o un Epic;
ante un síntoma de documentación mentirosa; antes de un onboarding; tras una migración con
`/jcc-upgrade`; y la capa 3, antes de un traspaso o de un corte (deploy, migración, cambio de
manos).
