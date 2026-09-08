#!/usr/bin/env bash
# Verificación oficial del repositorio. Recorre lenguajes/*/check.sh, ejecuta `detect`
# y, en los módulos que responden, `check` (con --fix, antes `fix`).
# Uso: ./scripts/check.sh [--fix] [--solo <lenguaje>]
set -uo pipefail

raiz=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fix=0; solo=""
while [ $# -gt 0 ]; do
  case "$1" in
    --fix) fix=1; shift ;;
    --solo) solo=${2:?--solo requiere un nombre}; shift 2 ;;
    -h|--help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "argumento desconocido: $1" >&2; exit 2 ;;
  esac
done

echo "harness $(cat "$raiz/scripts/VERSION")"
fallidos=(); ejecutados=0

for modulo in "$raiz"/lenguajes/*/; do
  nombre=$(basename "$modulo")
  [ "$nombre" = "_plantilla" ] && continue
  [ -n "$solo" ] && [ "$nombre" != "$solo" ] && continue
  script="$modulo/check.sh"
  [ -f "$script" ] || { echo "! $nombre: falta check.sh"; fallidos+=("$nombre (sin check.sh)"); continue; }
  if ! bash "$script" detect >/dev/null 2>&1; then echo "– $nombre: no detectado"; continue; fi
  ejecutados=$((ejecutados + 1))
  printf '\n▶ %s\n' "$nombre"
  if [ "$fix" -eq 1 ]; then bash "$script" fix || echo "! $nombre: fix no disponible o falló"; fi
  if bash "$script" check; then echo "✔ $nombre"; else echo "✖ $nombre"; fallidos+=("$nombre"); fi
done

echo
if [ "$ejecutados" -eq 0 ] && [ ${#fallidos[@]} -eq 0 ]; then
  echo "Ningún módulo de lenguaje detectado. Ver docs/06-agregar-un-lenguaje.md"
fi
if [ ${#fallidos[@]} -gt 0 ]; then
  printf '✖ Fallaron: %s\n' "${fallidos[*]}"; exit 1
fi
echo "✔ Verificación en verde"
