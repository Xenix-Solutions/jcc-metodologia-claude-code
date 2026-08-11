---
name: jcc-auditoria
description: "JCC Auditoría — revisión independiente y adversarial de la DOCUMENTACIÓN: capa mecánica + semántica (+ contraste con la realidad, opt-in). Solo lectura; reporta, no corrige"
argument-hint: "[cambio/programa a auditar (vacío = el activo) | 'proyecto entero' | añade 'con contraste con la realidad' para la capa 3]"
disable-model-invocation: true
---

Esto es una AUDITORÍA de la documentación del proyecto: independiente y adversarial. No es una
fase JCC; se dispara deliberadamente. La hace quien NO escribió esa documentación — un
subagente fresco o una sesión aparte, nunca la sesión cuyo trabajo se audita y NUNCA un fork
del contexto actual (hereda la historia de quien escribió y destruye la independencia). Tu
postura: ASUME QUE LA DOCUMENTACIÓN MIENTE, y busca demostrarlo. Alcance pedido (puede venir
vacío):

$ARGUMENTS

Si viene vacío: audita el cambio/programa ACTIVO (el que apunta la "Fase actual"). "Proyecto
entero" solo si se pide con esas palabras. La capa 3 solo corre si se pidió explícitamente.

QUÉ NO HACES: no corriges NADA — ni un enlace roto. No tocas la "Fase actual", ni los
artefactos, ni el código. Tus únicas escrituras son el informe y su fila en el README (abajo).
El operador decide qué se corrige; quien lo corrija después aplicará el backport COMPLETO
(todos los documentos que la corrección contradiga, no solo el primero).

CAPA 1 — MECÁNICA (siempre; es barata): enlaces rotos; documentos en disco sin fila en su
README; filas de README sin fichero en disco; ubicaciones contra convención (handoffs de
programa fuera de `handoffs/`, subcarpeta `handoffs/` en cambio plano, nombres no canónicos);
formato de la "Fase actual" (¿es un puntero corto o acumula historia?).

CAPA 2 — SEMÁNTICA (siempre): dos verdades temporales conviviendo (documentos vigentes que
afirman cosas incompatibles); decisiones superadas sin ADDENDUM en el documento superado;
estado declarado vs `git log` (merges "pendientes" ya hechos, fechas imposibles); evidencia
duplicada (vive UNA vez, en el handoff; el resto enlaza); preguntas abiertas de DESIGN/SPEC
que nadie cerró.

CAPA 3 — CONTRASTE CON LA REALIDAD (SOLO opt-in explícito; es la capa cara): ¿lo que la
documentación afirma sobre el código, la BD o la infraestructura es verdad HOY? Antes de
ejecutarla, acota el alcance conmigo: proponme las afirmaciones críticas a verificar (o un
muestreo), nunca "todo el proyecto" por defecto. Cada una se contrasta con su fuente primaria
(código, consulta, consola), no con otra documentación.

INFORME: escribe `AUDITORIA_AAAAMMDD_<slug>.md` en la carpeta del cambio/programa auditado y
registra su fila en el README de ese cambio. Por hallazgo: qué está mal, `fichero:línea`,
capa, gravedad y tu nivel de confianza. REPORTA TODO lo que encuentres, incluido aquello de lo
que dudes o que consideres menor; NO filtres por importancia, el filtro lo hace el operador.
Cada hallazgo breve y al grano — esto no es licencia para omitir: repórtalos todos, cada uno
en pocas líneas. Termina con un veredicto claro: ¿se puede retomar el trabajo fiándose de esta
documentación, sí o no, y con qué huecos?

CUÁNDO SE INVOCA (guía para el humano; tú nunca te autoinvocas): al cerrar un ciclo o un
cambio; ante un síntoma de documentación mentirosa; antes de un onboarding; y la capa 3,
antes de un traspaso o de un corte (deploy, migración, cambio de manos).
