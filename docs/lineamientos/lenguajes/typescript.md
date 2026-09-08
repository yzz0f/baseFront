# TypeScript / JavaScript

Aplica a frontend (React, Vue, Angular), Node.js y scripts. Config base en `templates/typescript/`.

## Versiones y herramientas

| Aspecto | Estándar |
|---------|----------|
| Runtime | Node.js LTS activo, fijado en `.nvmrc` y `engines` de `package.json` |
| Lenguaje | TypeScript ≥ 5.x, `strict: true`. JavaScript puro sólo en configs |
| Gestor de paquetes | `pnpm` para repos nuevos. `npm`/`yarn` si el repo ya lo usa. Lockfile siempre commiteado; instalar con `--frozen-lockfile` / `npm ci` |
| Formato | Prettier (config en `.prettierrc`) |
| Lint | ESLint 9 flat config + `typescript-eslint` `recommended-type-checked` |
| Tests | Vitest (o Jest si el repo ya lo usa); Testing Library para UI; Playwright para E2E |
| Build | Vite para front; `tsc` o `tsup` para librerías; `esbuild` para funciones |

Scripts esperados en `package.json` (la CI los ejecuta si existen): `lint`, `format:check`, `typecheck`, `test`, `build`.

## Estructura

```
src/
  app/            # entrypoints, routing, composición
  features/<x>/   # una carpeta por funcionalidad: componentes, hooks, servicios, tests juntos
  shared/         # ui genérica, utils, tipos compartidos
  lib/            # adaptadores a librerías externas (http client, storage, analytics)
tests/            # sólo integración/e2e; los unitarios van junto al código (*.test.ts)
```

Colocar los tests al lado del código (`user-service.ts` + `user-service.test.ts`). Organizar por funcionalidad, no por tipo técnico (`components/`, `services/` globales crecen sin control).

## Tipos

- `strict: true`, más `noUncheckedIndexedAccess`, `noImplicitOverride`, `exactOptionalPropertyTypes` en repos nuevos.
- **Prohibido** `any` explícito. Usar `unknown` y estrechar con type guards o Zod. `as` sólo con comentario justificando; `!` (non-null assertion) igual.
- `type` para formas de datos y uniones; `interface` para contratos que se implementan o extienden.
- Uniones discriminadas sobre enums de strings: `type Estado = { kind: 'ok'; data: T } | { kind: 'error'; error: E }`. Los `enum` de TS se evitan (usar `as const`).
- Validar en el borde con **Zod** (o Valibot) y derivar el tipo del esquema: `type User = z.infer<typeof UserSchema>`.

## Estilo

- Módulos ESM (`"type": "module"`). Sin `require`.
- Imports ordenados: Node built-ins → externos → alias internos (`@/`) → relativos. Sin imports relativos con más de dos niveles (`../../../`): usar alias.
- Exportaciones con nombre; `export default` sólo donde el framework lo exige (páginas, configs).
- Funciones puras y pequeñas; `const` por defecto, `let` sólo si se reasigna, nunca `var`.
- Sin clases salvo que el framework lo requiera (Angular, errores personalizados).
- `async/await` siempre. Nunca promesas sin `await` (`@typescript-eslint/no-floating-promises`) ni `.then().catch()` encadenados.
- Igualdad estricta (`===`). Sin `==` salvo `== null`.
- Sin `console.*` en producción: usar el logger del proyecto. Permitido en scripts CLI.

## Nombres

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Variables, funciones | `camelCase` | `fetchUser`, `isActive` |
| Tipos, interfaces, clases, componentes | `PascalCase` | `UserProfile`, `OrderSchema` |
| Constantes globales | `UPPER_SNAKE_CASE` | `MAX_RETRIES` |
| Archivos | `kebab-case.ts` | `user-service.ts` |
| Componentes React | `PascalCase.tsx` | `UserCard.tsx` |
| Booleanos | prefijo `is`/`has`/`can`/`should` | `hasPermission` |
| Hooks | prefijo `use` | `useOrders` |

## Errores

- Lanzar siempre instancias de `Error` o subclases con nombre (`class NotFoundError extends Error`). Nunca `throw "texto"`.
- Encadenar causa: `new AppError('no se pudo guardar', { cause })`.
- Manejar errores donde se puede hacer algo útil. No `try/catch` que sólo re-lanza ni `catch` vacío.
- En frontend, error boundaries por área funcional; en Node, handler de errores centralizado que traduce a respuestas HTTP.

## React (si aplica)

- Componentes funcionales y hooks. Sin `React.FC`; tipar `props` explícitamente.
- Lógica de negocio fuera del componente: hooks propios, servicios, o store.
- Estado servidor con TanStack Query (o SWR); estado global de UI mínimo (Zustand, Context).
- Sin `useEffect` para derivar estado (calcularlo en render) ni para sincronizar props con estado.
- Listas con `key` estable (ID), nunca índice.
- Accesibilidad: elementos semánticos, `aria-*` donde corresponde, navegable por teclado. `eslint-plugin-jsx-a11y` activo.

## Tests

- Vitest con `describe`/`it`; nombres en lenguaje natural: `it('rechaza emails sin @')`.
- Testing Library: consultar por rol/texto (`getByRole('button', { name: /guardar/i })`), no por clase ni `data-testid` salvo necesidad.
- Mock de red con **MSW**, nunca mockeando `fetch` a mano.
- Cobertura con `@vitest/coverage-v8`, umbral en `vitest.config.ts`.

## Dependencias

- Antes de agregar: ¿lo hace la plataforma? (`fetch`, `URL`, `Intl`, `structuredClone`, `Array.prototype.at`). ¿Cuánto pesa? (bundlephobia). ¿Está mantenido?
- Sin `lodash` completo; importar funciones puntuales o usar nativo.
- `devDependencies` para todo lo que no va al bundle/runtime.

## Prohibido

- `any`, `@ts-ignore` (usar `@ts-expect-error` con comentario si es inevitable), `eslint-disable` sin justificación.
- `innerHTML` / `dangerouslySetInnerHTML` con datos externos.
- `eval`, `new Function`, `with`.
- Mutar parámetros de entrada o estado compartido.
- Dependencias con versión `latest` o rangos abiertos (`*`, `>=`).
