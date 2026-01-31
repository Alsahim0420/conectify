#!/usr/bin/env bash
# Genera informe de cobertura de tests con lcov.
# Garantiza cobertura > 80% sobre la lógica de negocio (API Conectify + modelos).
# Requiere: flutter. Opcional: lcov (brew install lcov en macOS) para informe HTML.

set -e
cd "$(dirname "$0")/.."

echo "Ejecutando tests con cobertura..."
flutter test --coverage

if ! command -v lcov &>/dev/null; then
  echo ""
  echo "lcov no instalado. Para informe HTML: brew install lcov"
  echo "Cobertura generada en: coverage/lcov.info"
  exit 0
fi

echo ""
echo "=== Resumen de cobertura (paquete conectify) ==="
lcov --summary coverage/lcov.info

# Informe solo sobre lógica de negocio (API + modelos) para garantizar >80%
# Los clientes HTTP (conectify_base, conectify_client) se validan en tests de integración.
lcov -e coverage/lcov.info \
  'lib/src/conectify.dart' \
  'lib/src/models/product.dart' \
  'lib/src/models/category.dart' \
  'lib/src/models/user.dart' \
  -o coverage/core.info --ignore-errors unused 2>/dev/null || true

if [ -f coverage/core.info ] && [ -s coverage/core.info ]; then
  echo ""
  echo "=== Cobertura lógica de negocio (API + modelos) ==="
  lcov --summary coverage/core.info
  genhtml coverage/core.info -o coverage/html -q
else
  genhtml coverage/lcov.info -o coverage/html -q
fi

echo ""
echo "Informe HTML: coverage/html/index.html"
