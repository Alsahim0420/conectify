#!/bin/bash

# Script para ejecutar todos los tests y generar reporte de cobertura completo

set -e

echo "🚀 Iniciando tests y generación de cobertura completa..."
echo ""

# Tests del paquete
echo "📦 Ejecutando tests del paquete conectify..."
flutter test --coverage
PACKAGE_COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines.*:" | awk '{print $2}' | sed 's/%//')

echo "✅ Cobertura del paquete: ${PACKAGE_COVERAGE}%"
echo ""

# Tests de la aplicación de ejemplo
echo "📱 Ejecutando tests de widgets de la aplicación de ejemplo..."
cd example
flutter test --coverage
EXAMPLE_COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines.*:" | awk '{print $2}' | sed 's/%//')
cd ..

echo "✅ Cobertura de la aplicación: ${EXAMPLE_COVERAGE}%"
echo ""

# Generar reportes HTML
echo "📊 Generando reportes HTML..."

# Reporte del paquete
if [ -f coverage/lcov.info ]; then
  genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage
  echo "✅ Reporte del paquete: coverage/html/index.html"
fi

# Reporte de la aplicación
if [ -f example/coverage/lcov.info ]; then
  genhtml example/coverage/lcov.info -o example/coverage/html --no-function-coverage --no-branch-coverage
  echo "✅ Reporte de la aplicación: example/coverage/html/index.html"
fi

echo ""
echo "🎉 Proceso completado!"
echo ""
echo "📈 Resumen de cobertura:"
echo "   Paquete conectify: ${PACKAGE_COVERAGE}%"
echo "   Aplicación ejemplo: ${EXAMPLE_COVERAGE}%"
echo ""

# Verificar que la cobertura sea mayor al 80%
if (( $(echo "$PACKAGE_COVERAGE >= 80" | bc -l) )); then
  echo "✅ Cobertura del paquete es >= 80%"
else
  echo "⚠️  Cobertura del paquete es < 80% (${PACKAGE_COVERAGE}%)"
fi

if (( $(echo "$EXAMPLE_COVERAGE >= 80" | bc -l) )); then
  echo "✅ Cobertura de la aplicación es >= 80%"
else
  echo "⚠️  Cobertura de la aplicación es < 80% (${EXAMPLE_COVERAGE}%)"
fi
