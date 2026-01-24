import 'package:flutter_test/flutter_test.dart';
import 'package:conectify/conectify.dart';

void main() {
  group('ConectifyClient Integration Tests', () {
    late ConectifyClient client;

    setUp(() {
      // Usamos una API pública real para tests de integración
      client = ConectifyClient(baseUrl: 'https://jsonplaceholder.typicode.com');
    });

    tearDown(() {
      client.close();
    });

    test('GET - Obtener un post específico', () async {
      final result = await client.get('/posts/1');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 1);
      expect(result['title'], isA<String>());
      expect(result['body'], isA<String>());
      expect(result['userId'], isA<int>());
    });

    test('GET con query parameters - Filtrar posts por usuario', () async {
      final result = await client.get(
        '/posts',
        queryParams: {'userId': '1'},
      );
      
      // Nota: jsonplaceholder puede retornar una lista directamente
      // Este test verifica que la petición se realiza correctamente
      expect(result, isA<Map<String, dynamic>>());
    });

    test('GET List - Obtener lista de posts', () async {
      final result = await client.getList('/posts');
      
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, true);
      expect(result[0], isA<Map<String, dynamic>>());
    });

    test('POST - Crear un nuevo post', () async {
      final newPost = {
        'title': 'Test Post',
        'body': 'This is a test post body',
        'userId': 1,
      };
      
      final result = await client.post('/posts', newPost);
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], isA<int>());
      expect(result['title'], 'Test Post');
      expect(result['body'], 'This is a test post body');
      expect(result['userId'], 1);
    });

    test('PUT - Actualizar un post existente', () async {
      final updatedPost = {
        'id': 1,
        'title': 'Updated Post',
        'body': 'This is an updated post body',
        'userId': 1,
      };
      
      final result = await client.put('/posts/1', updatedPost);
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 1);
      expect(result['title'], 'Updated Post');
    });

    test('DELETE - Eliminar un post', () async {
      final result = await client.delete('/posts/1');
      
      expect(result, isA<Map<String, dynamic>>());
    });

    test('Flujo completo - Crear, leer, actualizar y eliminar', () async {
      // Crear
      final newPost = {
        'title': 'Integration Test Post',
        'body': 'Body for integration test',
        'userId': 1,
      };
      
      final created = await client.post('/posts', newPost);
      expect(created['id'], isA<int>());
      final postId = created['id'];
      
      // Leer
      final read = await client.get('/posts/$postId');
      expect(read['title'], 'Integration Test Post');
      
      // Actualizar
      final updated = {
        'id': postId,
        'title': 'Updated Integration Test Post',
        'body': 'Updated body',
        'userId': 1,
      };
      
      final updatedResult = await client.put('/posts/$postId', updated);
      expect(updatedResult['title'], 'Updated Integration Test Post');
      
      // Eliminar
      final deleted = await client.delete('/posts/$postId');
      expect(deleted, isA<Map<String, dynamic>>());
    });

    test('Manejo de errores - Endpoint inexistente', () async {
      expect(
        () => client.get('/nonexistent/endpoint'),
        throwsA(isA<Exception>()),
      );
    });

    test('Múltiples solicitudes simultáneas', () async {
      final futures = List.generate(5, (index) => client.get('/posts/${index + 1}'));
      final results = await Future.wait(futures);
      
      expect(results.length, 5);
      for (var i = 0; i < results.length; i++) {
        expect(results[i]['id'], i + 1);
      }
    });
  });

  group('ConectifyClient Integration Tests - Fake Store API', () {
    late ConectifyClient client;

    setUp(() {
      client = ConectifyClient(baseUrl: 'https://fakestoreapi.com');
    });

    tearDown(() {
      client.close();
    });

    test('GET - Obtener un producto', () async {
      final result = await client.get('/products/1');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 1);
      expect(result['title'], isA<String>());
      expect(result['price'], isA<num>());
      expect(result['category'], isA<String>());
    });

    test('GET List - Obtener todos los productos', () async {
      final result = await client.getList('/products');
      
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, true);
      expect(result[0], isA<Map<String, dynamic>>());
      expect(result[0]['id'], isA<int>());
    });

    test('GET List - Obtener productos por categoría', () async {
      final result = await client.getList('/products/category/electronics');
      
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, true);
      for (var product in result) {
        expect(product['category'], 'electronics');
      }
    });

    test('GET List - Obtener categorías', () async {
      final result = await client.getList('/products/categories');
      
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, true);
      expect(result[0], isA<String>());
    });
  });
}
