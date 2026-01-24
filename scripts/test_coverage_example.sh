#!/bin/bash

# Script para ejecutar tests de la aplicación de ejemplo y generar reporte de cobertura

set -e

cd example

echo "🧪 Ejecutando tests de widgets de la aplicación de ejemplo..."
flutter test --coverage

echo "📊 Generando reporte lcov para la aplicación..."
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage

echo "✅ Reporte de cobertura generado en: example/coverage/html/index.html"

# Verificar cobertura
echo ""
echo "📈 Resumen de cobertura:"
lcov --summary coverage/lcov.info

cd ..
