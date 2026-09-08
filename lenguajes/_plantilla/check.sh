#!/usr/bin/env bash
# Verificación del módulo NOMBRE. Contrato:
#   check.sh detect  -> sale con 0 si el repositorio usa este lenguaje (según archivos versionados)
#   check.sh check   -> formato + análisis estático + pruebas; sale con != 0 si algo falla
#   check.sh fix     -> aplica correcciones automáticas (opcional)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

detect() {
  # Ejemplo: [ -n "$(git ls-files -- '*.EXTENSION' 'MANIFIESTO' | head -n1)" ]
  return 1
}

check() {
  echo "TODO: formato (verificación sin modificar)"
  echo "TODO: análisis estático"
  echo "TODO: pruebas"
  return 1
}

fix() {
  echo "TODO: aplicar formato y correcciones automáticas"
  return 1
}

case "${1:-}" in
  detect) detect ;;
  check) check ;;
  fix) fix ;;
  *) echo "Uso: $0 detect|check|fix" >&2; exit 2 ;;
esac
