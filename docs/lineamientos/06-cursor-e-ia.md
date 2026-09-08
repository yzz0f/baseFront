# 06 · Cursor y asistentes de IA

Usamos Cursor (y ocasionalmente otros asistentes: Copilot, Claude Code, Codex) para escribir código más rápido. La regla central es simple: **la IA es una herramienta del autor, no un autor**. Todo lo que se commitea es responsabilidad de la persona que lo commitea.

## Cómo está configurado

| Archivo | Para qué |
|---------|----------|
| `AGENTS.md` | Contrato general para cualquier agente: contexto del equipo, cómo trabajar, qué no hacer. Lo leen Cursor, Copilot, Claude Code y Codex. |
| `.cursor/rules/00-general.mdc` | Reglas siempre activas (`alwaysApply: true`). Resumen de este harness. |
| `.cursor/rules/40-seguridad.mdc` | Reglas de seguridad siempre activas. |
| `.cursor/rules/2x-<lenguaje>.mdc` | Se activan por `globs` cuando se editan archivos de ese lenguaje. |
| `.cursor/rules/10-git-y-pr.mdc`, `30-testing.mdc` | Se activan por descripción cuando la tarea lo amerita, o manualmente con `@`. |

Cada repositorio **puede** agregar reglas propias en `.cursor/rules/` (por ejemplo `50-dominio-pagos.mdc`) con conocimiento específico: entidades, invariantes, decisiones de arquitectura. Ese es el mejor lugar para poner lo que hoy está en la cabeza de dos personas.

Las reglas del harness se actualizan copiando desde este repo; no se editan localmente (si algo hay que cambiar, se cambia acá).

## Buenas prácticas de uso

**Contexto explícito.** Referenciar con `@` los archivos, carpetas o docs relevantes. Cuanto más contexto real le das, menos inventa. Para tareas grandes, empezar con un plan (modo *Ask* o *Plan*) y recién después ejecutar.

**Tareas acotadas.** Pedir un cambio a la vez. "Agregá validación de email al formulario de registro" funciona; "mejorá el módulo de usuarios" produce cambios enormes y difíciles de revisar.

**Revisar todo el diff.** Antes de aceptar, leer cada línea que propone. Preguntarse:
- ¿Existe esta función / paquete / versión? (la IA inventa APIs con frecuencia)
- ¿Reutiliza lo que ya hay en el repo o duplicó lógica?
- ¿El manejo de errores es explícito o metió un `catch` vacío?
- ¿Los tests afirman algo relevante o sólo ejecutan código?
- ¿Cambió algo fuera del alcance de lo que pedí?

**Verificar ejecutando.** Correr `./scripts/check.sh` (o los tests del repo) después de aceptar cambios. Los agentes pueden hacerlo solos; pedirles que reporten el resultado real.

**Iterar con el linter, no contra él.** Si el asistente propone `eslint-disable`, `# noqa`, `#nolint` o similares, casi siempre es señal de que la solución está mal. Pedirle que arregle el código.

**Declarar el uso.** Si una parte significativa del PR fue generada por IA, marcar la casilla en la plantilla del PR. No es una penalización: ayuda al reviewer a saber dónde mirar.

## Qué no hacer

- **No pegar secretos ni datos personales** en el chat. Los prompts pueden quedar registrados. Usar datos ficticios.
- **No aceptar cambios que no se entienden.** Si no podés explicar qué hace el código en review, no está listo.
- **No dejar que reescriba archivos completos** cuando el cambio es puntual. Pedir diffs mínimos.
- **No usar la IA para saltear el proceso**: los tests, el review y la CI aplican igual.
- **No mergear PRs generados automáticamente** (agentes en background, bots) sin revisión humana completa.

## Privacidad y modo de uso

- Activar **Privacy Mode** en Cursor en repositorios con código propietario, salvo indicación contraria del área de seguridad.
- No conectar MCP servers ni extensiones no aprobadas que tengan acceso al código o a credenciales.
- Los archivos `.cursor/rules/` y `AGENTS.md` **son código**: cambian por PR, se revisan y se versionan.

## Ideas para aprovechar mejor Cursor

- Pedirle que **escriba primero el test** que reproduce un bug y luego el fix.
- Usarlo para **explicar** código heredado antes de modificarlo.
- Generar **borradores de ADR** o descripciones de PR a partir del diff, y luego editarlos.
- Pedir **revisión adversarial** del propio diff antes de abrir el PR: "¿qué podría fallar en este cambio?".
