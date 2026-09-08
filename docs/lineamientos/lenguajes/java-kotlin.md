# Java / Kotlin

Aplica a servicios JVM (Spring Boot, Quarkus, Micronaut, Ktor) y librerías. Config base en `templates/java/`.

## Versiones y herramientas

| Aspecto | Estándar |
|---------|----------|
| Runtime | Java 21 LTS (Temurin). Kotlin 2.x apuntando a JVM 21 |
| Build | Gradle con Kotlin DSL para repos nuevos; Maven si el repo ya lo usa. Wrapper (`gradlew`/`mvnw`) commiteado |
| Formato | **Spotless**: google-java-format (Java), ktlint (Kotlin). Falla el build si no está formateado |
| Lint | Error Prone + NullAway (Java); detekt (Kotlin) |
| Tests | JUnit 5, AssertJ, Mockito (Java) / MockK (Kotlin), Testcontainers |
| Dependencias | Version catalog (`gradle/libs.versions.toml`) o BOM. Versiones fijas, sin rangos ni `+` |

Tareas esperadas: `spotlessCheck`, `check` (incluye tests). La CI ejecuta `./gradlew spotlessCheck check` o `./mvnw spotless:check verify`.

## Estructura

Paquetes por **funcionalidad**, no por capa técnica:

```
com.acme.pedidos
  ├── PedidosApplication.java
  ├── orden/
  │     ├── Orden.java            # dominio
  │     ├── OrdenRepository.java  # puerto
  │     ├── OrdenService.java     # caso de uso
  │     ├── OrdenController.java  # adaptador HTTP
  │     └── jpa/OrdenJpaRepository.java
  └── pago/
        └── ...
```

Evitar `controllers/`, `services/`, `repositories/` globales: al crecer, cada funcionalidad queda repartida en cinco carpetas.

## Tipos y datos

- Inmutabilidad por defecto: `record` (Java) / `data class` con `val` (Kotlin). Colecciones inmutables (`List.of`, `listOf`, `Collections.unmodifiableList`).
- `Optional` **sólo** como tipo de retorno. Nunca en campos, parámetros ni colecciones. En Kotlin, tipos nullables con `?` y sin `!!`.
- Anotar nulabilidad en Java (`@Nullable` de JSpecify) y dejar que NullAway lo verifique.
- Value objects para conceptos de dominio (`Monto`, `Email`) en lugar de `BigDecimal`/`String` sueltos.
- Enums para conjuntos cerrados; sealed interfaces/classes para jerarquías cerradas con datos.

## Estilo

- Un tipo público por archivo, nombre igual al archivo.
- Inyección **por constructor**. Sin `@Autowired` en campos, sin `new` de dependencias dentro de servicios.
- `final` en parámetros y locales cuando el formateador lo permite; en Kotlin `val` salvo necesidad real.
- Streams/`Sequence` para transformar colecciones; loops si la expresión supera ~5 operaciones o necesita índices. Nunca side effects en `map`/`filter`.
- Sin `static` mutable. Sin singletons manuales.
- Logging con SLF4J y placeholders: `log.info("Orden {} creada para {}", id, cliente)`. Nunca concatenación ni `System.out`.
- Kotlin: preferir funciones de extensión y `when` exhaustivo; evitar `!!`, `lateinit` fuera de tests y frameworks; corrutinas con `structured concurrency` (nada de `GlobalScope`).

## Nombres

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Clases, interfaces, records, enums | `PascalCase` | `OrdenService` |
| Métodos, variables, parámetros | `camelCase` | `calcularTotal` |
| Constantes | `UPPER_SNAKE_CASE` | `MAX_REINTENTOS` |
| Paquetes | minúscula, sin guiones | `com.acme.pedidos.orden` |
| Tests | `should_<resultado>_when_<condicion>` o backticks en Kotlin | `` `rechaza orden sin items` `` |
| Interfaces | sin prefijo `I` | `OrdenRepository`, impl `JpaOrdenRepository` |

## Errores

- Excepciones **unchecked** propias con jerarquía (`class DominioException extends RuntimeException`). Checked sólo si la API externa lo impone.
- Atrapar excepciones específicas. `catch (Exception e)` sólo en el borde (`@ControllerAdvice`, worker loop) y siempre logueando.
- Nunca `catch` vacío ni `catch (Throwable)`.
- Encadenar causa: `throw new PagoException("no se pudo cobrar", e)`.
- No usar excepciones para control de flujo (`Optional`, resultado tipado, `Result` en Kotlin).

## Tests

- JUnit 5 + AssertJ (`assertThat(x).isEqualTo(y)`); Kotlin puede usar Kotest si el repo lo adoptó.
- Unitarios sin Spring context (`@ExtendWith(MockitoExtension.class)`). `@SpringBootTest` sólo para integración, con Testcontainers para DB/colas.
- Nombres por comportamiento; `@DisplayName` si el nombre del método no alcanza.
- `@ParameterizedTest` para casos similares.
- Sin `Thread.sleep`; usar Awaitility para asincronía.
- Cobertura con JaCoCo; umbral en el build.

## Dependencias

- Versiones fijas en `libs.versions.toml` / `dependencyManagement`. Sin `+`, sin `LATEST`, sin SNAPSHOT en `main`.
- Preferir starters/BOMs del framework para alinear versiones.
- Revisar transitivas: `./gradlew dependencies` antes de agregar algo pesado.

## Prohibido

- `System.out` / `System.err` / `printStackTrace()`.
- `@Autowired` en campos; `new` de dependencias en servicios.
- `Optional` en campos o parámetros; `!!` en Kotlin sin comentario.
- `ObjectInputStream` con datos externos; `Runtime.exec` con strings concatenados.
- Suprimir warnings (`@SuppressWarnings`) sin comentario.
- Tests con `@Disabled` sin ticket.
