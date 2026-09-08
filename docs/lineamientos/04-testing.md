# 04 · Testing

## Qué es obligatorio

| Tipo de cambio | Test requerido |
|----------------|----------------|
| Comportamiento nuevo | Unitario del comportamiento + integración si cruza un borde (DB, HTTP, cola) |
| Corrección de bug | Test que reproduce el bug (falla antes del fix, pasa después) |
| Refactor | Los tests existentes deben seguir pasando sin modificarse (si hay que tocarlos, no era refactor) |
| Cambio en API pública | Test de contrato (esquema de request/response) |
| Migración de datos | Test de la migración hacia arriba y hacia abajo con datos de ejemplo |
| Sólo docs / config de CI | Ninguno |

## Pirámide

```
        ╱ E2E ╲          pocos: flujos críticos de negocio, contra entorno real o staging
       ╱────────╲
      ╱ Integra- ╲       algunos: cada borde del sistema (repositorios, clientes HTTP, colas)
     ╱   ción     ╲
    ╱──────────────╲
   ╱   Unitarios    ╲    muchos: lógica de dominio, sin red, disco ni reloj real. < 100 ms cada uno
  ╱──────────────────╲
```

Los unitarios corren en cada commit (hook opcional) y en cada PR. Integración en cada PR. E2E en `main` y antes de release.

## Cobertura

- Umbral por defecto: **80 % de líneas en el código nuevo del PR** (se mide con diff coverage cuando el repo lo soporta; si no, cobertura total no debe bajar).
- Es un piso, no un objetivo. Un test que sólo ejecuta código sin afirmar nada relevante cuenta para la métrica pero no para la calidad; en review se rechaza.
- Se excluyen del cálculo: código generado, archivos de configuración, `main`/bootstrap.

## Cómo escribir buenos tests

**Estructura AAA**, separada con líneas en blanco:

```python
def test_rechaza_pago_si_saldo_insuficiente():
    cuenta = CuentaBuilder().con_saldo(50).build()          # Arrange

    resultado = cuenta.pagar(Monto(100))                    # Act

    assert resultado == Rechazado(motivo="saldo_insuficiente")  # Assert
```

**Nombres por comportamiento**, no por método: describen la regla de negocio que protegen.

**Determinismo**:
- Sin `sleep`. Usar relojes inyectables (`Clock`, `time.monotonic` mockeado, `jest.useFakeTimers`).
- Sin dependencia del orden de ejecución ni de estado compartido entre tests.
- Datos aleatorios sólo con semilla fija, o con property-based testing (Hypothesis, fast-check, jqwik) que reporte la semilla al fallar.

**Dobles de prueba**:
- Preferir *fakes* (implementación simple en memoria) a *mocks* con expectativas detalladas. Los mocks acoplan el test a la implementación.
- Mockear sólo fronteras externas: HTTP, base de datos, colas, reloj, filesystem.
- Nunca mockear lo que se está probando ni tipos de dominio propios.

**Datos de prueba**: builders o factories con defaults válidos. El test sólo especifica lo que importa para el caso.

**Aserciones**: usar la librería de aserciones del lenguaje (AssertJ, FluentAssertions, `expect`, `pytest` plain asserts). Un concepto por test; varias aserciones sólo si prueban el mismo resultado lógico.

## Tests de integración

- Usar **Testcontainers** (o equivalente) para levantar dependencias reales en Docker. Nada de "mockear la base de datos".
- Cada test deja el estado como lo encontró (transacción con rollback o base limpia por test).
- Están en un directorio o con un marcador que permite ejecutar sólo unitarios localmente (`tests/integration/`, `@pytest.mark.integration`, build tag `integration` en Go, categoría `Integration` en .NET).

## Tests end-to-end

- Cubren únicamente los **flujos críticos** de negocio (login, compra, checkout, etc.). No son para probar cada pantalla.
- Playwright para web. Selectores por rol o `data-testid`, nunca por CSS frágil.
- Corren contra `main` desplegado en staging; un fallo bloquea el release, no el PR.

## Tests que fallan

- **Nunca** se marca `skip` / `xfail` / `@Disabled` / `.skip` sin comentario con ticket y fecha límite.
- Un test flaky se investiga como un bug: casi siempre revela una race condition, dependencia de orden o reloj real.
- La CI no se reintenta "a ver si pasa". Si se necesitan reintentos para estar verde, hay un problema que arreglar.
