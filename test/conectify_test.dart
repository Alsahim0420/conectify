import 'package:flutter_test/flutter_test.dart';

import 'package:conectify/conectify.dart';

void main() {
  group('ConectifyClient - Configuración', () {
    test('crea una instancia correctamente con baseUrl', () {
      const baseUrl = 'https://api.ejemplo.com';
      final client = ConectifyClient(baseUrl: baseUrl);

      expect(client.baseUrl, baseUrl);
    });

    test('puede cerrar el cliente', () {
      final client = ConectifyClient(baseUrl: 'https://api.ejemplo.com');

      expect(() => client.close(), returnsNormally);
    });

    test('baseUrl se establece correctamente', () {
      const testUrl = 'https://pokeapi.co/api/v2';
      final client = ConectifyClient(baseUrl: testUrl);

      expect(client.baseUrl, testUrl);
    });
  });

  group('ConectifyClient - API Fake Store', () {
    late ConectifyClient client;

    setUp(() {
      client = ConectifyClient(baseUrl: 'https://fakestoreapi.com');
    });

    tearDown(() {
      client.close();
    });

    test('get retorna Map para endpoint de un recurso', () async {
      final data = await client.get('/products/1');
      expect(data, isA<Map<String, dynamic>>());
      expect(data['id'], 1);
      expect(data['title'], isA<String>());
      expect(data['price'], isA<num>());
    });

    test('getList retorna List para endpoint de colección', () async {
      final data = await client.getList('/products');
      expect(data, isA<List<dynamic>>());
      expect(data.isNotEmpty, true);
      expect(data[0], isA<Map<String, dynamic>>());
    });

    test('get con queryParams construye URI correctamente', () async {
      final data = await client.getList('/products', queryParams: {'limit': '2'});
      expect(data, isA<List<dynamic>>());
      expect(data.length, lessThanOrEqualTo(2));
    });

    test('post crea recurso y retorna Map', () async {
      final body = {
        'title': 'ConectifyClient Test',
        'price': 10.99,
        'description': 'Test',
        'category': 'electronics',
        'image': 'https://example.com/img.jpg',
      };
      final data = await client.post('/products', body);
      expect(data, isA<Map<String, dynamic>>());
      expect(data['title'], 'ConectifyClient Test');
      expect(data['id'], isA<int>());
    });

    test('put actualiza recurso y retorna Map', () async {
      final product = await client.get('/products/1');
      final body = {
        ...product,
        'title': 'Updated by ConectifyClient Test',
      };
      final data = await client.put('/products/1', body);
      expect(data, isA<Map<String, dynamic>>());
      expect(data['title'], 'Updated by ConectifyClient Test');
    });

    test('delete elimina recurso y retorna Map', () async {
      final data = await client.delete('/products/1');
      expect(data, isA<Map<String, dynamic>>());
    });
  });
}
