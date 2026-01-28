import 'conectify_base.dart';
import 'models/models.dart';

/// Cliente principal de Conectify para Fake Store API
/// 
/// Proporciona métodos de alto nivel para acceder a la Fake Store API
/// sin necesidad de construir URLs o manejar detalles HTTP.
/// 
/// Ejemplo de uso:
/// ```dart
/// final products = await Conectify.getProducts();
/// final product = await Conectify.getProduct(1);
/// final categories = await Conectify.getCategories();
/// ```
class Conectify {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static ConectifyBase? _client;

  /// Obtiene o crea el cliente HTTP interno
  static ConectifyBase get _baseClient {
    _client ??= ConectifyBase(baseUrl: _baseUrl);
    return _client!;
  }

  /// Obtiene todos los productos
  /// 
  /// Retorna una lista de [Product] o lanza una excepción si hay un error.
  static Future<List<Product>> getProducts() async {
    final data = await _baseClient.getList('/products');
    return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtiene un producto específico por su ID
  /// 
  /// [id] es el identificador del producto.
  /// Retorna un [Product] o lanza una excepción si hay un error.
  static Future<Product> getProduct(int id) async {
    final data = await _baseClient.get('/products/$id');
    return Product.fromJson(data);
  }

  /// Obtiene productos filtrados por categoría
  /// 
  /// [category] es el nombre de la categoría (ej: 'electronics', 'jewelery').
  /// Retorna una lista de [Product] o lanza una excepción si hay un error.
  static Future<List<Product>> getProductsByCategory(String category) async {
    final data = await _baseClient.getList('/products/category/$category');
    return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtiene todas las categorías disponibles
  /// 
  /// Retorna una lista de [Category] o lanza una excepción si hay un error.
  static Future<List<Category>> getCategories() async {
    final data = await _baseClient.getList('/products/categories');
    return data.map((json) => Category.fromJson(json)).toList();
  }

  /// Obtiene todos los usuarios
  /// 
  /// Retorna una lista de [User] o lanza una excepción si hay un error.
  static Future<List<User>> getUsers() async {
    final data = await _baseClient.getList('/users');
    return data.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtiene un usuario específico por su ID
  /// 
  /// [id] es el identificador del usuario.
  /// Retorna un [User] o lanza una excepción si hay un error.
  static Future<User> getUser(int id) async {
    final data = await _baseClient.get('/users/$id');
    return User.fromJson(data);
  }

  /// Crea un nuevo producto
  /// 
  /// [product] es el producto a crear.
  /// Retorna el [Product] creado con su ID asignado.
  static Future<Product> createProduct(Product product) async {
    final data = await _baseClient.post('/products', product.toJson());
    return Product.fromJson(data);
  }

  /// Actualiza un producto existente
  /// 
  /// [product] es el producto con los datos actualizados.
  /// Retorna el [Product] actualizado.
  static Future<Product> updateProduct(Product product) async {
    final data = await _baseClient.put('/products/${product.id}', product.toJson());
    return Product.fromJson(data);
  }

  /// Elimina un producto
  /// 
  /// [id] es el identificador del producto a eliminar.
  /// Retorna un Map con la respuesta de la eliminación.
  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    return await _baseClient.delete('/products/$id');
  }

  /// Cierra la conexión HTTP
  /// 
  /// Útil para liberar recursos cuando ya no se necesite el cliente.
  static void close() {
    _client?.close();
    _client = null;
  }
}
