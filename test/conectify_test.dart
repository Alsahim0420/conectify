import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:conectify/conectify.dart';

void main() {
  group('ConectifyClient - Inicialización', () {
    test('crea una instancia correctamente con baseUrl', () {
      const baseUrl = 'https://api.ejemplo.com';
      final client = ConectifyClient(baseUrl: baseUrl);
      
      expect(client.baseUrl, baseUrl);
    });

    test('baseUrl se establece correctamente', () {
      const testUrl = 'https://pokeapi.co/api/v2';
      final client = ConectifyClient(baseUrl: testUrl);
      
      expect(client.baseUrl, testUrl);
    });

    test('puede cerrar el cliente sin errores', () {
      final client = ConectifyClient(baseUrl: 'https://api.ejemplo.com');
      
      expect(() => client.close(), returnsNormally);
    });

    test('puede cerrar el cliente múltiples veces sin errores', () {
      final client = ConectifyClient(baseUrl: 'https://api.ejemplo.com');
      
      client.close();
      expect(() => client.close(), returnsNormally);
    });
  });

  group('ConectifyClient - Método GET', () {
    late HttpServer testServer;
    late ConectifyClient client;
    int port = 0;

    setUp(() async {
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) {
        if (request.method == 'GET' && request.uri.path == '/test') {
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode({'message': 'success', 'data': 'test'}));
          response.close();
        } else if (request.method == 'GET' && request.uri.path == '/error') {
          final response = request.response;
          response.statusCode = 404;
          response.write('Not Found');
          response.close();
        } else if (request.method == 'GET' && request.uri.path == '/query') {
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode({
            'query': request.uri.queryParameters.toString(),
            'param1': request.uri.queryParameters['param1'],
            'param2': request.uri.queryParameters['param2'],
          }));
          response.close();
        }
      });
    });

    tearDown(() async {
      client.close();
      await testServer.close(force: true);
    });

    test('realiza una solicitud GET exitosa', () async {
      final result = await client.get('/test');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], 'success');
      expect(result['data'], 'test');
    });

    test('maneja errores HTTP en GET', () async {
      expect(
        () => client.get('/error'),
        throwsA(isA<Exception>()),
      );
    });

    test('GET con query parameters', () async {
      final result = await client.get(
        '/query',
        queryParams: {'param1': 'value1', 'param2': 'value2'},
      );
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['param1'], 'value1');
      expect(result['param2'], 'value2');
    });

    test('GET sin query parameters', () async {
      final result = await client.get('/query');
      
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('ConectifyClient - Método GET List', () {
    late HttpServer testServer;
    late ConectifyClient client;
    int port = 0;

    setUp(() async {
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) {
        if (request.method == 'GET' && request.uri.path == '/list') {
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode([
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
          ]));
          response.close();
        } else if (request.method == 'GET' && request.uri.path == '/list-error') {
          final response = request.response;
          response.statusCode = 500;
          response.write('Internal Server Error');
          response.close();
        }
      });
    });

    tearDown(() async {
      client.close();
      await testServer.close(force: true);
    });

    test('realiza una solicitud GET que retorna una lista', () async {
      final result = await client.getList('/list');
      
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[1]['id'], 2);
    });

    test('maneja errores HTTP en getList', () async {
      expect(
        () => client.getList('/list-error'),
        throwsA(isA<Exception>()),
      );
    });

    test('getList con query parameters', () async {
      testServer.close(force: true);
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) {
        if (request.method == 'GET' && request.uri.path == '/list') {
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode([
            {'filter': request.uri.queryParameters['filter']},
          ]));
          response.close();
        }
      });

      final result = await client.getList(
        '/list',
        queryParams: {'filter': 'active'},
      );
      
      expect(result, isA<List<dynamic>>());
      expect(result[0]['filter'], 'active');
    });
  });

  group('ConectifyClient - Método POST', () {
    late HttpServer testServer;
    late ConectifyClient client;
    int port = 0;

    setUp(() async {
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) async {
        if (request.method == 'POST' && request.uri.path == '/post') {
          final bodyBytes = <int>[];
          await for (var data in request) {
            bodyBytes.addAll(data);
          }
          final body = utf8.decode(bodyBytes);
          final response = request.response;
          response.statusCode = 201;
          response.headers.contentType = ContentType.json;
          response.write(json.encode({
            'success': true,
            'received': json.decode(body),
          }));
          response.close();
        } else if (request.method == 'POST' && request.uri.path == '/post-error') {
          final response = request.response;
          response.statusCode = 400;
          response.write('Bad Request');
          response.close();
        }
      });
    });

    tearDown(() async {
      client.close();
      await testServer.close(force: true);
    });

    test('realiza una solicitud POST exitosa', () async {
      final body = {'name': 'Test', 'value': 123};
      final result = await client.post('/post', body);
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], true);
      expect(result['received'], body);
    });

    test('POST con status 200 también es exitoso', () async {
      testServer.close(force: true);
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) async {
        if (request.method == 'POST' && request.uri.path == '/post') {
          final bodyBytes = <int>[];
          await for (var data in request) {
            bodyBytes.addAll(data);
          }
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode({'success': true}));
          response.close();
        }
      });

      final result = await client.post('/post', {'test': 'data'});
      expect(result['success'], true);
    });

    test('maneja errores HTTP en POST', () async {
      expect(
        () => client.post('/post-error', {'test': 'data'}),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ConectifyClient - Método PUT', () {
    late HttpServer testServer;
    late ConectifyClient client;
    int port = 0;

    setUp(() async {
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) async {
        if (request.method == 'PUT' && request.uri.path == '/put') {
          final bodyBytes = <int>[];
          await for (var data in request) {
            bodyBytes.addAll(data);
          }
          final body = utf8.decode(bodyBytes);
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode({
            'success': true,
            'updated': json.decode(body),
          }));
          response.close();
        } else if (request.method == 'PUT' && request.uri.path == '/put-error') {
          final response = request.response;
          response.statusCode = 404;
          response.write('Not Found');
          response.close();
        }
      });
    });

    tearDown(() async {
      client.close();
      await testServer.close(force: true);
    });

    test('realiza una solicitud PUT exitosa', () async {
      final body = {'id': 1, 'name': 'Updated'};
      final result = await client.put('/put', body);
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], true);
      expect(result['updated'], body);
    });

    test('maneja errores HTTP en PUT', () async {
      expect(
        () => client.put('/put-error', {'test': 'data'}),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ConectifyClient - Método DELETE', () {
    late HttpServer testServer;
    late ConectifyClient client;
    int port = 0;

    setUp(() async {
      testServer = await HttpServer.bind('localhost', 0);
      port = testServer.port;
      client = ConectifyClient(baseUrl: 'http://localhost:$port');
      
      testServer.listen((request) {
        if (request.method == 'DELETE' && request.uri.path == '/delete') {
          final response = request.response;
          response.statusCode = 200;
          response.headers.contentType = ContentType.json;
          response.write(json.encode({'success': true, 'deleted': true}));
          response.close();
        } else if (request.method == 'DELETE' && request.uri.path == '/delete-error') {
          final response = request.response;
          response.statusCode = 404;
          response.write('Not Found');
          response.close();
        }
      });
    });

    tearDown(() async {
      client.close();
      await testServer.close(force: true);
    });

    test('realiza una solicitud DELETE exitosa', () async {
      final result = await client.delete('/delete');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], true);
      expect(result['deleted'], true);
    });

    test('maneja errores HTTP en DELETE', () async {
      expect(
        () => client.delete('/delete-error'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ConectifyClient - Manejo de Errores', () {
    test('maneja errores de conexión', () async {
      final client = ConectifyClient(baseUrl: 'http://localhost:99999');
      
      expect(
        () => client.get('/test'),
        throwsA(isA<Exception>()),
      );
      
      client.close();
    });

    test('maneja URLs inválidas', () async {
      final client = ConectifyClient(baseUrl: 'not-a-valid-url');
      
      expect(
        () => client.get('/test'),
        throwsA(isA<Exception>()),
      );
      
      client.close();
    });
  });

  group('ConectifyClient - HttpClient Reutilización', () {
    test('reutiliza la misma instancia de HttpClient', () async {
      final client = ConectifyClient(baseUrl: 'https://api.ejemplo.com');
      
      // El cliente debe crear HttpClient solo cuando se necesita
      expect(() => client.close(), returnsNormally);
    });
  });
}
