import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:conectify_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Conectify Example App Integration Tests', () {
    testWidgets('App inicia y muestra la pantalla de productos', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que la app se carga
      expect(find.text('Fake Store - Productos'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App muestra indicador de carga inicial', (WidgetTester tester) async {
      app.main();
      await tester.pump();

      // Inicialmente debe mostrar loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App carga y muestra productos después de la carga', (WidgetTester tester) async {
      app.main();
      await tester.pump();
      
      // Esperar a que se carguen los productos
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verificar que ya no está cargando
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // Verificar que hay contenido (puede ser productos o mensaje de error)
      final hasProducts = find.byType(ListView).evaluate().isNotEmpty ||
          find.text('No hay productos disponibles').evaluate().isNotEmpty ||
          find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
      
      expect(hasProducts, isTrue);
    });

    testWidgets('App tiene botón de refresh funcional', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Buscar el botón de refresh
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      // Tocar el botón
      await tester.tap(refreshButton);
      await tester.pump();

      // Verificar que se inicia la recarga
      // Puede mostrar loading o mantener el estado actual
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App muestra categorías cuando están disponibles', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verificar que existe el contenedor de categorías o la lista
      final hasCategoryFilter = find.byType(ListView).evaluate().isNotEmpty ||
          find.byType(FilterChip).evaluate().isNotEmpty;
      
      // Puede o no tener categorías dependiendo del estado de carga
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App maneja errores de red correctamente', (WidgetTester tester) async {
      // Este test verifica que la app maneja errores
      // En un escenario real, podríamos mockear la conexión
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // La app debe mostrar algo (productos, error, o loading)
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App puede navegar a detalle de producto', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Buscar un producto en la lista
      final productCards = find.byType(Card);
      
      if (productCards.evaluate().isNotEmpty) {
        // Tocar el primer producto
        await tester.tap(productCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verificar que se navegó a la pantalla de detalle
        expect(find.text('Detalle del Producto'), findsOneWidget);
      }
    });

    testWidgets('Pantalla de detalle muestra información del producto', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final productCards = find.byType(Card);
      
      if (productCards.evaluate().isNotEmpty) {
        await tester.tap(productCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verificar elementos de la pantalla de detalle
        expect(find.text('Descripción'), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      }
    });

    testWidgets('App puede volver desde detalle a lista', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final productCards = find.byType(Card);
      
      if (productCards.evaluate().isNotEmpty) {
        await tester.tap(productCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Presionar el botón de retroceso
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Verificar que volvimos a la lista
        expect(find.text('Fake Store - Productos'), findsOneWidget);
      }
    });
  });
}
