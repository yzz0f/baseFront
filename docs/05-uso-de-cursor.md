# 05 · Uso de Cursor

Cursor acelera el trabajo; no lo firma. Todo lo que se integra es responsabilidad de la persona que lo integra.

## Qué lee Cursor de este harness

| Archivo | Cuándo se aplica |
|---------|------------------|
| `AGENTS.md` | Siempre. Contrato general. |
| `.cursor/rules/equipo.mdc` | Siempre. Resumen de los lineamientos transversales. |
| `.cursor/rules/github.mdc` | Al preparar commits o pull requests. |
| `.cursor/rules/<lenguaje>.mdc` | Al editar archivos de ese lenguaje (lo aporta cada módulo). |

Cada repositorio puede agregar reglas propias con conocimiento del dominio: entidades, invariantes, decisiones. Es el mejor lugar para lo que hoy sólo saben dos personas.

## Cómo pedir

- **Contexto explícito**: referenciar con `@` los archivos, carpetas y documentos relevantes. Cuanto más contexto real, menos inventa.
- **Una tarea a la vez**, acotada. "Agregar validación de correo al formulario de registro" funciona; "mejorar el módulo de usuarios" no.
- **Planificar antes de ejecutar** en tareas grandes: pedir primero un plan y revisarlo.

## Cómo aceptar

Antes de aceptar un cambio, leerlo completo y preguntarse:

- ¿Existe esa función, paquete o versión?
- ¿Reutiliza lo que ya hay o duplicó lógica?
- ¿El manejo de errores es explícito?
- ¿Las pruebas verifican algo relevante?
- ¿Tocó algo fuera de lo pedido?

Después, ejecutar `./scripts/check.sh`. Si el asistente propone desactivar una regla del linter o una prueba, casi siempre la solución está mal: pedir que arregle el código.

## Qué declarar

Si una parte significativa del pull request fue generada con IA, marcar la casilla de la plantilla. No es una penalización: orienta la revisión.

## Qué no hacer

- Pegar secretos ni datos personales en el chat.
- Aceptar código que no se puede explicar en la revisión.
- Dejar que reescriba archivos completos para un cambio puntual.
- Integrar cambios generados por agentes automáticos sin revisión humana completa.
- Conectar extensiones o servidores externos no aprobados con acceso al código.

## Privacidad

Activar el modo de privacidad de Cursor en repositorios con código propietario, salvo indicación contraria del equipo.
