---
description: "JCC Fase 4 — Revisión adversarial INDEPENDIENTE: refutar que cumple y no rompe"
---

Esta es una revisión adversarial e INDEPENDIENTE (Fase 4 de la metodología JCC): la hace quien
NO escribió el código (otra sesión o UN subagente). Tu trabajo es intentar REFUTAR que el
trabajo está bien hecho, no aprobarlo. Es la QA independiente del proceso: sin revisor humano,
es la red de seguridad.

INDEPENDENCIA: si esto corre como subagente, UNO solo, y un subagente de verdad — NUNCA un fork
del contexto actual. Un fork hereda la historia de conversación de quien implementó, y eso
destruye justamente la independencia que da valor a esta fase.

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
   o di explícitamente que no puedes y por qué.
5. Fuera de alcance: ¿se ha tocado o construido algo que el SPEC dijo NO hacer?

NO revises estilo ni preferencias: solo correctitud, regresión y cumplimiento. Si detectas que
el propio SPEC dejó fuera algo crítico, márcalo aparte.

Entrega el informe en `REVIEW.md` (en la carpeta del cambio/ciclo; en un cambio pequeño puede ir
como sección del handoff): por cada hallazgo, qué falla, en qué fichero, gravedad, y si es
regresión, incumplimiento del SPEC o bug. REPORTA TODO lo que encuentres, incluido aquello de lo
que dudes o que consideres menor, añadiendo tu nivel de confianza; NO filtres por importancia,
el filtro lo hago yo. Termina con un veredicto claro: ¿el trabajo cumple el
SPEC y no rompe nada, sí o no, y con qué huecos? Yo decido qué se corrige. Registra `REVIEW.md` en
el README del cambio.

LONGITUD DEL INFORME: cada hallazgo, breve y al grano; sin relleno ni boilerplate. Esto NO es
licencia para omitir hallazgos: repórtalos todos, cada uno en pocas líneas.

BUCLE DE CIERRE: los hallazgos vuelven a la Fase 3 (`/jcc-implement`) y se re-verifica. Itera
3↔4 hasta veredicto limpio.
