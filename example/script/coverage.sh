#!/usr/bin/env bash
# Genera informe de cobertura de tests de la app de ejemplo.
# Requiere: flutter. Opcional: lcov (brew install lcov) para informe HTML.

set -e
cd "$(dirname "$0")/.."

echo "Ejecutando tests de la app de ejemplo con cobertura..."
flutter test --coverage

if ! command -v lcov &>/dev/null; then
  echo ""
  echo "lcov no instalado. Para informe HTML: brew install lcov"
  echo "Cobertura generada en: coverage/lcov.info"
  exit 0
fi

echo ""
echo "=== Resumen de cobertura (example) ==="
lcov --summary coverage/lcov.info

genhtml coverage/lcov.info -o coverage/html -q 2>/dev/null || true
echo ""
echo "Informe HTML: coverage/html/index.html"
