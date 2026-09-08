# Política de seguridad

## Reportar una vulnerabilidad

No abras un issue público. Usá **Security → Report a vulnerability** en el repositorio afectado (GitHub Private Vulnerability Reporting) o escribí al canal privado de seguridad del equipo.

Incluí: repositorio y versión afectada, pasos para reproducir, impacto estimado y, si la tenés, una propuesta de corrección.

Compromiso de respuesta:

| Etapa | Plazo objetivo |
|-------|----------------|
| Acuse de recibo | 2 días hábiles |
| Evaluación inicial y severidad | 5 días hábiles |
| Corrección (crítica / alta) | 14 días |
| Corrección (media / baja) | Siguiente ciclo de release |

## Controles automáticos en todos los repos

- **Gitleaks** en pre-commit y en CI: bloquea secretos antes de que lleguen al historial.
- **Dependabot**: alertas y PRs de actualización de dependencias.
- **CodeQL**: análisis estático en cada PR para los lenguajes soportados.
- **Branch protection** en `main`: sin push directo, CI obligatoria, revisión obligatoria.

## Si un secreto llegó al repositorio

1. **Rotarlo inmediatamente.** Reescribir el historial no alcanza: asumí que ya fue leído.
2. Avisar al canal de seguridad.
3. Recién después, limpiar el historial si corresponde (`git filter-repo`) y forzar push coordinado con el equipo.

Más detalle en [docs/lineamientos/05-seguridad.md](docs/lineamientos/05-seguridad.md).
