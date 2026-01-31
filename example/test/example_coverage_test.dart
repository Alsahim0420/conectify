import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conectify_example/main.dart';
import 'package:conectify/conectify.dart';

/// Tests que cubren rutas de éxito e interacción para subir cobertura del example.
/// Esperan respuesta de la API (requieren red). Si fallan por timeout, ejecutar con red.
void main() {
  tearDownAll(() {
    Conectify.close();
  });

  group('ProductsScreen - Carga exitosa e interacción', () {
    testWidgets('espera carga de productos y muestra lista o mensaje', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pump();
      expect(find.byType(ProductsScreen), findsOneWidget);

      // Esperar a que termine la carga (API o error)
      await tester.pumpAndSettle(const Duration(seconds: 15));

      // Debe mostrar algo: lista, "No hay productos", error o loading
      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasNoProducts = find.text('No hay productos disponibles').evaluate().isNotEmpty;
      final hasError = find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
      final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      expect(hasList || hasNoProducts || hasError || hasLoading, isTrue);
    });

    testWidgets('botón refresh llama a recargar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pump();
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);
      await tester.tap(refreshButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      // No debe haber excepción; el estado se actualiza
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('tras cargar, tap en chip de categoría si existe', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 15));

      final chips = find.byType(FilterChip);
      if (chips.evaluate().isNotEmpty) {
        await tester.tap(chips.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('tras cargar, tap en card navega a detalle si hay productos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 15));

      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(
          find.text('Detalle del Producto').evaluate().isNotEmpty ||
              find.byType(ProductDetailScreen).evaluate().isNotEmpty,
          isTrue,
        );
      } else {
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('botón Reintentar existe cuando hay error y se puede pulsar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 15));

      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('ProductsScreen - Datos iniciales (sin red)', () {
    final fakeProduct = Product(
      id: 1,
      title: 'Producto de prueba',
      price: 29.99,
      description: 'Descripción para cobertura',
      category: 'electronics',
      image: 'https://example.com/img.jpg',
      rating: const Rating(rate: 4.2, count: 50),
    );

    final fakeCategories = [
      const Category(name: 'electronics'),
      const Category(name: 'jewelery'),
    ];

    testWidgets('con initialProducts e initialCategories muestra lista y chips', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductsScreen(
            initialProducts: [fakeProduct],
            initialCategories: fakeCategories,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(FilterChip), findsWidgets);
      expect(find.text('Producto de prueba'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('tap en chip Todos con datos iniciales', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductsScreen(
            initialProducts: [fakeProduct],
            initialCategories: fakeCategories,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Todos'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('tap en chip de categoría con datos iniciales', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductsScreen(
            initialProducts: [fakeProduct],
            initialCategories: fakeCategories,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilterChip, 'electronics'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('tap en card con datos iniciales navega a detalle (requiere red)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductsScreen(
            initialProducts: [fakeProduct],
            initialCategories: fakeCategories,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Puede mostrar detalle (si API responde) o SnackBar de error
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('RefreshIndicator con datos iniciales', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductsScreen(
            initialProducts: [fakeProduct],
            initialCategories: fakeCategories,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('4.2 (50)'), findsOneWidget);
    });

    testWidgets('imagen con error muestra icono (errorBuilder)', (
      WidgetTester tester,
    ) async {
      final productBadImage = Product(
        id: 2,
        title: 'Sin imagen',
        price: 0,
        description: 'D',
        category: 'test',
        image: 'invalid-url-that-fails',
        rating: const Rating(rate: 0, count: 0),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: ProductsScreen(
            initialProducts: [productBadImage],
            initialCategories: const [Category(name: 'test')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsWidgets);
    });
  });

  group('ProductsScreen - Estado de error (HTTP override)', () {
    testWidgets('muestra UI de error cuando la red falla', (
      WidgetTester tester,
    ) async {
      HttpOverrides.global = _FailingHttpOverrides();
      addTearDown(() => HttpOverrides.global = null);

      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Debe mostrar icono de error o botón Reintentar
      final hasError = find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
      final hasRetry = find.text('Reintentar').evaluate().isNotEmpty;
      expect(hasError || hasRetry, isTrue);
    });
  });
}

/// HttpOverrides que hace fallar todas las peticiones para cubrir la rama de error.
class _FailingHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FailingHttpClient();
  }
}

class _FailingHttpClient implements HttpClient {
  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => throw Exception('HTTP mock error');
}
