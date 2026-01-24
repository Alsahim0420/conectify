#!/bin/bash

# Script para ejecutar tests y generar reporte de cobertura con lcov

set -e

echo "🧪 Ejecutando tests del paquete conectify..."
flutter test --coverage

echo "📊 Generando reporte lcov para el paquete..."
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage

echo "✅ Reporte de cobertura generado en: coverage/html/index.html"

# Verificar cobertura
echo ""
echo "📈 Resumen de cobertura:"
lcov --summary coverage/lcov.info
