# Cómo contribuir

Estas reglas aplican a **todos** los repositorios del equipo. El detalle de cada punto está en `docs/lineamientos/`.

## Antes de empezar

1. Asegurarse de tener los hooks instalados: `pre-commit install --hook-type pre-commit --hook-type commit-msg` (o `./scripts/bootstrap.sh`).
2. Leer `AGENTS.md` si vas a trabajar con Cursor u otro asistente: ahí está el contexto que el asistente también recibe.
3. Si el cambio es grande o toca arquitectura, abrir primero un issue o un ADR borrador para discutirlo.

## Flujo de trabajo

```
main ──────────────────────────────●──────────────●────
                                   ▲              ▲
feat/ABC-123-descripcion ──●──●──●─┘              │
fix/ABC-456-descripcion ────────────────●──●──────┘
```

1. Crear rama desde `main`: `tipo/TICKET-descripcion-corta` (ver [01-flujo-git](docs/lineamientos/01-flujo-git.md)).
2. Commits pequeños con [Conventional Commits](docs/lineamientos/02-commits.md).
3. Abrir PR usando la plantilla. Un PR resuelve **una** cosa.
4. La CI debe estar verde y se necesita al menos **1 aprobación** (2 si toca `CODEOWNERS` críticos).
5. Merge con **squash** (el título del PR es el mensaje de commit final, así que debe seguir Conventional Commits).
6. Borrar la rama después del merge.

## Definición de "listo para revisar"

- [ ] La CI pasa (lint, formato, tests, análisis de seguridad).
- [ ] Hay tests para el comportamiento nuevo o corregido.
- [ ] No hay secretos, credenciales ni datos personales en el diff.
- [ ] La plantilla del PR está completa (qué, por qué, cómo probar).
- [ ] Si se usó IA para generar código, el autor lo revisó línea por línea y lo indicó en el PR.

## Cómo pedir y dar review

Ver [03-code-review](docs/lineamientos/03-code-review.md). Resumen: revisar en menos de un día hábil, comentar con prefijos (`nit:`, `question:`, `blocking:`), y el autor resuelve los hilos.

## Reportar bugs y proponer mejoras

Usar las plantillas de issue. Si encontrás una vulnerabilidad, **no** abras un issue público: seguí `SECURITY.md`.
