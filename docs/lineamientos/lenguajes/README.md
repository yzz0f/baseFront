# Lineamientos por lenguaje

Cada documento cubre: versión soportada, herramientas (formato, lint, tipos, tests), estructura de proyecto, convenciones de nombres, manejo de errores y lo que está prohibido. La configuración lista para copiar está en `templates/<lenguaje>/` y la regla equivalente para Cursor en `.cursor/rules/2x-<lenguaje>.mdc`.

| Lenguaje | Documento | Formato | Lint | Tests |
|----------|-----------|---------|------|-------|
| TypeScript / JavaScript | [typescript.md](typescript.md) | Prettier | ESLint + typescript-eslint | Vitest / Jest, Playwright |
| Python | [python.md](python.md) | ruff format | ruff + mypy | pytest |
| Java / Kotlin | [java-kotlin.md](java-kotlin.md) | Spotless (google-java-format / ktlint) | Error Prone / detekt | JUnit 5 + AssertJ |
| Go | [go.md](go.md) | gofmt / goimports | golangci-lint | `go test` |
| C# / .NET | [csharp.md](csharp.md) | dotnet format | Roslyn analyzers | xUnit + FluentAssertions |

Para un lenguaje no listado (Rust, PHP, Ruby, Swift…): aplicar los [principios](../00-principios.md), elegir el formateador y linter estándar de la comunidad, integrarlos en `pre-commit` y CI, y abrir un PR a este harness con el nuevo documento.
