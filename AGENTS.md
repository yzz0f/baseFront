# Instrucciones para agentes de IA

Este archivo lo leen Cursor y otros asistentes (Copilot, Claude Code, Codex). Las reglas de `.cursor/rules/` lo complementan con detalle por lenguaje. Si hay conflicto, gana lo que dice el repositorio concreto en su propio `AGENTS.md` o `CLAUDE.md`.

## Contexto del equipo

- Equipo políglota. Antes de tocar código, identificá el lenguaje y leé el lineamiento correspondiente en `docs/lineamientos/lenguajes/`.
- Usamos GitHub con `main` protegido, PRs con squash merge y Conventional Commits.
- Los hooks de `pre-commit` y la CI son la fuente de verdad para formato y lint. No los desactives ni agregues excepciones (`eslint-disable`, `# noqa`, `#nosec`, `@SuppressWarnings`) sin justificarlo en un comentario al lado.

## Cómo trabajar

1. **Entender antes de escribir.** Leé los archivos relacionados, los tests existentes y el README del módulo. No asumas la estructura del proyecto.
2. **Cambios mínimos y enfocados.** Un PR resuelve una sola cosa. No refactorices código que no está relacionado con la tarea aunque veas oportunidades; anotalas para otro PR.
3. **Seguí las convenciones existentes** del repositorio (nombres, estructura de carpetas, librerías ya usadas) antes que las tuyas o las de la documentación general. Si el repo hace algo distinto a este harness, respetá el repo.
4. **Tests siempre.** Todo comportamiento nuevo o corregido lleva test. Si no podés ejecutarlos, decilo explícitamente.
5. **No inventes APIs.** Si no estás seguro de que una función, paquete o versión existe, verificalo en el código o en la documentación oficial antes de usarlo.
6. **Nada de secretos.** Nunca escribas credenciales, tokens ni URLs internas con credenciales. Usá variables de entorno y documentá cuáles se necesitan en `.env.example`.
7. **Errores explícitos.** No silencies excepciones. Los errores se propagan con contexto o se manejan de forma visible; nunca `catch {}` vacío ni `except: pass`.
8. **Sin dependencias nuevas sin motivo.** Si agregás una dependencia, explicá por qué en la descripción del PR y verificá licencia y mantenimiento.

## Formato de commits y PRs

- Commits: `tipo(scope): descripción en minúscula, imperativo, sin punto final` (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `perf`, `build`, `revert`).
- Título del PR con el mismo formato. Cuerpo según `.github/PULL_REQUEST_TEMPLATE.md`.
- Si generaste una parte significativa del código con IA, marcá la casilla correspondiente en la plantilla del PR.

## Comandos de verificación

```bash
./scripts/check.sh            # lint + formato + tests de los lenguajes presentes
pre-commit run --all-files    # sólo hooks
```

Ejecutá esto antes de considerar terminada una tarea y reportá el resultado real, incluyendo fallos.

## Qué NO hacer

- No hacer `git push --force` a ramas compartidas ni a `main`.
- No editar archivos generados (lockfiles, `*.generated.*`, `dist/`) a mano; regenerarlos con la herramienta.
- No cambiar la configuración de CI, linters o hooks para que un check pase. Arreglá el código.
- No borrar ni marcar como `skip` tests que fallan.
