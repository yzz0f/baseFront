# 01 · Flujo de Git

Usamos **trunk-based development con ramas cortas**: una sola rama principal (`main`), ramas de trabajo que viven horas o pocos días, y merge por PR con squash.

## Ramas

| Rama | Propósito | Protección |
|------|-----------|------------|
| `main` | Siempre desplegable. Fuente de releases. | Sin push directo. PR + CI verde + 1 aprobación mínimo. Historia lineal. |
| `feat/TICKET-descripcion` | Nueva funcionalidad | — |
| `fix/TICKET-descripcion` | Corrección de bug | — |
| `chore/…`, `docs/…`, `refactor/…`, `test/…` | Mantenimiento | — |
| `hotfix/TICKET-descripcion` | Corrección urgente en producción. Sale de `main` (o del tag desplegado). | Igual que `main`, con revisión acelerada |
| `release/x.y` | Sólo si el producto necesita mantener versiones anteriores en paralelo | Igual que `main` |

Reglas de nombre:

- Minúsculas, `kebab-case`, sin acentos ni caracteres especiales.
- El ticket va después del tipo: `feat/PAY-231-retry-webhooks`. Si no hay ticket, describir bien: `fix/timeout-en-login`.
- Prefijos personales (`juan/…`) **no** se usan: la rama describe el trabajo, no a la persona.

## Ciclo de vida de un cambio

1. `git switch -c feat/PAY-231-retry-webhooks main` (siempre desde `main` actualizado).
2. Commits pequeños siguiendo [02-commits](02-commits.md). Los hooks locales validan formato y mensaje.
3. Push y apertura de PR **temprano**, como *draft* si todavía no está listo. Eso permite ver la CI y pedir opinión antes de invertir de más.
4. Cuando está listo: sacar del draft, completar la plantilla, pedir review (CODEOWNERS se asignan solos).
5. Iterar sobre comentarios con commits nuevos (no `amend`, no `force-push`, para que el reviewer vea el diff incremental).
6. Merge con **Squash and merge**. El título del PR se convierte en el mensaje del commit; por eso debe seguir Conventional Commits.
7. La rama se borra automáticamente tras el merge.

## Mantener la rama al día

Preferimos `rebase` sobre `main` mientras la rama es **personal** (sólo la trabaja una persona, nadie más la tiene checkout):

```bash
git fetch origin
git rebase origin/main
git push --force-with-lease
```

Si la rama la comparten dos o más personas, se usa `merge` de `main` hacia la rama y **nunca** `force-push`.

## Configuración de protección de `main` (checklist para admins)

- [ ] Require a pull request before merging → 1 aprobación (2 para repos críticos).
- [ ] Dismiss stale approvals when new commits are pushed.
- [ ] Require review from Code Owners.
- [ ] Require status checks: `CI OK`, `Mensajes de commit`, `Título en Conventional Commits`, `Secretos (gitleaks)`.
- [ ] Require branches to be up to date before merging.
- [ ] Require linear history.
- [ ] Require conversation resolution before merging.
- [ ] Do not allow bypassing the above settings (incluidos admins).
- [ ] Allow squash merging únicamente; default commit message = *Pull request title and description*.
- [ ] Automatically delete head branches.

## Tags y releases

- Semántico: `vMAJOR.MINOR.PATCH`. `feat` sube minor, `fix` sube patch, `BREAKING CHANGE` sube major.
- Los tags los genera la automatización de release (release-please, semantic-release o equivalente del repo) a partir de los commits. No se crean a mano.
- Cada release lleva changelog generado a partir de los Conventional Commits.

## Qué no hacer

- Commitear directo en `main`. El hook `no-commit-to-branch` lo bloquea localmente y la protección lo bloquea en remoto.
- `git push --force` a cualquier rama que no sea exclusivamente tuya. Si hay que hacerlo, siempre `--force-with-lease`.
- Ramas de larga vida (> 1 semana). Si el trabajo es grande, se divide en PRs incrementales detrás de un feature flag.
- Mergear con la CI en rojo "porque es flaky". Un test flaky se arregla o se reporta con ticket; no se ignora.
