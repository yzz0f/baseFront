# 06 · Agregar un lenguaje

El núcleo del harness no sabe qué lenguajes usa el equipo. Cada lenguaje es un módulo en `lenguajes/<nombre>/` que aporta tres cosas, una por cada forma del lineamiento:

| Archivo | Forma | Obligatorio |
|---------|-------|-------------|
| `GUIA.md` | Documento para personas | Sí |
| `reglas.mdc` | Regla de Cursor, se instala en `.cursor/rules/<nombre>.mdc` | Sí |
| `check.sh` | Verificación: `detect`, `check` y opcionalmente `fix` | Sí |
| `gitignore` | Patrones que se agregan al `.gitignore` del repositorio | No |
| `config/` | Archivos de configuración de herramientas listos para copiar | No |

## Crear el módulo

```bash
./scripts/agregar-lenguaje.sh <nombre>
```

Copia `lenguajes/_plantilla/` a `lenguajes/<nombre>/`, instala `reglas.mdc` en `.cursor/rules/` y agrega la fila al registro `lenguajes/README.md`. Después hay que completar los tres archivos.

## Contrato de `check.sh`

```bash
./lenguajes/<nombre>/check.sh detect   # sale con 0 si el repositorio usa este lenguaje
./lenguajes/<nombre>/check.sh check    # formato + análisis estático + pruebas; sale con != 0 si algo falla
./lenguajes/<nombre>/check.sh fix      # aplica correcciones automáticas (opcional)
```

`scripts/check.sh` recorre todos los módulos, ejecuta `detect` y, en los que responden sí, ejecuta `check` (o `fix` y luego `check` con `--fix`). La CI hace lo mismo.

`detect` debe basarse en archivos versionados (manifiestos, extensiones) y no en herramientas instaladas. `check` debe instalar o asumir sus herramientas de forma reproducible y explicar en `GUIA.md` cómo obtenerlas.

## Contenido esperado de `GUIA.md`

1. Versión soportada del lenguaje y cómo se fija en el repositorio.
2. Herramientas: formateador, linter, tipos, pruebas, gestor de dependencias. Con versión.
3. Estructura de proyecto recomendada.
4. Convenciones de nombres.
5. Manejo de errores.
6. Cómo se escriben y organizan las pruebas.
7. Lo que está prohibido y por qué.

Debe cumplir [04 · Calidad y pruebas](04-calidad-y-pruebas.md); puede ser más estricto, nunca menos.

## Contenido esperado de `reglas.mdc`

Un resumen de `GUIA.md` en forma de instrucciones para el asistente, con `globs` que cubran las extensiones del lenguaje. Corto: lo que Cursor necesita para no cometer los errores típicos del lenguaje.

## Quién lo escribe

Las personas que trabajan con ese lenguaje. Se revisa como cualquier pull request al harness, con dos aprobaciones porque cambia cómo se escribe código.
