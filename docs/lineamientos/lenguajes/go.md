# Go

Aplica a servicios, CLIs y herramientas de infraestructura. Config base en `templates/go/.golangci.yml`.

## Versiones y herramientas

| Aspecto | Estándar |
|---------|----------|
| Runtime | Última versión estable de Go (o la anterior), fijada en `go.mod` |
| Formato | `gofmt` + `goimports` (obligatorio; falla la CI) |
| Lint | `golangci-lint` con la config del harness |
| Tests | `go test -race -cover ./...`; `testify` sólo si el repo ya lo usa; `testcontainers-go` para integración |
| Dependencias | Go modules, `go.sum` commiteado, `go mod tidy` limpio |

## Estructura

```
cmd/
  <binario>/main.go     # sólo wiring: leer config, construir dependencias, arrancar
internal/
  <dominio>/            # paquetes por funcionalidad; no importables desde fuera del módulo
  platform/             # http, db, config, logging: adaptadores a infraestructura
pkg/                    # SÓLO si otro módulo realmente lo importa; si no, va en internal/
go.mod
go.sum
```

Sin `utils/`, `common/`, `helpers/`: nombrar por lo que hace el paquete.

## Estilo

- Seguir [Effective Go](https://go.dev/doc/effective_go) y el [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments). Ante duda, la stdlib es la referencia.
- **Aceptar interfaces, devolver structs.** Las interfaces las define el paquete que las consume, no el que las implementa. Interfaces chicas (1–3 métodos).
- `context.Context` como **primer parámetro** de toda función que hace I/O o puede tardar. Nunca guardarlo en un struct.
- Constructores `NewX(deps...) *X` que reciben dependencias explícitas. Sin variables globales mutables ni `init()` con side effects.
- Nombres cortos en scopes cortos (`i`, `err`, `ctx`), descriptivos en scopes largos. Siglas en mayúscula: `userID`, `HTTPClient`, `parseURL`.
- Paquetes en minúscula, una palabra, sin guiones bajos ni plural. Evitar stutter: `orden.Servicio`, no `orden.OrdenServicio`.
- Concurrencia: toda goroutine tiene un dueño que sabe cuándo termina (`errgroup`, `sync.WaitGroup`, cancelación por `ctx`). Sin goroutines "fire and forget". Preferir canales para comunicar, mutex para proteger estado.
- Logging estructurado con `log/slog`. Sin `fmt.Println` ni `log.Printf` en código de producción.
- Configuración desde entorno con `envconfig`/`koanf`/`viper` (el que use el repo); validada al arranque.

## Errores

- **Siempre** se revisan. `_ = err` sólo con comentario que explique por qué se ignora deliberadamente.
- Envolver con contexto y `%w`: `fmt.Errorf("cargar config %q: %w", path, err)`. Mensajes en minúscula, sin punto, sin "error:" ni "failed to".
- Comparar con `errors.Is` / `errors.As`, nunca con `==` ni con el string.
- Errores sentinel exportados (`var ErrNotFound = errors.New("...")`) o tipos propios para lo que el llamador necesita distinguir.
- `panic` sólo para errores de programación irrecuperables en inicialización. Nunca para input inválido.
- No loguear **y** devolver el mismo error: una cosa o la otra (por regla general, loguear en el borde).

## Tests

- Tests de tabla:
  ```go
  tests := []struct {
      name    string
      input   string
      want    int
      wantErr error
  }{ /* ... */ }
  for _, tt := range tests {
      t.Run(tt.name, func(t *testing.T) { /* ... */ })
  }
  ```
- `t.Parallel()` donde sea seguro. `t.Helper()` en helpers. `t.Cleanup` en lugar de `defer` para limpieza.
- Sin `time.Sleep`; inyectar reloj o usar canales/`context` con timeout.
- Integración con build tag (`//go:build integration`) o variable de entorno; `go test -tags integration ./...` en la CI.
- Golden files en `testdata/` con flag `-update`.
- `go test -race` siempre en CI.

## Dependencias

- Mínimas. La stdlib cubre HTTP, JSON, testing, logging. Antes de importar, preguntarse si vale la transitiva.
- `go mod tidy` sin diff es requisito de la CI.
- Versiones fijadas por `go.sum`; Dependabot actualiza.

## Prohibido

- Ignorar errores (`_ = f()`) sin comentario.
- `panic`/`log.Fatal` fuera de `main`.
- `init()` con side effects (conexiones, registros globales).
- `reflect` y `unsafe` sin justificación escrita en el PR.
- `interface{}`/`any` en APIs públicas cuando un tipo o genérico alcanza.
- `//nolint` sin especificar el linter y el motivo: `//nolint:gosec // G404: no criptográfico, es un jitter`.
