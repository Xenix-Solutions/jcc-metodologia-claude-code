---
description: "JCC Fase 2 — Especificación: DESIGN.md → SPEC.md autocontenido"
---

Esta fase convierte el diseño en una especificación técnica (Fase 2 de la metodología JCC).
Lee DESIGN.md de este trabajo: es tu fuente de verdad (si sigues en la misma sesión, queda
subordinada a él). Objetivo: un SPEC autocontenido, con detalle suficiente para implementar
sin releer la conversación de diseño.

Mantén el reparto de pares: las decisiones técnicas reversibles las tomas y las documentas;
las ESTRUCTURALES o difíciles de revertir (modelo de datos, abstracciones, contratos, stack)
ponlas sobre la mesa con tu recomendación y deja que las confirme antes de escribir.
AskUserQuestion solo para cerrar forks acotados.

GRANULARIDAD DEL SPEC (guía, no regla): la granularidad SIGUE LA DESCOMPOSICIÓN QUE EL DESIGN
YA ENCONTRÓ. Si el DESIGN partió el trabajo en flujos/bloques, escribe varios specs
(SPEC-01_<slug>.md, SPEC-02_…), cada uno autocontenido y trazado a su decisión de DESIGN. Si
es algo indivisible, un solo SPEC.md. No fuerces ni "siempre modular" ni "siempre monolítico":
lo dicta el análisis.

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
DESIGN.md se consulta para entender el porqué, no para reabrir.

LONGITUD DEL DOCUMENTO (calibración v1.2.1 para Opus 5; revisar al cambiar de modelo): ajústala a lo que el trabajo pide — cubre la sustancia, sin secciones de
relleno, resúmenes redundantes ni boilerplate. Un SPEC no mejora por ser más largo; mejora por ser
inequívoco.

AL CERRAR LA FASE (higiene documental JCC): (1) registra el/los SPEC creados en el README del
cambio (créalo si es un programa o si el cambio ya pasa de ~4 documentos); (2) SOBRESCRIBE la línea
"Fase actual" de CLAUDE.md con un puntero CORTO (cambio/ciclo · fase · siguiente command · enlaces
al README y al último handoff · índice global) — nunca acumules historia ahí. No bloquees.
