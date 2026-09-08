# 02 · Commits y pull requests

## Mensaje de commit

Formato convencional, validado por el hook `commit-msg` y por la CI en el título del pull request:

```
<tipo>(<ámbito opcional>): <descripción>

<cuerpo opcional: qué cambia y por qué>

<pie opcional: referencias, BREAKING CHANGE, coautoría>
```

- **tipo**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- **descripción**: en imperativo, minúscula inicial, sin punto final, primera línea de hasta 72 caracteres.
- **cuerpo**: explica el porqué. El cómo ya está en el diff.
- Un cambio incompatible se marca con `!` después del tipo o con `BREAKING CHANGE:` en el pie.

Ejemplos:

```
feat(reportes): permitir exportar a CSV
fix(auth): devolver 401 cuando el token expiró
refactor(pedidos)!: renombrar procesar a enviar
```

Los mensajes se escriben en español; el tipo y el ámbito son tokens y van en inglés.

## Granularidad

- Un commit es un cambio lógico completo. Si el mensaje necesita la palabra "y", probablemente son dos.
- Los commits intermedios durante el desarrollo pueden ser informales, porque el squash los elimina. Lo que importa es el título del pull request.
- El reformateo masivo va separado de los cambios funcionales.

## Pull request

- **Uno por intención.** Si resuelve dos cosas, son dos pull requests.
- **Tamaño**: orientativo, menos de 400 líneas cambiadas. Más que eso exige explicar por qué no se pudo dividir. La CI avisa a partir de 400 y bloquea a partir de 1500.
- **Título** con el formato de commit convencional; es el mensaje final.
- **Descripción** según `.github/PULL_REQUEST_TEMPLATE.md`: qué cambia, por qué, cómo probarlo, riesgos.
- **Listo para revisar** significa: CI verde, pruebas incluidas, sin secretos en el diff, plantilla completa, y declarado si una parte significativa fue generada con IA.

## Coautoría

Si el cambio se hizo en pareja o con ayuda significativa de un asistente, se indica en el pie del commit con `Co-authored-by:`. La responsabilidad sigue siendo de quien firma.
