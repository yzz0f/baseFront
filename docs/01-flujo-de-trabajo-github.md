# 01 · Flujo de trabajo en GitHub

## Ramas

| Rama | Uso | Reglas |
|------|-----|--------|
| `main` | Siempre desplegable | Sin push directo. Sólo por pull request con CI verde y revisión aprobada. |
| `<tipo>/<descripcion-corta>` | Trabajo en curso | Sale de `main`, vive pocos días, se borra al integrarse. |

Tipos de rama: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `hotfix`. Si hay identificador de tarea, va después del tipo: `feat/123-exportar-reportes`. Nombres en minúsculas con guiones, sin nombres de personas.

## Ciclo de un cambio

1. Crear la rama desde `main` actualizado.
2. Hacer commits pequeños siguiendo [02 · Commits y pull requests](02-commits-y-pull-requests.md). El hook `commit-msg` valida el formato.
3. Abrir el pull request temprano, como borrador si todavía no está listo, para ver la CI y pedir opinión a tiempo.
4. Cuando está listo: completar la plantilla, quitar el estado de borrador, pedir revisión. Los dueños de código se asignan solos.
5. Responder a la revisión con commits nuevos, sin reescribir la historia de la rama.
6. Integrar con **squash**. El título del pull request se convierte en el mensaje del commit.
7. La rama se borra automáticamente.

## Mantener la rama al día

- Rama propia (nadie más la tiene descargada): `git rebase main` y `git push --force-with-lease`.
- Rama compartida: `git merge main`. Nunca forzar el push.

## Protección de `main` (configuración en GitHub)

- [ ] Requerir pull request antes de integrar, con al menos una aprobación.
- [ ] Descartar aprobaciones cuando se suben commits nuevos.
- [ ] Requerir revisión de dueños de código (`CODEOWNERS`).
- [ ] Requerir los checks `Verificación` y `Pull request` en verde.
- [ ] Requerir que la rama esté actualizada con `main`.
- [ ] Requerir historia lineal.
- [ ] Requerir resolver las conversaciones antes de integrar.
- [ ] No permitir excepciones, ni para administradores.
- [ ] Permitir sólo squash merge; mensaje por defecto: título y descripción del pull request.
- [ ] Borrar ramas automáticamente al integrar.

## Lo que no se hace

- Commits directos en `main`.
- `git push --force` en ramas que otra persona pueda tener.
- Ramas de más de una semana. Un cambio grande se parte en entregas incrementales.
- Integrar con la CI en rojo. Una prueba inestable se arregla o se registra como tarea, no se ignora.
