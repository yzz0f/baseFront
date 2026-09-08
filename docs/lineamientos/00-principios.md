# 00 · Principios

Estos principios ordenan cualquier otra regla. Cuando dos lineamientos chocan, o cuando un caso no está contemplado, se resuelve con esto.

## 1. El código se escribe para quien lo lee

Un cambio lo escribe una persona una vez y lo leen muchas, muchas veces, incluida la IA que lo va a modificar después. Preferimos lo claro a lo ingenioso, lo explícito a lo mágico, lo aburrido a lo novedoso.

## 2. Lo que se puede automatizar, se automatiza

Formato, lint, convenciones de commits, detección de secretos y tests corren en hooks locales y en CI. Ninguna persona debería gastar un review en señalar un espacio de más. Si un lineamiento no tiene verificación automática, es un objetivo pendiente del harness.

## 3. Cambios chicos, frecuentes y reversibles

Un PR resuelve una cosa. Menos de ~400 líneas de diff es la norma; más que eso exige justificación. Todo cambio en `main` debe poder revertirse con un `git revert` limpio o apagarse con un feature flag.

## 4. Consistencia dentro del repositorio antes que consistencia con el harness

Si un repositorio ya tiene una convención distinta (por ejemplo usa `poetry` en lugar de `uv`), se respeta esa convención y, si conviene migrar, se hace en un PR dedicado. Nunca se mezclan dos estilos en el mismo repo.

## 5. Los tests son parte del cambio, no una etapa posterior

No existe "después le agrego tests". Un comportamiento sin test es un comportamiento que no sabemos si funciona ni si va a seguir funcionando.

## 6. Seguridad por defecto

Los secretos no van al repositorio, las entradas externas se validan, las dependencias se fijan y se actualizan. Esto no es negociable ni por urgencia ni por "es sólo un script".

## 7. La IA es una herramienta del autor, no un autor

Lo que genera Cursor u otro asistente es responsabilidad de quien lo commitea. Se revisa línea por línea, se entiende y se prueba igual que si lo hubiera escrito uno. Ver [06-cursor-e-ia](06-cursor-e-ia.md).

## 8. Documentar decisiones, no código

El código se explica solo con buenos nombres y tests. Lo que no se explica solo es *por qué* se eligió una cosa y no otra: eso va a un ADR en `docs/adr/`.

## 9. Todo lineamiento es cuestionable por PR

Si una regla molesta más de lo que ayuda, se propone el cambio en este repositorio con argumentos. Hasta que se apruebe, se cumple.
