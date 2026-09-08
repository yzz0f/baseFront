# Python

Aplica a servicios, APIs, scripts de datos y herramientas internas. Config base en `templates/python/pyproject.toml`.

## Versiones y herramientas

| Aspecto | Estándar |
|---------|----------|
| Runtime | Python ≥ 3.11, fijado en `.python-version` y `requires-python` |
| Gestor de dependencias | `uv` para repos nuevos (`uv.lock` commiteado). `poetry` si el repo ya lo usa. Nunca `requirements.txt` a mano sin lockfile |
| Formato | `ruff format` (compatible con black) |
| Lint | `ruff check` (reemplaza flake8, isort, pyupgrade, bandit parcial) |
| Tipos | `mypy --strict` en código nuevo; `pyright` aceptable si el repo ya lo usa |
| Tests | `pytest` + `pytest-cov`; `hypothesis` para property-based |
| Empaquetado | `pyproject.toml` con `src/` layout. Sin `setup.py` nuevo |

## Estructura

```
pyproject.toml
uv.lock
src/
  <paquete>/
    __init__.py
    api/          # entrypoints (FastAPI routers, CLI con typer)
    domain/       # modelos y reglas de negocio, sin I/O
    services/     # casos de uso, orquestan dominio e infraestructura
    infra/        # DB, HTTP clients, colas
tests/
  unit/
  integration/
  conftest.py
```

## Tipos

- Type hints en **toda** función y método público, incluido el retorno (`-> None`).
- Sintaxis moderna: `list[str]`, `dict[str, int]`, `X | None` (no `Optional`, no `List`).
- `dataclass(frozen=True, slots=True)` para valores; **Pydantic v2** para datos que cruzan bordes (requests, configs, mensajes).
- `Protocol` para interfaces; `ABC` sólo si se necesita implementación compartida.
- `TypedDict` sólo para interoperar con JSON externo; no como modelo de dominio.
- Sin `# type: ignore` sin código de error y comentario: `# type: ignore[arg-type]  # la lib no tipa X`.

## Estilo

- Formato y orden de imports lo decide ruff. Sin `import *`. Imports absolutos desde el paquete.
- f-strings para formatear. Nunca `%` ni `.format()` en código nuevo.
- `pathlib.Path` en lugar de `os.path`.
- Context managers para recursos (`with open(...)`, `async with session`).
- Comprensiones para transformaciones simples; loop explícito si hay más de una condición o anidamiento.
- Sin variables globales mutables. Configuración con `pydantic-settings` desde variables de entorno.
- `logging` (o `structlog`) con logger por módulo: `log = logging.getLogger(__name__)`. Sin `print` fuera de CLIs.
- Async: `asyncio` con `httpx`/`asyncpg`/`aiokafka`. No mezclar código sync bloqueante dentro de handlers async.

## Nombres

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Funciones, variables, módulos | `snake_case` | `fetch_user`, `order_service.py` |
| Clases, excepciones | `PascalCase` | `OrderRepository`, `PaymentError` |
| Constantes | `UPPER_SNAKE_CASE` | `MAX_RETRIES` |
| Privado | prefijo `_` | `_parse_header` |
| Booleanos | `is_`/`has_`/`can_` | `is_active` |

## Errores

- Jerarquía propia: `class AppError(Exception)` → `class NotFoundError(AppError)`. Los handlers HTTP traducen la jerarquía a códigos.
- Atrapar excepciones **específicas**. `except Exception` sólo en el borde (handler global, loop de worker) y siempre logueando con `log.exception`.
- Nunca `except: pass` ni `except Exception: return None`.
- Encadenar con `raise NuevoError("contexto") from err`.
- No usar excepciones para control de flujo normal (`if key in d` mejor que `try: d[key] except KeyError`).

## Tests

- `pytest` puro: funciones `test_*`, `assert` plano. Sin `unittest.TestCase` en código nuevo.
- Fixtures en `conftest.py`; `@pytest.fixture` con scope mínimo. Factories con `factory_boy` o builders propios.
- Parametrizar casos similares con `@pytest.mark.parametrize`.
- Marcadores: `@pytest.mark.integration` para tests que necesitan Docker (Testcontainers). `pytest -m "not integration"` para correr sólo unitarios.
- Mock de HTTP con `respx` (httpx) o `responses` (requests). Sin `unittest.mock.patch` de módulos enteros.
- Cobertura mínima en `pyproject.toml` (`fail_under = 80`).

## Dependencias

- Declaradas en `pyproject.toml` (`[project.dependencies]` y `[dependency-groups] dev`). Versiones con límite superior de major: `httpx>=0.27,<1`.
- Lockfile (`uv.lock`) commiteado y actualizado por Dependabot.
- Sin dependencias para lo que hace la stdlib (`requests` → `httpx` o `urllib` según el caso; `pytz` → `zoneinfo`).

## Prohibido

- `eval`, `exec`, `pickle` con datos externos, `yaml.load` sin `Loader=SafeLoader`, `subprocess` con `shell=True` e input de usuario.
- Mutar argumentos por defecto (`def f(items=[])`).
- `from x import *`.
- `assert` para validar entrada en producción (se elimina con `-O`). Usar `if not ...: raise`.
- `time.sleep` en tests.
