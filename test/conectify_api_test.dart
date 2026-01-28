import 'package:flutter_test/flutter_test.dart';
import 'package:conectify/conectify.dart';

void main() {
  group('Conectify - API de Fake Store', () {
    tearDown(() {
      Conectify.close();
    });

    test('getProducts retorna una lista de productos', () async {
      final products = await Conectify.getProducts();
      
      expect(products, isA<List<Product>>());
      expect(products.isNotEmpty, true);
      expect(products[0], isA<Product>());
      expect(products[0].id, isA<int>());
      expect(products[0].title, isA<String>());
      expect(products[0].price, isA<double>());
    });

    test('getProduct retorna un producto específico', () async {
      final product = await Conectify.getProduct(1);
      
      expect(product, isA<Product>());
      expect(product.id, 1);
      expect(product.title, isA<String>());
      expect(product.price, isA<double>());
      expect(product.description, isA<String>());
      expect(product.category, isA<String>());
      expect(product.image, isA<String>());
      expect(product.rating, isA<Rating>());
    });

    test('getProductsByCategory retorna productos filtrados', () async {
      final products = await Conectify.getProductsByCategory('electronics');
      
      expect(products, isA<List<Product>>());
      expect(products.isNotEmpty, true);
      for (var product in products) {
        expect(product.category, 'electronics');
      }
    });

    test('getCategories retorna todas las categorías', () async {
      final categories = await Conectify.getCategories();
      
      expect(categories, isA<List<Category>>());
      expect(categories.isNotEmpty, true);
      expect(categories[0], isA<Category>());
      expect(categories[0].name, isA<String>());
    });

    test('getUsers retorna una lista de usuarios', () async {
      final users = await Conectify.getUsers();
      
      expect(users, isA<List<User>>());
      expect(users.isNotEmpty, true);
      expect(users[0], isA<User>());
      expect(users[0].id, isA<int>());
      expect(users[0].email, isA<String>());
      expect(users[0].username, isA<String>());
    });

    test('getUser retorna un usuario específico', () async {
      final user = await Conectify.getUser(1);
      
      expect(user, isA<User>());
      expect(user.id, 1);
      expect(user.email, isA<String>());
      expect(user.username, isA<String>());
      expect(user.name, isA<Name>());
      expect(user.address, isA<Address>());
      expect(user.phone, isA<String>());
    });

    test('createProduct crea un nuevo producto', () async {
      final newProduct = Product(
        id: 0, // Se asignará en el servidor
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: const Rating(rate: 4.5, count: 100),
      );
      
      final created = await Conectify.createProduct(newProduct);
      
      expect(created, isA<Product>());
      expect(created.id, isA<int>());
      expect(created.title, 'Test Product');
      expect(created.price, 99.99);
    });

    test('updateProduct actualiza un producto', () async {
      // Primero obtenemos un producto existente
      final product = await Conectify.getProduct(1);
      
      // Actualizamos el título
      final updated = Product(
        id: product.id,
        title: 'Updated Title',
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        rating: product.rating,
      );
      
      final result = await Conectify.updateProduct(updated);
      
      expect(result, isA<Product>());
      expect(result.id, product.id);
      expect(result.title, 'Updated Title');
    });

    test('deleteProduct elimina un producto', () async {
      final result = await Conectify.deleteProduct(1);
      
      expect(result, isA<Map<String, dynamic>>());
    });

    test('close cierra la conexión sin errores', () {
      expect(() => Conectify.close(), returnsNormally);
    });
  });

  group('Conectify - Modelos', () {
    test('Product.fromJson crea un producto desde JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 99.99,
        'description': 'Test Description',
        'category': 'electronics',
        'image': 'https://example.com/image.jpg',
        'rating': {
          'rate': 4.5,
          'count': 100,
        },
      };
      
      final product = Product.fromJson(json);
      
      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 100);
    });

    test('Category.fromJson crea una categoría desde JSON', () {
      final category = Category.fromJson('electronics');
      
      expect(category.name, 'electronics');
    });

    test('User.fromJson crea un usuario desde JSON', () {
      final json = {
        'id': 1,
        'email': 'test@example.com',
        'username': 'testuser',
        'name': {
          'firstname': 'John',
          'lastname': 'Doe',
        },
        'address': {
          'city': 'New York',
          'street': '123 Main St',
          'number': 1,
          'zipcode': '10001',
          'geolocation': {
            'lat': '40.7128',
            'long': '-74.0060',
          },
        },
        'phone': '123-456-7890',
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.name.firstname, 'John');
      expect(user.name.lastname, 'Doe');
      expect(user.address.city, 'New York');
    });
  });
}
