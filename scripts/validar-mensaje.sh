#!/usr/bin/env bash
# Valida que la primera línea de un mensaje (por stdin o archivo) siga el formato convencional:
#   <tipo>(<ámbito>)!: <descripción>      ámbito y ! opcionales
# Uso: validar-mensaje.sh [archivo]   |   echo "feat: x" | validar-mensaje.sh
set -euo pipefail

TIPOS='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'
MAX=72

if [ $# -ge 1 ]; then primera=$(head -n1 "$1"); else primera=$(head -n1); fi

# Se aceptan sin validar los mensajes que genera git.
case "$primera" in
  Merge\ *|Revert\ *|fixup!\ *|squash!\ *) exit 0 ;;
esac

error() { printf 'Mensaje inválido: "%s"\n  %s\n  Formato: <tipo>(<ámbito>): <descripción>   tipos: %s\n' "$primera" "$1" "$TIPOS" >&2; exit 1; }

[[ "$primera" =~ ^($TIPOS)(\([a-z0-9._/-]+\))?!?:\ .+$ ]] || error "debe empezar con un tipo válido seguido de ':' y un espacio"
descripcion=${primera#*: }
[[ "$descripcion" =~ ^[[:upper:]] ]] && error "la descripción empieza en minúscula"
[[ "$descripcion" == *. ]] && error "la descripción no termina en punto"
[ "${#primera}" -le "$MAX" ] || error "la primera línea supera $MAX caracteres (${#primera})"
exit 0
