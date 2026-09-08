# Harness de lineamientos de desarrollo

Repositorio base (template) que concentra **cómo trabajamos**: convenciones, reglas para Cursor, automatizaciones de GitHub y plantillas de configuración por lenguaje. Está pensado para equipos políglotas que usan **Cursor** como IDE y **GitHub** como plataforma de colaboración.

La idea es que un lineamiento nunca viva sólo en un documento: cada regla tiene tres capas.

| Capa | Dónde vive | Quién la aplica |
|------|------------|-----------------|
| Documento legible | `docs/lineamientos/` | Personas (onboarding, dudas, revisiones) |
| Regla para el asistente | `.cursor/rules/` y `AGENTS.md` | Cursor / agentes de IA al generar código |
| Verificación automática | `.pre-commit-config.yaml`, `.github/workflows/` | Hooks locales y CI en cada PR |

## Contenido

```
.
├── AGENTS.md                  # Contexto para agentes de IA (Cursor, Copilot, Claude, etc.)
├── CONTRIBUTING.md            # Cómo contribuir en cualquier repo del equipo
├── SECURITY.md                # Política de reporte de vulnerabilidades
├── .cursor/rules/             # Reglas de Cursor (generales y por lenguaje)
├── .github/
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   ├── dependabot.yml
│   └── workflows/             # CI reutilizable, commitlint, calidad de PR, seguridad
├── .pre-commit-config.yaml    # Hooks locales multi-lenguaje
├── commitlint.config.js       # Conventional Commits
├── docs/
│   ├── lineamientos/          # Los lineamientos en sí
│   └── adr/                   # Registros de decisiones de arquitectura
├── templates/                 # Configs listas para copiar por lenguaje
└── scripts/                   # bootstrap.sh y check.sh
```

## Cómo usarlo

### Opción A: crear un repositorio nuevo desde este template

1. En GitHub: **Use this template → Create a new repository**.
2. Clonar y ejecutar `./scripts/bootstrap.sh --lang <ts|python|go|java|csharp>` (se puede repetir para varios lenguajes). Copia la config del lenguaje, instala `pre-commit` y deja los hooks activos.
3. Ajustar `.github/CODEOWNERS` con los responsables reales.
4. Borrar las plantillas de `templates/` que no apliquen.

### Opción B: adoptar el harness en un repositorio existente

```bash
# desde la raíz del repo destino
git clone --depth 1 https://github.com/yzz0f/baseFront /tmp/harness
cp -r /tmp/harness/.cursor /tmp/harness/.github /tmp/harness/.editorconfig \
      /tmp/harness/.pre-commit-config.yaml /tmp/harness/commitlint.config.js \
      /tmp/harness/AGENTS.md /tmp/harness/scripts .
./scripts/bootstrap.sh --lang <lenguaje>
```

### Opción C: sólo reutilizar la CI

Cualquier repositorio puede invocar el workflow de CI sin copiar nada:

```yaml
# .github/workflows/ci.yml en el repo destino
name: CI
on: [pull_request, push]
jobs:
  harness:
    uses: yzz0f/baseFront/.github/workflows/ci.yml@main
```

El workflow detecta los lenguajes presentes (por `package.json`, `pyproject.toml`, `go.mod`, `pom.xml`/`build.gradle*`, `*.sln`/`*.csproj`) y ejecuta lint + tests sólo para los que existen.

## Verificación local

```bash
./scripts/check.sh          # detecta lenguajes y corre lint/format/test como lo haría la CI
pre-commit run --all-files  # sólo los hooks
```

## Índice de lineamientos

| # | Documento | Resumen |
|---|-----------|---------|
| 00 | [Principios](docs/lineamientos/00-principios.md) | Valores que ordenan cualquier otra regla |
| 01 | [Flujo de Git](docs/lineamientos/01-flujo-git.md) | Ramas, nombres, protección de `main` |
| 02 | [Commits](docs/lineamientos/02-commits.md) | Conventional Commits, tamaño, historia |
| 03 | [Code review](docs/lineamientos/03-code-review.md) | Qué revisar, cómo comentar, tiempos |
| 04 | [Testing](docs/lineamientos/04-testing.md) | Pirámide, cobertura, qué es obligatorio |
| 05 | [Seguridad](docs/lineamientos/05-seguridad.md) | Secretos, dependencias, datos sensibles |
| 06 | [Cursor e IA](docs/lineamientos/06-cursor-e-ia.md) | Cómo usamos asistentes sin perder calidad |
| 07 | [Documentación](docs/lineamientos/07-documentacion.md) | README, ADR, comentarios |
| — | [Por lenguaje](docs/lineamientos/lenguajes/) | TypeScript, Python, Java/Kotlin, Go, C# |

## Gobernanza del harness

- Cualquier cambio a un lineamiento se hace por PR a este repositorio y requiere aprobación de un `@yzz0f/platform` (ver `CODEOWNERS`).
- Los cambios que afectan cómo se escribe código (no sólo redacción) se registran como ADR en `docs/adr/`.
- Se versiona con tags semánticos (`v1.2.0`). Los repos que usan la CI reutilizable pueden fijar `@v1` en lugar de `@main` para estabilidad.
