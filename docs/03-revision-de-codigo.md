# 03 · Revisión de código

La revisión es donde se transfiere conocimiento y se sostiene la calidad. Se hace con rapidez, respeto y foco en lo que la automatización no cubre.

## Qué se revisa, en orden

1. **Corrección**: hace lo que dice y no rompe lo que había.
2. **Diseño**: es la solución adecuada y encaja con lo existente.
3. **Legibilidad**: alguien lo va a entender en seis meses.
4. **Pruebas**: cubren el comportamiento y los bordes; son legibles.
5. **Seguridad y datos**: entradas externas, secretos, permisos, datos personales.
6. **Estilo**: sólo lo que la verificación automática no detecta. Si debería detectarlo, se propone la regla al módulo del lenguaje.

## Para quien pide la revisión

- Revisar el propio diff completo antes de pedir revisión.
- CI en verde antes de pedirla.
- Responder cada comentario, aunque sea con "hecho". Quien escribió el comentario decide si el hilo queda resuelto.
- Cambios pedidos en commits nuevos, para que se vea sólo lo que cambió.

## Para quien revisa

- Primera respuesta en **un día hábil**. Un pull request bloqueado bloquea a una persona.
- Comentar sobre el cambio, no sobre la persona. Preguntar antes de asumir.
- Aprobar con comentarios menores en lugar de bloquear por detalles. Bloquear sólo por corrección, diseño o seguridad.
- Ejecutar el cambio cuando no es trivial.
- No pedir cosas fuera del alcance del pull request; anotarlas como tarea.

## Prefijos de comentario

| Prefijo | Significado | Bloquea |
|---------|-------------|---------|
| `blocking:` | Debe resolverse antes de integrar | Sí |
| `question:` | Necesito entender algo | Según la respuesta |
| `suggestion:` | Alternativa; decide quien escribió el código | No |
| `nit:` | Detalle menor | No |
| `praise:` | Algo bien hecho | No |

Un comentario sin prefijo se interpreta como `suggestion:`.

## Aprobación

- Una aprobación de un dueño de código.
- Dos aprobaciones cuando el cambio toca autenticación, permisos, pagos, esquemas de datos, infraestructura o este harness.

## Código generado con IA

Si el pull request lo declara, prestar atención especial a: funciones o paquetes inexistentes, manejo de errores genérico, pruebas que no afirman nada, lógica duplicada que ya existía y dependencias innecesarias.

## Desacuerdos

Dos rondas de argumentos en el hilo. Si no hay acuerdo, una conversación de quince minutos. Si persiste, decide la persona responsable del área y la decisión queda escrita.
