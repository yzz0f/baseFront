# 02 · Commits

Seguimos [Conventional Commits 1.0](https://www.conventionalcommits.org/es/v1.0.0/). Lo valida `commitlint` en el hook `commit-msg` y en CI.

## Formato

```
<tipo>(<scope>): <descripción>

<cuerpo>

<footers>
```

- **tipo** (obligatorio): `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- **scope** (opcional): módulo o área afectada, en minúscula: `auth`, `api`, `ui`, `deps`.
- **descripción** (obligatoria): imperativo, minúscula inicial, sin punto final, ≤ 72 caracteres en total la primera línea. Responde a "si se aplica este commit, va a…".
- **cuerpo** (opcional): qué cambia y **por qué**. No cómo: eso está en el diff. Líneas ≤ 100 caracteres.
- **footers** (opcional): `Refs: PAY-231`, `Closes #42`, `BREAKING CHANGE: …`, `Co-authored-by: …`.

## Ejemplos

```
feat(auth): permitir login con magic link

Los usuarios corporativos no tienen contraseña gestionada por nosotros.
El link expira a los 15 minutos y es de un solo uso.

Refs: AUTH-88
```

```
fix(api): devolver 404 en lugar de 500 cuando el pedido no existe
```

```
refactor(orders)!: renombrar OrderService.process a submit

BREAKING CHANGE: los consumidores del SDK deben actualizar la llamada.
```

```
chore(deps): actualizar eslint a 9.15
```

## Qué tipo usar

| Situación | Tipo |
|-----------|------|
| Comportamiento nuevo visible para usuarios o consumidores | `feat` |
| Corrige un comportamiento incorrecto | `fix` |
| Sólo documentación | `docs` |
| Cambio de código sin alterar comportamiento | `refactor` |
| Mejora medible de rendimiento | `perf` |
| Agrega o corrige tests únicamente | `test` |
| Sistema de build, dependencias | `build` |
| Configuración de CI / workflows | `ci` |
| Formato, espacios, puntos y coma (sin lógica) | `style` |
| Nada de lo anterior (scripts, configs de repo) | `chore` |
| Revierte un commit previo | `revert` |

## Tamaño y granularidad

- Un commit = un cambio lógico completo que compila y pasa tests. Si el mensaje necesita la palabra "y", probablemente son dos commits.
- Los commits intermedios tipo `wip`, `fix typo`, `arreglo review` están bien **durante** el desarrollo porque al mergear con squash desaparecen. Lo que importa es que el título del PR sea correcto.
- No mezclar reformateo masivo con cambios funcionales: el reformateo va en su propio commit (o PR) para que el diff funcional sea legible.

## Idioma

Los mensajes de commit se escriben en **español**, salvo en repositorios open source o compartidos con terceros angloparlantes, donde se usa inglés. El tipo y el scope siempre en inglés (son tokens).

## Coautoría y asistentes

Si el commit fue programado en pareja o con ayuda significativa de un asistente de IA, se indica en el footer:

```
Co-authored-by: Nombre <email@dominio>
```

La responsabilidad sobre el contenido siempre es de quien firma el commit.
