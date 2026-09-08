# 05 · Seguridad

Seguridad es parte del trabajo diario, no una auditoría anual. Este documento resume lo que **todo** el equipo debe cumplir; los detalles por lenguaje están en `docs/lineamientos/lenguajes/`.

## Secretos y configuración

- **Nunca** en el repositorio: contraseñas, tokens, claves API, certificados privados, connection strings con credenciales. Ni en código, ni en tests, ni en fixtures, ni en historia de Git, ni en descripciones de PR o issues.
- Configuración por **variables de entorno** o gestor de secretos (Vault, AWS Secrets Manager, GitHub Environments). Documentar cada variable en `.env.example` con valor de ejemplo falso.
- **Gitleaks** corre en pre-commit y en CI. Si detecta un falso positivo, se agrega a `.gitleaksignore` con una línea de comentario explicando por qué.
- Si un secreto llegó al repo: **rotarlo primero**, avisar al canal de seguridad, y recién después limpiar el historial. Asumir que ya fue leído.

## Entrada externa

Toda entrada que viene de fuera del proceso (HTTP, CLI, archivos, colas, respuestas de otros servicios, **salida de modelos de IA**) se considera hostil.

- Validar **en el borde**: tipo, rango, longitud, formato. Usar esquemas (Zod, Pydantic, Bean Validation, FluentValidation, `go-playground/validator`).
- Listas blancas sobre listas negras.
- Límites de tamaño en bodies y uploads; timeouts en toda operación de red.
- Rechazar por defecto: lo que no está explícitamente permitido, falla.

## Inyección

- SQL/NoSQL: siempre consultas parametrizadas u ORM. Nunca concatenar strings con entrada de usuario, ni siquiera "escapándola".
- Shell: nunca `exec("cmd " + input)`. Usar APIs con lista de argumentos (`subprocess.run([...])`, `exec.Command(name, args...)`, `ProcessBuilder`).
- Templates/HTML: usar el escapado del framework. Sin `innerHTML`, `dangerouslySetInnerHTML`, `|safe`, `@Html.Raw` con datos externos.
- Path traversal: normalizar rutas y verificar que quedan dentro del directorio permitido.
- Deserialización: nunca deserializar objetos arbitrarios de origen externo (`pickle`, `ObjectInputStream`, `BinaryFormatter`, `yaml.load` sin `SafeLoader`).

## Autenticación y autorización

- La autorización se verifica **en el servidor**, por recurso y operación, en cada request. Nunca confiar en flags que vienen del cliente.
- Tokens: expiración corta, comparación en tiempo constante, revocables.
- Contraseñas: Argon2id o bcrypt con cost adecuado. Nunca MD5/SHA-1/SHA-256 sin sal para contraseñas.
- Sesiones y cookies: `HttpOnly`, `Secure`, `SameSite=Lax` o `Strict`.

## Datos personales

- Minimizar: si no se necesita, no se guarda.
- No loguear datos personales ni secretos. Enmascarar (`****1234`) en logs, trazas y mensajes de error.
- Cifrar en reposo lo sensible; cifrar en tránsito siempre (TLS ≥ 1.2).
- Respetar los requisitos legales de la jurisdicción (retención, derecho al olvido).

## Dependencias

- Versiones **fijas** y lockfile commiteado en todos los lenguajes.
- Dependabot habilitado; los PRs de seguridad se mergean en menos de una semana (crítica/alta: 48 h).
- `dependency-review-action` bloquea en el PR dependencias con vulnerabilidades altas o licencias no permitidas (GPL-3.0, AGPL, SSPL por defecto; ajustable por repo).
- Antes de agregar una dependencia: ¿está mantenida? ¿cuántas dependencias transitivas trae? ¿la plataforma ya lo hace? Justificar en el PR.

## Manejo de errores y logs

- Al usuario: mensaje genérico. Al log: detalle completo con ID de correlación.
- Nunca stack traces, rutas internas, versiones de librerías ni SQL en respuestas HTTP.
- Logs estructurados (JSON) con nivel, timestamp, servicio, `trace_id`. Sin secretos ni datos personales.

## Infraestructura como código y contenedores

- Imágenes base con tag fijo (`node:22.11-alpine`, no `node:latest`). Hadolint en pre-commit.
- Usuario no root en el contenedor. Sin secretos en `ENV` ni en capas de build.
- GitHub Actions: `permissions:` mínimo por workflow; acciones de terceros fijadas a versión mayor (o SHA en repos críticos).

## Checklist de seguridad en review

- [ ] ¿Hay alguna entrada externa nueva? ¿Está validada?
- [ ] ¿Se construye alguna query, comando o HTML con strings?
- [ ] ¿Se agregó una dependencia? ¿Por qué?
- [ ] ¿Se loguea algo que podría ser sensible?
- [ ] ¿Hay algún endpoint nuevo? ¿Quién puede llamarlo?
- [ ] ¿Se toca autenticación, permisos, pagos o datos personales? → 2 aprobaciones.
