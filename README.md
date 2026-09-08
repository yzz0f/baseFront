# Harness de lineamientos de desarrollo

Base común para los repositorios del equipo. Define **cómo trabajamos** con GitHub y con Cursor, y deja un mecanismo para que cada lenguaje que usa el equipo enchufe sus propias reglas y verificaciones sin tocar el núcleo.

## Cómo está armado

Cada lineamiento existe en tres formas, para que no dependa de que alguien lo recuerde:

| Forma | Dónde | Quién lo consume |
|-------|-------|------------------|
| Documento | `docs/` | Personas |
| Regla para el asistente | `.cursor/rules/`, `AGENTS.md` | Cursor y otros agentes de IA |
| Verificación | `scripts/check.sh`, `.githooks/`, `.github/workflows/` | Git local y GitHub Actions |

Los lenguajes son **módulos** en `lenguajes/<nombre>/`. Cada módulo trae su guía, su regla de Cursor y su script de verificación. El núcleo no sabe qué lenguajes existen: los descubre.

```
.
├── README.md
├── AGENTS.md                 # contrato para agentes de IA
├── docs/                     # lineamientos transversales
├── .cursor/rules/            # reglas de Cursor (transversales + una por lenguaje instalado)
├── .github/                  # plantilla de PR, CODEOWNERS, workflows
├── .githooks/                # hooks de git sin dependencias externas
├── lenguajes/                # un módulo por lenguaje; _plantilla/ para crear nuevos
└── scripts/                  # check.sh, agregar-lenguaje.sh, instalar-hooks.sh
```

## Adoptar el harness en un repositorio

1. Copiar al repositorio: `AGENTS.md`, `docs/`, `.cursor/`, `.github/`, `.githooks/`, `scripts/`, `.editorconfig` y `.gitignore` (o crear el repo desde este template).
2. Ejecutar `./scripts/instalar-hooks.sh` para activar los hooks de git.
3. Por cada lenguaje del repositorio, ejecutar `./scripts/agregar-lenguaje.sh <nombre>` y completar el módulo generado (ver [docs/06-agregar-un-lenguaje.md](docs/06-agregar-un-lenguaje.md)).
4. Ajustar `.github/CODEOWNERS` y activar la protección de la rama principal (checklist en [docs/01-flujo-de-trabajo-github.md](docs/01-flujo-de-trabajo-github.md)).

## Verificar localmente

```bash
./scripts/check.sh          # ejecuta la verificación de cada lenguaje detectado
./scripts/check.sh --fix    # además aplica correcciones automáticas si el módulo las soporta
```

Es exactamente lo que ejecuta la CI en cada pull request.

## Documentos

| Documento | Contenido |
|-----------|-----------|
| [00 · Cómo usar este harness](docs/00-como-usar-este-harness.md) | Qué es, qué no es, cómo se cambia |
| [01 · Flujo de trabajo en GitHub](docs/01-flujo-de-trabajo-github.md) | Ramas, protección, ciclo de un cambio |
| [02 · Commits y pull requests](docs/02-commits-y-pull-requests.md) | Formato de mensajes, tamaño, plantilla |
| [03 · Revisión de código](docs/03-revision-de-codigo.md) | Qué revisar, cómo comentar, plazos |
| [04 · Calidad y pruebas](docs/04-calidad-y-pruebas.md) | Lo que se exige a cualquier lenguaje |
| [05 · Uso de Cursor](docs/05-uso-de-cursor.md) | Cómo aprovechar el asistente sin perder control |
| [06 · Agregar un lenguaje](docs/06-agregar-un-lenguaje.md) | El mecanismo de módulos |
| [lenguajes/](lenguajes/README.md) | Registro de módulos instalados |

## Cambiar un lineamiento

Por pull request a este repositorio, como cualquier código. Un lineamiento que no se puede verificar automáticamente sigue valiendo, pero el objetivo es que cada regla termine teniendo su verificación.
