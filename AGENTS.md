# Instrucciones para agentes de IA

Este archivo lo leen Cursor y cualquier otro asistente de código. Es el contrato mínimo; las reglas de `.cursor/rules/` lo detallan.

## Contexto

- Equipo con varios lenguajes. Cada uno tiene un módulo en `lenguajes/<nombre>/` con su guía (`GUIA.md`), su regla de Cursor y su verificación (`check.sh`). Antes de escribir código, identifica el lenguaje y lee su guía si existe.
- Trabajamos en GitHub: rama principal protegida, cambios por pull request, mensajes de commit en formato convencional (`tipo(ámbito): descripción`).
- La verificación oficial es `./scripts/check.sh`. Lo que ese script rechaza, no se entrega.

## Cómo trabajar

1. **Lee antes de escribir.** Revisa el módulo afectado, sus pruebas y las convenciones del repositorio. No asumas la estructura.
2. **Cambios mínimos.** Un pull request resuelve una sola cosa. No refactorices lo que no está relacionado; anótalo para otro cambio.
3. **Respeta las convenciones del repositorio** por encima de las tuyas. Si el repositorio hace algo distinto a este harness, el repositorio manda.
4. **Pruebas siempre.** Todo comportamiento nuevo o corregido lleva prueba. Si no puedes ejecutarlas, dilo.
5. **No inventes.** Si no estás seguro de que una función, paquete o versión existe, verifícalo antes de usarlo.
6. **Sin secretos.** Nunca escribas credenciales ni tokens. Usa variables de entorno y documéntalas en `.env.example`.
7. **Errores visibles.** No silencies excepciones ni errores. Se propagan con contexto o se manejan de forma explícita.
8. **Sin dependencias nuevas sin motivo.** Si agregas una, explica por qué en el pull request.

## Antes de dar por terminada una tarea

Ejecuta `./scripts/check.sh` y reporta el resultado real, incluidos los fallos. No modifiques la configuración de verificación, ni desactives reglas o pruebas, para que un check pase.

## Qué no hacer

- `git push --force` a ramas compartidas o a la principal.
- Editar a mano archivos generados o de bloqueo de dependencias.
- Borrar, ignorar o marcar como omitidas pruebas que fallan.
