# 03 · Code review

El review es la principal herramienta de calidad y de transferencia de conocimiento del equipo. Se hace con respeto, rapidez y foco en lo que la máquina no puede verificar.

## Objetivos del review (en orden)

1. **Corrección**: ¿hace lo que dice el PR? ¿Rompe algo?
2. **Diseño**: ¿es la solución adecuada al problema? ¿Encaja con la arquitectura existente?
3. **Legibilidad y mantenibilidad**: ¿alguien lo va a entender en seis meses?
4. **Tests**: ¿cubren el comportamiento y los bordes? ¿Son legibles?
5. **Seguridad y datos**: entradas, secretos, permisos, datos personales.
6. **Estilo**: sólo lo que el linter no atrapa. Si el linter debería atraparlo, se propone la regla en el harness.

## Para el autor

- **PR chico y enfocado.** Menos de ~400 líneas. Si es más grande, dividirlo o explicar por qué no en la descripción.
- **Descripción completa** según la plantilla: qué, por qué, cómo probar, riesgos.
- **Auto-review primero.** Leer el diff completo en GitHub antes de pedir review. Sorprende cuánto se encuentra.
- **CI verde antes de pedir review.** No se pide revisión de algo que no compila.
- **Responder todos los comentarios**, aunque sea con "hecho" o con un argumento. El autor resuelve los hilos después de responder; el reviewer puede reabrirlos.
- Los cambios pedidos van en **commits nuevos**, no en `amend`, para que el reviewer vea sólo lo que cambió.

## Para quien revisa

- **Tiempo de respuesta**: primer review dentro de **un día hábil** (idealmente el mismo día). Un PR bloqueado bloquea a una persona.
- **Revisar el cambio, no a la persona.** "Este método podría fallar si `x` es null" y no "no pensaste en null".
- **Preguntar antes de asumir.** Muchas veces hay un motivo que no está en el diff.
- **Aprobar con comentarios menores** en lugar de bloquear por nits. Bloquear sólo por corrección, diseño o seguridad.
- **Ejecutar el código** cuando el cambio es no trivial o la plantilla lo permite fácilmente.
- No pedir cambios que están fuera del alcance del PR. Anotarlos como `nit:` o abrir un issue.

## Prefijos de comentario

| Prefijo | Significado | ¿Bloquea? |
|---------|-------------|-----------|
| `blocking:` | Hay que resolverlo antes de mergear | Sí |
| `question:` | No entiendo algo; puede derivar en cambio o no | Depende de la respuesta |
| `suggestion:` | Propongo una alternativa; el autor decide | No |
| `nit:` | Detalle menor de estilo o nombre | No |
| `praise:` | Algo que está bien hecho y vale destacar | No |
| `todo:` | Trabajo futuro; requiere ticket | No |

Un review sin prefijos se interpreta como `suggestion:`.

## Decisiones de aprobación

- **Approve**: listo para mergear tal cual o con nits que confío que el autor aplica.
- **Comment**: tengo observaciones pero no bloqueo; otro reviewer decide.
- **Request changes**: hay al menos un `blocking:`. Explicar qué falta para aprobar.

Requisitos: 1 aprobación de CODEOWNER. 2 aprobaciones para cambios en infraestructura, autenticación, pagos, esquema de base de datos o este harness.

## Reviews de código generado con IA

Si el PR indica uso significativo de IA, el reviewer presta especial atención a:

- APIs o funciones que no existen o están deprecadas.
- Manejo de errores genérico (`catch (e) {}`, `except Exception`).
- Tests que sólo ejecutan código sin afirmar nada relevante.
- Duplicación de lógica que ya existe en el repositorio.
- Dependencias nuevas innecesarias.

## Resolución de desacuerdos

1. Discutir en el hilo con argumentos técnicos.
2. Si no hay acuerdo en dos rondas, llamada de 15 minutos.
3. Si persiste, decide el tech lead del área y, si la decisión es de arquitectura, queda registrada en un ADR.
