import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conectify/conectify.dart';
import 'package:conectify_example/main.dart';

/// Tests unitarios de la aplicación de ejemplo.
/// Verifican la configuración de la app y la integración con conectify.
void main() {
  group('MyApp - Configuración', () {
    test('MyApp tiene título correcto', () {
      const app = MyApp();
      expect(app, isNotNull);
    });
  });

  group('ProductsScreen - Datos', () {
    test('ProductsScreen es StatefulWidget', () {
      const screen = ProductsScreen();
      expect(screen, isA<StatefulWidget>());
      expect(screen.createState, isNotNull);
    });
  });

  group('ProductDetailScreen - Datos', () {
    final sampleProduct = Product(
      id: 1,
      title: 'Unit Test Product',
      price: 49.99,
      description: 'Description',
      category: 'test',
      image: 'https://example.com/img.jpg',
      rating: const Rating(rate: 4.0, count: 10),
    );

    test('ProductDetailScreen recibe Product correctamente', () {
      final screen = ProductDetailScreen(product: sampleProduct);
      expect(screen.product, sampleProduct);
      expect(screen.product.id, 1);
      expect(screen.product.title, 'Unit Test Product');
    });
  });

  tearDownAll(() {
    Conectify.close();
  });
}
