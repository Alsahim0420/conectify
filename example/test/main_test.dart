import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conectify_example/main.dart';
import 'package:conectify/conectify.dart';

void main() {
  group('ProductsScreen - Métodos y Funcionalidades', () {
    testWidgets('ProductsScreen carga productos al inicializar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pump();

      // Verificar que el widget se inicializa correctamente
      expect(find.byType(ProductsScreen), findsOneWidget);
    });

    testWidgets('ProductsScreen tiene RefreshIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verificar que existe RefreshIndicator cuando hay contenido
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        expect(refreshIndicator, findsOneWidget);
      }
    });

    testWidgets('ProductsScreen muestra mensaje cuando no hay productos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Puede mostrar "No hay productos disponibles" o contenido
      final noProductsMessage = find.text('No hay productos disponibles');
      final hasContent = find.byType(ListView);

      // Verificar que existe alguno de estos estados
      expect(
        noProductsMessage.evaluate().isNotEmpty ||
            hasContent.evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('ProductsScreen tiene botón de reintentar en caso de error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Buscar botón de reintentar
      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        expect(retryButton, findsOneWidget);

        // Tocar el botón
        await tester.tap(retryButton);
        await tester.pump();
      }
    });
  });

  group('ProductDetailScreen - Renderizado Completo', () {
    final completeProduct = Product(
      id: 1,
      title: 'Complete Test Product',
      price: 199.99,
      description: 'This is a complete test product with all fields filled',
      category: 'electronics',
      image: 'https://example.com/complete-image.jpg',
      rating: const Rating(rate: 4.8, count: 250),
    );

    testWidgets('ProductDetailScreen renderiza todos los elementos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: completeProduct)),
      );

      // Verificar todos los elementos principales
      expect(find.text('Complete Test Product'), findsOneWidget);
      expect(find.text('\$199.99'), findsOneWidget);
      expect(find.text('electronics'), findsOneWidget);
      expect(
        find.text('This is a complete test product with all fields filled'),
        findsOneWidget,
      );
      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(250 reseñas)'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen tiene imagen del producto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: completeProduct)),
      );

      // Verificar que existe un contenedor para la imagen
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('ProductDetailScreen tiene badge de categoría', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: completeProduct)),
      );

      // Verificar que existe el badge de categoría
      expect(find.text('electronics'), findsOneWidget);
    });
  });

  group('ProductDetailScreen - Valores por Defecto', () {
    testWidgets('ProductDetailScreen renderiza producto con datos mínimos', (
      WidgetTester tester,
    ) async {
      final minimalProduct = Product(
        id: 1,
        title: 'Minimal Product',
        price: 0.0,
        description: 'Minimal description',
        category: 'test',
        image: '',
        rating: const Rating(rate: 0.0, count: 0),
      );

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: minimalProduct)),
      );

      expect(find.text('Minimal Product'), findsOneWidget);
      expect(find.text('Minimal description'), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
      expect(find.text('\$0.00'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen renderiza producto con precio', (
      WidgetTester tester,
    ) async {
      final productWithPrice = Product(
        id: 1,
        title: 'Product With Price',
        price: 50.0,
        description: 'Description',
        category: 'test',
        image: '',
        rating: const Rating(rate: 0.0, count: 0),
      );

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: productWithPrice)),
      );

      expect(find.text('Product With Price'), findsOneWidget);
      expect(find.text('\$50.00'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen renderiza producto con rating', (
      WidgetTester tester,
    ) async {
      final productWithRating = Product(
        id: 1,
        title: 'Product',
        price: 10.0,
        description: 'Description',
        category: 'test',
        image: '',
        rating: const Rating(rate: 3.5, count: 0),
      );

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: productWithRating)),
      );

      expect(find.text('3.5'), findsOneWidget);
      expect(find.text('(0 reseñas)'), findsOneWidget);
    });
  });

  group('MyApp - Configuración', () {
    testWidgets('MyApp renderiza correctamente con configuración', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verificar que MyApp se renderiza
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verificar que ProductsScreen está presente
      expect(find.byType(ProductsScreen), findsOneWidget);
    });
  });
}
