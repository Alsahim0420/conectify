import 'package:flutter_test/flutter_test.dart';

import 'package:conectify/conectify.dart';

void main() {
  group('ConectifyClient', () {
    test('crea una instancia correctamente con baseUrl', () {
      const baseUrl = 'https://api.ejemplo.com';
      final client = ConectifyClient(baseUrl: baseUrl);
      
      expect(client.baseUrl, baseUrl);
    });

    test('puede cerrar el cliente', () {
      final client = ConectifyClient(baseUrl: 'https://api.ejemplo.com');
      
      // No debería lanzar excepción
      expect(() => client.close(), returnsNormally);
    });

    test('baseUrl se establece correctamente', () {
      const testUrl = 'https://pokeapi.co/api/v2';
      final client = ConectifyClient(baseUrl: testUrl);
      
      expect(client.baseUrl, testUrl);
    });
  });
}
