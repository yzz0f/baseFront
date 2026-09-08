# 0001 · Adoptar un harness centralizado de lineamientos de desarrollo

- **Estado**: Aceptado
- **Fecha**: 2026-09-08
- **Decisores**: equipo de plataforma
- **Ticket / discusión**: —

## Contexto

El equipo trabaja con varios lenguajes (TypeScript, Python, Java/Kotlin, Go, C#), usa Cursor como IDE principal y GitHub para colaboración. Los lineamientos existían de forma dispersa (wikis, mensajes, memoria de las personas) y no se verificaban automáticamente. Cada repositorio nuevo arrancaba de cero y las convenciones divergían. Además, el uso creciente de asistentes de IA hacía que el código generado no siguiera las convenciones del equipo porque el asistente no las conocía.

## Decisión

Centralizar los lineamientos en un único repositorio template (`baseFront`) con tres capas por regla: documento legible (`docs/lineamientos/`), regla para el asistente (`.cursor/rules/`, `AGENTS.md`) y verificación automática (`pre-commit`, workflows de GitHub Actions reutilizables). Los repositorios del equipo lo adoptan copiando la configuración o invocando la CI reutilizable.

## Alternativas consideradas

| Alternativa | Pros | Contras | Por qué no |
|-------------|------|---------|------------|
| Wiki / Confluence | Fácil de editar | No se versiona con el código, nadie la lee, no se puede verificar | Ya se intentó; divergió |
| Un repo template por lenguaje | Config precisa por stack | Duplicación de lo transversal (git, review, seguridad, IA); N lugares para actualizar | Costo de mantenimiento |
| Sólo linters en cada repo, sin documento | Cero prosa que mantener | No cubre lo que no se puede automatizar (diseño, review, uso de IA) ni explica el porqué | Insuficiente |
| Herramienta comercial de governance | Reportes, dashboards | Costo, lock-in, no integra con Cursor | Prematuro |

## Consecuencias

**Positivas**: un solo lugar para cambiar una regla; onboarding más rápido; la IA genera código alineado; CI consistente sin copiar YAML.

**Negativas / riesgos**: hay que mantener el harness actualizado con las versiones de herramientas; los repos que copian archivos (en vez de referenciar la CI) pueden quedar desactualizados. Mitigación: versionar con tags y revisar trimestralmente.

**Trabajo derivado**: migrar los repositorios existentes uno por uno; configurar branch protection según `docs/lineamientos/01-flujo-git.md`.
