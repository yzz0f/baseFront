# C# / .NET

Aplica a APIs ASP.NET Core, workers, librerías y herramientas. Config base en `templates/csharp/`.

## Versiones y herramientas

| Aspecto | Estándar |
|---------|----------|
| Runtime | .NET LTS vigente (8.0 o superior), fijado en `global.json` |
| Formato | `dotnet format` según `.editorconfig` (falla la CI si hay diferencias) |
| Lint | Analizadores Roslyn (`AnalysisLevel: latest-recommended`), `TreatWarningsAsErrors: true` |
| Tests | xUnit + FluentAssertions + NSubstitute (Moq si el repo ya lo usa); Testcontainers para integración |
| Dependencias | NuGet con **Central Package Management** (`Directory.Packages.props`), versiones fijas |

Configuración compartida en `Directory.Build.props` en la raíz: `Nullable`, `ImplicitUsings`, `TreatWarningsAsErrors`, `AnalysisLevel`.

## Estructura

```
Acme.Pedidos.sln
global.json
Directory.Build.props
Directory.Packages.props
src/
  Acme.Pedidos.Api/           # endpoints, DTOs de transporte, composición
  Acme.Pedidos.Application/   # casos de uso, puertos
  Acme.Pedidos.Domain/        # entidades, value objects, reglas (sin dependencias)
  Acme.Pedidos.Infrastructure/# EF Core, HTTP clients, colas
tests/
  Acme.Pedidos.UnitTests/
  Acme.Pedidos.IntegrationTests/
```

Para servicios chicos, una sola carpeta por funcionalidad (vertical slice) es aceptable; lo importante es no mezclar dominio con infraestructura.

## Tipos y datos

- `Nullable` habilitado en todo; sin `!` (null-forgiving) sin comentario.
- `record` para DTOs, comandos, eventos y value objects. `init` en propiedades; sin setters públicos en entidades.
- `IReadOnlyList<T>` / `IReadOnlyDictionary<K,V>` en APIs públicas; `List<T>` sólo internamente.
- Enums para conjuntos cerrados; sin números mágicos.
- Fechas con `DateTimeOffset` (o `DateOnly`/`TimeOnly`) y `TimeProvider` inyectado; nunca `DateTime.Now`.

## Estilo

- Un tipo público por archivo; namespace file-scoped (`namespace Acme.Pedidos.Domain;`).
- Inyección por constructor con `Microsoft.Extensions.DependencyInjection`. Sin service locator (`IServiceProvider.GetService` fuera de la composición) ni `new` de servicios.
- `async`/`await` **hasta el final**. Nunca `.Result`, `.Wait()`, `Task.Run` para "hacer async" código sync. `ConfigureAwait(false)` sólo en librerías.
- `CancellationToken` como último parámetro de toda operación de I/O, propagado desde el request.
- LINQ para transformar; `foreach` si la consulta supera ~4 operadores o tiene side effects. Materializar (`ToList()`) una vez si se enumera varias veces.
- `var` cuando el tipo es evidente del lado derecho; tipo explícito si no.
- Expression-bodied members para una línea; llaves siempre en `if`/`for` de más de una línea.
- Logging con `ILogger<T>` y **plantillas estructuradas**: `_logger.LogInformation("Orden {OrderId} creada", id)`. Nunca interpolación (`$"..."`) en logs. Preferir `LoggerMessage` source generators en rutas calientes.
- Configuración tipada con `IOptions<T>` validada al arranque (`ValidateDataAnnotations().ValidateOnStart()`).

## Nombres

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Tipos, métodos, propiedades, constantes, enums | `PascalCase` | `OrderService`, `MaxRetries` |
| Interfaces | `I` + `PascalCase` | `IOrderRepository` |
| Parámetros, locales | `camelCase` | `orderId` |
| Campos privados | `_camelCase` | `_repository` |
| Métodos async | sufijo `Async` | `GetOrderAsync` |
| Tests | `Metodo_Escenario_ResultadoEsperado` | `Submit_WhenCartEmpty_ThrowsValidationException` |
| Namespaces | `Empresa.Producto.Modulo` | `Acme.Pedidos.Domain` |

## Errores

- Excepciones propias específicas (`class OrderNotFoundException : DomainException`). Traducidas a respuestas HTTP en un `IExceptionHandler` / middleware global con `ProblemDetails`.
- Atrapar sólo lo que se puede manejar. `catch (Exception)` únicamente en el middleware global o loops de worker, siempre logueando.
- Nunca `catch {}` vacío. Nunca `throw ex;` (pierde el stack trace): usar `throw;`.
- Sin excepciones para control de flujo: `TryParse`, `Result<T>` o `OneOf` para casos esperados.
- Validación de entrada en el borde con FluentValidation o Data Annotations; el dominio asume datos válidos y lanza si se violan invariantes.

## Tests

- xUnit: `[Fact]` y `[Theory]` con `[InlineData]`/`[MemberData]`. Sin `[Fact(Skip = ...)]` sin ticket.
- FluentAssertions: `result.Should().BeEquivalentTo(expected)`.
- Dobles con NSubstitute sólo para fronteras. Fakes en memoria para repositorios en unitarios.
- Integración con `WebApplicationFactory<Program>` + Testcontainers (SQL Server/Postgres). Categoría `[Trait("Category", "Integration")]`.
- Cobertura con coverlet (`--collect:"XPlat Code Coverage"`); umbral en el pipeline.

## Dependencias

- `Directory.Packages.props` con `ManagePackageVersionsCentrally=true`. Ningún `.csproj` declara versiones.
- Preferir paquetes `Microsoft.Extensions.*` y `System.*` antes que terceros equivalentes.
- `dotnet list package --vulnerable --include-transitive` limpio antes de release.

## Prohibido

- `.Result`, `.Wait()`, `async void` (salvo event handlers de UI).
- `DateTime.Now`/`UtcNow` directo; usar `TimeProvider`.
- `BinaryFormatter`, `Process.Start` con strings concatenados con input.
- `#pragma warning disable` sin comentario y sin `restore`.
- `dynamic` fuera de interoperabilidad justificada.
- `public` en campos; `static` mutable.
