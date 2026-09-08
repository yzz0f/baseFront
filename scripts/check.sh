#!/usr/bin/env bash
# Ejecuta localmente lo mismo que la CI: detecta lenguajes presentes y corre
# formato, lint y tests de cada uno. Termina con código != 0 si algo falla.
#
# Uso: ./scripts/check.sh [--no-tests] [--fix]
set -uo pipefail

RUN_TESTS=1
FIX=0
for arg in "$@"; do
  case "$arg" in
    --no-tests) RUN_TESTS=0 ;;
    --fix) FIX=1 ;;
    -h|--help) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "argumento desconocido: $arg" >&2; exit 2 ;;
  esac
done

FAILED=()
log()  { printf '\n\033[1;34m▶ %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m✔ %s\033[0m\n' "$*"; }
skip() { printf '\033[2m– %s\033[0m\n' "$*"; }
fail() { printf '\033[1;31m✖ %s\033[0m\n' "$*"; FAILED+=("$*"); }

# run <nombre> <cmd...>: ejecuta y registra el resultado.
run() { local name="$1"; shift; if "$@"; then ok "$name"; else fail "$name"; fi; }
have() { command -v "$1" >/dev/null 2>&1; }
exists() { [ -n "$(git ls-files -- "$@" 2>/dev/null | head -n1)" ]; }
pkg_script() { node -e "process.exit(require('./package.json').scripts?.['$1'] ? 0 : 1)" 2>/dev/null; }

# ---------- Hooks genéricos ----------
log "pre-commit (hooks genéricos)"
if have pre-commit; then
  SKIP=prettier,eslint,ruff,ruff-format,mypy,golangci-lint,hadolint-docker,commitlint,no-commit-to-branch \
    run "pre-commit" pre-commit run --all-files
else
  skip "pre-commit no instalado (./scripts/bootstrap.sh lo instala)"
fi

# ---------- JavaScript / TypeScript ----------
if exists 'package.json' '*/package.json' && [ -f package.json ]; then
  log "JavaScript / TypeScript"
  if [ -f pnpm-lock.yaml ]; then PM=pnpm; elif [ -f yarn.lock ]; then PM=yarn; else PM=npm; fi
  if [ ! -d node_modules ]; then
    case $PM in pnpm) pnpm install --frozen-lockfile ;; yarn) yarn install --immutable ;; *) npm ci ;; esac
  fi
  if [ "$FIX" -eq 1 ]; then pkg_script lint:fix && $PM run lint:fix; pkg_script format && $PM run format; fi
  scripts_a_correr=(lint format:check typecheck)
  [ "$RUN_TESTS" -eq 1 ] && scripts_a_correr+=(test)
  for s in "${scripts_a_correr[@]}"; do
    if pkg_script "$s"; then run "$PM run $s" $PM run "$s"; else skip "script $s no definido"; fi
  done
fi

# ---------- Python ----------
if exists 'pyproject.toml' 'requirements*.txt'; then
  log "Python"
  if have ruff; then
    if [ "$FIX" -eq 1 ]; then ruff check --fix . && ruff format .; fi
    run "ruff check" ruff check .
    run "ruff format --check" ruff format --check .
  else skip "ruff no instalado (uv tool install ruff)"; fi
  if have mypy; then run "mypy" mypy .; else skip "mypy no instalado"; fi
  if [ "$RUN_TESTS" -eq 1 ]; then
    if have pytest && { [ -d tests ] || ls test_*.py >/dev/null 2>&1; }; then run "pytest" pytest -q; else skip "pytest o tests/ no disponibles"; fi
  fi
fi

# ---------- Go ----------
if exists 'go.mod'; then
  log "Go"
  if have gofmt; then
    [ "$FIX" -eq 1 ] && gofmt -w .
    unformatted=$(gofmt -l . 2>/dev/null)
    if [ -z "$unformatted" ]; then ok "gofmt"; else printf '%s\n' "$unformatted"; fail "gofmt"; fi
  fi
  if have golangci-lint; then run "golangci-lint" golangci-lint run ./...; else skip "golangci-lint no instalado"; fi
  have go && run "go vet" go vet ./...
  if have go; then
    run "go mod tidy (sin diff)" bash -c 'go mod tidy && git diff --exit-code -- go.mod go.sum'
    [ "$RUN_TESTS" -eq 1 ] && run "go test" go test -race -cover ./...
  fi
fi

# ---------- Java / Kotlin ----------
if exists 'pom.xml' 'build.gradle' 'build.gradle.kts' '*/build.gradle*'; then
  log "Java / Kotlin"
  if [ -x ./gradlew ]; then
    [ "$FIX" -eq 1 ] && ./gradlew --no-daemon -q spotlessApply
    run "gradlew spotlessCheck" ./gradlew --no-daemon -q spotlessCheck
    [ "$RUN_TESTS" -eq 1 ] && run "gradlew check" ./gradlew --no-daemon -q check
  elif [ -x ./mvnw ] || have mvn; then
    MVN=./mvnw; [ -x ./mvnw ] || MVN=mvn
    [ "$FIX" -eq 1 ] && $MVN -q -ntp spotless:apply
    run "mvn spotless:check" $MVN -q -ntp spotless:check
    [ "$RUN_TESTS" -eq 1 ] && run "mvn verify" $MVN -q -ntp verify
  else skip "sin gradlew/mvnw/mvn"; fi
fi

# ---------- C# / .NET ----------
if exists '*.sln' '*.csproj'; then
  log "C# / .NET"
  if have dotnet; then
    [ "$FIX" -eq 1 ] && dotnet format
    run "dotnet format --verify-no-changes" dotnet format --verify-no-changes
    run "dotnet build" dotnet build -warnaserror --nologo -v q
    [ "$RUN_TESTS" -eq 1 ] && run "dotnet test" dotnet test --no-build --nologo -v q
  else skip "dotnet no instalado"; fi
fi

# ---------- Resumen ----------
echo
if [ ${#FAILED[@]} -eq 0 ]; then
  ok "Todo en verde"
else
  printf '\033[1;31m✖ %d verificación(es) fallaron:\033[0m\n' "${#FAILED[@]}"
  printf '   - %s\n' "${FAILED[@]}"
  exit 1
fi
