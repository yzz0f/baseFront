# 07 · Documentación

Documentamos **decisiones y contexto**, no código. El código se explica con nombres, tipos y tests.

## Qué documento va dónde

| Necesidad | Dónde | Formato |
|-----------|-------|---------|
| Qué es este repo, cómo correrlo, cómo contribuir | `README.md` | Markdown, secciones estándar (abajo) |
| Por qué se tomó una decisión de arquitectura | `docs/adr/NNNN-titulo.md` | ADR (plantilla en `docs/adr/0000-plantilla.md`) |
| Cómo se opera en producción (runbooks, alertas) | `docs/runbooks/` | Markdown con pasos numerados |
| Contrato de API | OpenAPI / protobuf / GraphQL schema en el repo | Generado o validado en CI |
| Variables de entorno | `.env.example` | Una por línea con comentario |
| Contexto para IA | `AGENTS.md`, `.cursor/rules/` | Ver [06](06-cursor-e-ia.md) |
| Cambios entre versiones | `CHANGELOG.md` | Generado desde Conventional Commits |

## README mínimo de un repositorio

1. **Qué es** (dos líneas) y a qué sistema pertenece.
2. **Requisitos** (versiones de runtime, herramientas).
3. **Cómo correrlo localmente** (comandos copiables, en orden).
4. **Cómo correr los tests**.
5. **Estructura** de carpetas si no es obvia.
6. **Configuración**: link a `.env.example`.
7. **Despliegue** o link al runbook.
8. **Links**: tablero, canal, docs de arquitectura.

Si un paso del README no funciona copiándolo tal cual, es un bug.

## ADR (Architecture Decision Records)

Se escribe un ADR cuando una decisión:

- es difícil o costosa de revertir (framework, base de datos, forma de autenticación, división en servicios),
- afecta a más de un equipo o repositorio,
- alguien va a preguntar "¿por qué hicieron esto?" en seis meses.

Reglas:

- Numeración secuencial, título en imperativo: `0007-usar-postgres-para-eventos.md`.
- Un ADR no se edita una vez aceptado. Si cambia la decisión, se escribe uno nuevo que lo *reemplaza* y se actualiza el estado del viejo a `Reemplazado por 0012`.
- Estados: `Propuesto` → `Aceptado` | `Rechazado` → `Obsoleto` | `Reemplazado`.
- Se revisa por PR como cualquier código.

## Comentarios en el código

- Explican **por qué**, nunca **qué**. `// incrementa i` no aporta; `// el proveedor devuelve fechas en UTC-3 sin indicarlo` sí.
- Docstrings/JSDoc/Javadoc en toda API pública de una librería. En código de aplicación, sólo donde el nombre y la firma no alcanzan.
- `TODO` y `FIXME` siempre con ticket: `// TODO(PAY-231): quitar cuando migre el proveedor`. Los sin ticket se rechazan en review.
- Nunca código comentado. Para eso está Git.

## Diagramas

- Como código: Mermaid dentro del Markdown (GitHub lo renderiza) o PlantUML/D2 con el `.puml`/`.d2` commiteado junto a la imagen.
- Máximo un nivel de detalle por diagrama. Si necesita leyenda de más de cinco elementos, son dos diagramas.

## Idioma

Documentación interna en **español**. Identificadores de código, tipos y nombres de commit (type/scope) en **inglés**. Repos públicos: todo en inglés.
