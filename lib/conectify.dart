/// Paquete Flutter para consumir Fake Store API
/// 
/// Este paquete proporciona una interfaz fácil de usar para acceder
/// a la Fake Store API sin necesidad de construir URLs o manejar detalles HTTP.
/// 
/// Ejemplo de uso:
/// ```dart
/// final products = await Conectify.getProducts();
/// final product = await Conectify.getProduct(1);
/// final categories = await Conectify.getCategories();
/// ```
library conectify;

export 'src/conectify.dart';
export 'src/models/models.dart';

// Mantener compatibilidad con versiones anteriores
export 'src/conectify_client.dart' show ConectifyClient;
