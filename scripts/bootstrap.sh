#!/usr/bin/env bash
# Prepara un repositorio para usar el harness:
#   - instala pre-commit y los hooks (pre-commit + commit-msg)
#   - copia la configuración base del/los lenguaje(s) indicados desde templates/
#   - habilita las entradas de Dependabot correspondientes
#
# Uso:  ./scripts/bootstrap.sh [--lang ts|python|go|java|csharp]... [--no-hooks] [--force]
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$(pwd)"
LANGS=()
INSTALL_HOOKS=1
FORCE=0

log()  { printf '\033[1;34m▶ %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m✔ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m! %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31m✖ %s\033[0m\n' "$*" >&2; exit 1; }

usage() { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --lang) [ $# -ge 2 ] || die "--lang requiere un valor"; LANGS+=("$2"); shift 2 ;;
    --no-hooks) INSTALL_HOOKS=0; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage 0 ;;
    *) die "Argumento desconocido: $1 (ver --help)" ;;
  esac
done

# Copia un archivo de plantilla sin pisar el existente salvo --force.
copy_template() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$FORCE" -ne 1 ]; then
    warn "ya existe $dst (usar --force para sobrescribir)"; return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  ok "copiado $dst"
}

# Descomenta en .github/dependabot.yml las líneas con prefijo "# lang:<x>:".
enable_dependabot() {
  local lang="$1" file="$TARGET_DIR/.github/dependabot.yml"
  [ -f "$file" ] || return 0
  if grep -q "^# lang:$lang:" "$file"; then
    sed -i.bak "s/^# lang:$lang://" "$file" && rm -f "$file.bak"
    ok "dependabot: habilitado ecosistema para $lang"
  fi
}

setup_lang() {
  local lang="$1" t="$HARNESS_DIR/templates"
  log "Configurando $lang"
  case "$lang" in
    ts|typescript|js)
      copy_template "$t/typescript/eslint.config.mjs" "$TARGET_DIR/eslint.config.mjs"
      copy_template "$t/typescript/.prettierrc" "$TARGET_DIR/.prettierrc"
      copy_template "$t/typescript/tsconfig.base.json" "$TARGET_DIR/tsconfig.base.json"
      warn "agregá los scripts de templates/typescript/package.scripts.json a tu package.json"
      enable_dependabot ts ;;
    py|python)
      copy_template "$t/python/pyproject.toml" "$TARGET_DIR/pyproject.toml"
      enable_dependabot python ;;
    go)
      copy_template "$t/go/.golangci.yml" "$TARGET_DIR/.golangci.yml"
      enable_dependabot go ;;
    java|kotlin|jvm)
      warn "Java/Kotlin: seguí templates/java/README.md para configurar Spotless en el build"
      enable_dependabot java ;;
    cs|csharp|dotnet)
      copy_template "$t/csharp/Directory.Build.props" "$TARGET_DIR/Directory.Build.props"
      copy_template "$t/csharp/Directory.Packages.props" "$TARGET_DIR/Directory.Packages.props"
      warn "C#: fusioná templates/csharp/.editorconfig con el .editorconfig del repo"
      enable_dependabot csharp ;;
    *) die "Lenguaje no soportado: $lang (ts|python|go|java|csharp)" ;;
  esac
}

log "Harness: $HARNESS_DIR"
log "Destino: $TARGET_DIR"

# Archivos transversales que todo repo debe tener.
for f in .editorconfig .gitattributes .pre-commit-config.yaml commitlint.config.js AGENTS.md; do
  [ -e "$TARGET_DIR/$f" ] || copy_template "$HARNESS_DIR/$f" "$TARGET_DIR/$f"
done
[ -d "$TARGET_DIR/.cursor/rules" ] || { mkdir -p "$TARGET_DIR/.cursor" && cp -r "$HARNESS_DIR/.cursor/rules" "$TARGET_DIR/.cursor/" && ok "copiadas .cursor/rules"; }
[ -d "$TARGET_DIR/.github" ] || { cp -r "$HARNESS_DIR/.github" "$TARGET_DIR/.github" && ok "copiado .github/"; }

for lang in "${LANGS[@]+"${LANGS[@]}"}"; do setup_lang "$lang"; done

if [ "$INSTALL_HOOKS" -eq 1 ]; then
  log "Instalando pre-commit"
  if ! command -v pre-commit >/dev/null 2>&1; then
    if command -v pipx >/dev/null 2>&1; then pipx install pre-commit
    elif command -v uv >/dev/null 2>&1; then uv tool install pre-commit
    elif command -v pip >/dev/null 2>&1; then pip install --user pre-commit
    elif command -v brew >/dev/null 2>&1; then brew install pre-commit
    else die "No encontré pipx/uv/pip/brew para instalar pre-commit. Ver https://pre-commit.com/#install"; fi
  fi
  ( cd "$TARGET_DIR" && pre-commit install --hook-type pre-commit --hook-type commit-msg )
  ok "hooks instalados"
fi

echo
ok "Listo. Próximos pasos:"
echo "   1. Revisá .github/CODEOWNERS y poné los responsables reales."
echo "   2. Configurá branch protection según docs/lineamientos/01-flujo-git.md."
echo "   3. Ejecutá ./scripts/check.sh para verificar que todo pasa."
