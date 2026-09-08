#!/usr/bin/env bash
# Crea el módulo lenguajes/<nombre>/ a partir de la plantilla, instala su regla de Cursor
# y lo registra en lenguajes/README.md.
# Uso: ./scripts/agregar-lenguaje.sh <nombre>    (minúsculas, sin espacios; ej: python, typescript)
set -euo pipefail

nombre=${1:?Uso: agregar-lenguaje.sh <nombre>}
[[ "$nombre" =~ ^[a-z0-9-]+$ ]] || { echo "El nombre debe ser minúsculas, dígitos o guiones" >&2; exit 2; }
raiz=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
destino="$raiz/lenguajes/$nombre"
[ -e "$destino" ] && { echo "Ya existe $destino" >&2; exit 1; }

cp -r "$raiz/lenguajes/_plantilla" "$destino"
sed -i.bak "s/NOMBRE/$nombre/g" "$destino"/GUIA.md "$destino"/reglas.mdc "$destino"/check.sh && rm -f "$destino"/*.bak
chmod +x "$destino/check.sh"
cp "$destino/reglas.mdc" "$raiz/.cursor/rules/$nombre.mdc"

registro="$raiz/lenguajes/README.md"
grep -q "^| \`$nombre\` " "$registro" || printf '| `%s` | [GUIA.md](%s/GUIA.md) | pendiente de completar |\n' "$nombre" "$nombre" >> "$registro"

cat <<MSG
Módulo creado en lenguajes/$nombre/
Completar:
  1. lenguajes/$nombre/GUIA.md        (guía para personas)
  2. lenguajes/$nombre/reglas.mdc     (regla de Cursor; ya copiada a .cursor/rules/$nombre.mdc; volver a copiar al editarla)
  3. lenguajes/$nombre/check.sh       (detect / check / fix)
  4. lenguajes/$nombre/gitignore      (opcional) y anexar su contenido al .gitignore del repositorio
Ver docs/06-agregar-un-lenguaje.md
MSG
