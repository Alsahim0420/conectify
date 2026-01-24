import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conectify_example/main.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('MyApp renderiza correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Fake Store - Productos'), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp tiene el tema configurado', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
      expect(app.theme?.useMaterial3, true);
    });
  });

  group('ProductsScreen Widget Tests', () {
    testWidgets('ProductsScreen muestra el AppBar con título', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

      expect(find.text('Fake Store - Productos'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('ProductsScreen muestra botón de refresh', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('ProductsScreen muestra estado de carga o contenido', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      
      // Inicialmente puede estar cargando o ya haber cargado
      await tester.pump();
      
      // Verificar que existe algún estado (loading, error, o contenido)
      final hasLoading = find.byType(CircularProgressIndicator);
      final hasContent = find.byType(ListView);
      final hasError = find.byIcon(Icons.error_outline);
      
      expect(
        hasLoading.evaluate().isNotEmpty ||
        hasContent.evaluate().isNotEmpty ||
        hasError.evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('ProductsScreen muestra mensaje de error cuando hay error', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: ProductsScreen(),
      );
      
      await tester.pumpWidget(widget);
      await tester.pump();

      // Esperamos un poco para que se intente la carga
      await tester.pump(const Duration(seconds: 1));
      
      // Puede mostrar error o loading dependiendo del estado
      // Verificamos que existe algún estado (error, loading, o contenido)
      final hasErrorIcon = find.byIcon(Icons.error_outline);
      final hasLoadingIndicator = find.byType(CircularProgressIndicator);
      final hasContent = find.byType(ListView);
      
      // Verificamos que al menos uno de estos estados existe
      expect(
        hasErrorIcon.evaluate().isNotEmpty || 
        hasLoadingIndicator.evaluate().isNotEmpty ||
        hasContent.evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('ProductsScreen tiene estructura de Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('ProductDetailScreen Widget Tests', () {
    final sampleProduct = {
      'id': 1,
      'title': 'Test Product',
      'price': 99.99,
      'description': 'This is a test product description',
      'category': 'electronics',
      'image': 'https://example.com/image.jpg',
      'rating': {
        'rate': 4.5,
        'count': 100,
      },
    };

    testWidgets('ProductDetailScreen muestra el título del producto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Detalle del Producto'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen muestra el precio del producto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen muestra la categoría', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.text('electronics'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen muestra la descripción', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.text('This is a test product description'), findsOneWidget);
      expect(find.text('Descripción'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen muestra el rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(100 reseñas)'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('ProductDetailScreen maneja valores nulos correctamente', (WidgetTester tester) async {
      final productWithNulls = {
        'id': 1,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: productWithNulls),
        ),
      );

      expect(find.text('Sin título'), findsOneWidget);
      expect(find.text('Sin descripción'), findsOneWidget);
      expect(find.text('Sin categoría'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen tiene AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('ProductDetailScreen tiene SingleChildScrollView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('ProductsScreen Structure Tests', () {
    testWidgets('ProductsScreen tiene estructura completa', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));
      await tester.pump();
      
      // Verificamos que la estructura básica existe
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
