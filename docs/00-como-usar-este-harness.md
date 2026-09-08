# 00 · Cómo usar este harness

## Qué es

Un conjunto de acuerdos del equipo sobre cómo se desarrolla software, con tres propiedades:

1. **Están escritos** en `docs/`, para que cualquier persona pueda leerlos y cuestionarlos.
2. **Los conoce el asistente**: `.cursor/rules/` y `AGENTS.md` le dan a Cursor el mismo contexto que a una persona nueva en el equipo.
3. **Se verifican**: `scripts/check.sh` local, hooks de git y GitHub Actions rechazan lo que no cumple.

## Qué no es

- No es un manual de estilo por lenguaje. Eso lo aporta cada módulo en `lenguajes/`, escrito por quienes trabajan con ese lenguaje.
- No impone herramientas. Cada módulo elige su formateador, linter y ejecutor de pruebas, y los expone a través de `check.sh`.
- No reemplaza el criterio. Cuando una regla no aplica a un caso, se explica en el pull request y se sigue adelante.

## Prioridad cuando dos reglas chocan

1. Lo que dice el repositorio concreto (su `AGENTS.md`, su módulo de lenguaje).
2. Lo que dice este harness.
3. El criterio de quien revisa.

Si el choque se repite, se cambia el harness.

## Cómo se cambia

- Por pull request a este repositorio, con la plantilla habitual.
- Cambios de redacción: una aprobación.
- Cambios que alteran cómo se escribe o verifica código: dos aprobaciones y aviso al equipo.
- Cada cambio actualiza las tres formas del lineamiento (documento, regla de Cursor, verificación) o explica por qué no.

## Cómo se propaga a los repositorios

Los repositorios copian los archivos del harness. Cuando el harness cambia, se abre un pull request en cada repositorio afectado con la actualización. Para saber qué versión tiene un repositorio, `scripts/check.sh` imprime la versión declarada en `scripts/VERSION`.
