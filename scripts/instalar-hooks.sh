#!/usr/bin/env bash
# Activa los hooks de .githooks/ en este repositorio (sin herramientas externas).
set -euo pipefail
raiz=$(git rev-parse --show-toplevel)
chmod +x "$raiz"/.githooks/* "$raiz"/scripts/*.sh
git -C "$raiz" config core.hooksPath .githooks
echo "Hooks activados: $(ls "$raiz/.githooks" | tr '\n' ' ')"
