import 'dart:io';
import 'dart:convert';

/// Cliente base para realizar solicitudes HTTP
/// 
/// Este cliente utiliza dart:io para realizar solicitudes HTTP
/// sin requerir dependencias externas como http o dio.
class ConectifyClient {
  /// URL base de la API
  final String baseUrl;

  HttpClient? _httpClient;

  /// Crea una instancia del cliente
  /// 
  /// [baseUrl] es la URL base de la API a la que se conectará
  ConectifyClient({required this.baseUrl});

  /// Obtiene o crea una instancia de HttpClient
  HttpClient get _client {
    _httpClient ??= HttpClient();
    return _httpClient!;
  }

  /// Realiza una solicitud HTTP GET
  /// 
  /// [path] es la ruta del endpoint
  /// [queryParams] son los parámetros de consulta opcionales
  /// 
  /// Retorna un Map con la respuesta JSON o lanza una excepción si hay un error.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParams,
    );

    try {
      final request = await _client.getUrl(uri);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error en la solicitud GET: $e');
    }
  }

  /// Realiza una solicitud HTTP GET que retorna una lista
  /// 
  /// [path] es la ruta del endpoint
  /// [queryParams] son los parámetros de consulta opcionales
  /// 
  /// Retorna una List con la respuesta JSON o lanza una excepción si hay un error.
  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParams,
    );

    try {
      final request = await _client.getUrl(uri);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return json.decode(responseBody) as List<dynamic>;
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error en la solicitud GET: $e');
    }
  }

  /// Realiza una solicitud HTTP POST
  /// 
  /// [path] es la ruta del endpoint
  /// [body] es el cuerpo de la solicitud como Map
  /// 
  /// Retorna un Map con la respuesta JSON o lanza una excepción si hay un error.
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final request = await _client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      final bodyBytes = utf8.encode(json.encode(body));
      request.headers.set('Content-Length', bodyBytes.length);
      request.add(bodyBytes);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error en la solicitud POST: $e');
    }
  }

  /// Realiza una solicitud HTTP PUT
  /// 
  /// [path] es la ruta del endpoint
  /// [body] es el cuerpo de la solicitud como Map
  /// 
  /// Retorna un Map con la respuesta JSON o lanza una excepción si hay un error.
  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final request = await _client.putUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      final bodyBytes = utf8.encode(json.encode(body));
      request.headers.set('Content-Length', bodyBytes.length);
      request.add(bodyBytes);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error en la solicitud PUT: $e');
    }
  }

  /// Realiza una solicitud HTTP DELETE
  /// 
  /// [path] es la ruta del endpoint
  /// 
  /// Retorna un Map con la respuesta JSON o lanza una excepción si hay un error.
  Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final request = await _client.deleteUrl(uri);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error en la solicitud DELETE: $e');
    }
  }

  /// Cierra el cliente HTTP
  void close() {
    _httpClient?.close(force: true);
    _httpClient = null;
  }
}
