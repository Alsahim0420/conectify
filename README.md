# Conectify

Paquete Flutter para consumir la **Fake Store API** de manera sencilla y directa, sin necesidad de construir URLs o manejar detalles HTTP.

---

## Características

-  **API de alto nivel** - Métodos específicos 
-  **Sin dependencias externas** - Usa solo 
-  **Modelos tipados** - Product, Category, User con type safety
-  **Fácil de usar** - Una línea de código para obtener datos
-  **Manejo de errores** - Excepciones claras y descriptivas

---

## Instalación

Agrega `conectify` a tu archivo `pubspec.yaml` desde GitHub:

```yaml
dependencies:
  conectify:
    git:
      url: https://github.com/tu-usuario/conectify-FASE3.git
      ref: main  # o la rama/etiqueta que quieras usar
```

Luego ejecuta:

```bash
flutter pub get
```

---

## Uso

### Importar el paquete

```dart
import 'package:conectify/conectify.dart';
```

### Obtener todos los productos

```dart
final products = await Conectify.getProducts();
for (var product in products) {
  print('${product.title} - \$${product.price}');
}
```

### Obtener un producto específico

```dart
final product = await Conectify.getProduct(1);
print(product.title);
print(product.description);
print(product.rating.rate);
```

### Obtener productos por categoría

```dart
final electronics = await Conectify.getProductsByCategory('electronics');
for (var product in electronics) {
  print(product.title);
}
```

### Obtener todas las categorías

```dart
final categories = await Conectify.getCategories();
for (var category in categories) {
  print(category.name);
}
```

### Obtener usuarios

```dart
// Todos los usuarios
final users = await Conectify.getUsers();

// Un usuario específico
final user = await Conectify.getUser(1);
print(user.name.fullName);
print(user.email);
print(user.address.city);
```

### Crear, actualizar y eliminar productos

```dart
// Crear un producto
final newProduct = Product(
  id: 0,
  title: 'Nuevo Producto',
  price: 99.99,
  description: 'Descripción del producto',
  category: 'electronics',
  image: 'https://example.com/image.jpg',
  rating: const Rating(rate: 4.5, count: 100),
);

final created = await Conectify.createProduct(newProduct);

// Actualizar un producto
final updated = Product(
  id: created.id,
  title: 'Producto Actualizado',
  price: created.price,
  description: created.description,
  category: created.category,
  image: created.image,
  rating: created.rating,
);

await Conectify.updateProduct(updated);

// Eliminar un producto
await Conectify.deleteProduct(created.id);
```

### Cerrar la conexión

```dart
Conectify.close(); // útil para liberar recursos
```

---

## Modelos

### Product

```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
}
```

### Category

```dart
class Category {
  final String name;
}
```

### User

```dart
class User {
  final int id;
  final String email;
  final String username;
  final Name name;
  final Address address;
  final String phone;
}
```

---

## Ejemplo Completo

```dart
import 'package:flutter/material.dart';
import 'package:conectify/conectify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsScreen(),
    );
  }
}

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await Conectify.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ListTile(
          title: Text(product.title),
          subtitle: Text('\$${product.price}'),
          leading: Image.network(product.image),
        );
      },
    );
  }
}
```

---

## Manejo de Errores

Todas las operaciones pueden lanzar excepciones. Se recomienda manejarlas adecuadamente:

```dart
try {
  final products = await Conectify.getProducts();
  // Usar los productos
} catch (e) {
  print('Error al cargar productos: $e');
  // Mostrar mensaje al usuario
}
```

---

## API Completa

### Productos

- `Conectify.getProducts()` - Obtiene todos los productos
- `Conectify.getProduct(int id)` - Obtiene un producto por ID
- `Conectify.getProductsByCategory(String category)` - Filtra por categoría
- `Conectify.createProduct(Product product)` - Crea un nuevo producto
- `Conectify.updateProduct(Product product)` - Actualiza un producto
- `Conectify.deleteProduct(int id)` - Elimina un producto

### Categorías

- `Conectify.getCategories()` - Obtiene todas las categorías

### Usuarios

- `Conectify.getUsers()` - Obtiene todos los usuarios
- `Conectify.getUser(int id)` - Obtiene un usuario por ID

### Utilidades

- `Conectify.close()` - Cierra la conexión HTTP

---

## Ventajas

-  **API específica** - No necesitas construir URLs manualmente
-  **Type safety** - Modelos tipados para todos los datos
-  **Sin dependencias externas** - Solo usa `dart:io`
-  **Fácil de usar** - Métodos intuitivos y claros
-  **Bien documentado** - Código limpio y comentado

---

## Tests

Captura de la ejecución de los tests:

![Captura de los tests](https://res.cloudinary.com/panmecar/image/upload/v1769847409/test_fase3/Captura_de_pantalla_2026-01-31_a_la_s_3.16.33_a.m._okyn9d.png)

> Coloca tu imagen en `docs/captura-tests.png` (o actualiza la ruta arriba). Para generar cobertura: `./script/coverage.sh` (paquete) o `cd example && ./script/coverage.sh` (app de ejemplo).

