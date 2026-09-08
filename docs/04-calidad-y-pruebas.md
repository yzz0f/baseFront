# 04 · Calidad y pruebas

Estas exigencias aplican a cualquier lenguaje. Cada módulo en `lenguajes/` dice con qué herramientas se cumplen.

## Lo que todo módulo de lenguaje debe proveer

Su `check.sh` debe ejecutar, en este orden y fallando si algo no pasa:

1. **Formato**: un formateador automático, sin discusión de estilo en las revisiones.
2. **Análisis estático**: linter y, donde el lenguaje lo permita, verificación de tipos.
3. **Pruebas**: el conjunto de pruebas del repositorio.

Y opcionalmente `--fix` para aplicar formato y correcciones automáticas.

## Qué cambio exige qué prueba

| Cambio | Prueba requerida |
|--------|------------------|
| Comportamiento nuevo | Unitaria; de integración si cruza una frontera (base de datos, red, colas) |
| Corrección de error | Una prueba que falle antes y pase después |
| Refactor | Las pruebas existentes pasan sin modificarse |
| Cambio en interfaz pública | Prueba de contrato |
| Sólo documentación o configuración de CI | Ninguna |

## Cómo escribir pruebas

- Estructura preparación / acción / verificación, separada visualmente.
- Nombre por comportamiento: `rechaza_pago_sin_saldo`, no `test_pagar`.
- Deterministas: sin esperas de tiempo real, sin dependencia del orden, sin aleatoriedad sin semilla.
- Dobles de prueba sólo en fronteras externas. No se simula lo que se está probando.
- Una idea por prueba.
- Una prueba que se omite lleva comentario con motivo, tarea y fecha límite.

## Reglas generales de código

- Errores explícitos: nunca se atrapan y descartan en silencio.
- Entradas externas validadas en el borde del sistema.
- Sin secretos en el código ni en el historial. Configuración por variables de entorno documentadas en `.env.example`.
- Sin código muerto ni comentado. Sin `TODO` sin tarea asociada.
- Dependencias con versión fijada y archivo de bloqueo en el repositorio.
- Las supresiones de reglas del linter llevan justificación al lado.

## Cobertura

Es un piso, no un objetivo. Cada módulo define su umbral; el harness recomienda no bajar del 80 % en el código nuevo. Una prueba que sólo ejecuta código sin verificar nada no cuenta como cobertura real y se rechaza en revisión.
