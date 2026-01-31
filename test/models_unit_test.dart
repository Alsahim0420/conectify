import 'package:flutter_test/flutter_test.dart';
import 'package:conectify/conectify.dart';

void main() {
  group('Product', () {
    test('fromJson crea Product correctamente', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'price': 99.99,
        'description': 'Desc',
        'category': 'electronics',
        'image': 'https://example.com/img.jpg',
        'rating': {'rate': 4.5, 'count': 100},
      };
      final product = Product.fromJson(json);
      expect(product.id, 1);
      expect(product.title, 'Test');
      expect(product.price, 99.99);
      expect(product.description, 'Desc');
      expect(product.category, 'electronics');
      expect(product.image, 'https://example.com/img.jpg');
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 100);
    });

    test('fromJson acepta price como int', () {
      final json = {
        'id': 1,
        'title': 'T',
        'price': 10,
        'description': 'D',
        'category': 'c',
        'image': 'i',
        'rating': {'rate': 0.0, 'count': 0},
      };
      final product = Product.fromJson(json);
      expect(product.price, 10.0);
    });

    test('toJson serializa correctamente', () {
      const product = Product(
        id: 2,
        title: 'P',
        price: 19.99,
        description: 'D',
        category: 'jewelery',
        image: 'img',
        rating: Rating(rate: 3.0, count: 50),
      );
      final json = product.toJson();
      expect(json['id'], 2);
      expect(json['title'], 'P');
      expect(json['price'], 19.99);
      expect(json['description'], 'D');
      expect(json['category'], 'jewelery');
      expect(json['image'], 'img');
      expect(json['rating'], isA<Map<String, dynamic>>());
      expect((json['rating'] as Map)['rate'], 3.0);
      expect((json['rating'] as Map)['count'], 50);
    });
  });

  group('Rating', () {
    test('fromJson crea Rating correctamente', () {
      final json = {'rate': 4.2, 'count': 200};
      final rating = Rating.fromJson(json);
      expect(rating.rate, 4.2);
      expect(rating.count, 200);
    });

    test('fromJson acepta rate como int', () {
      final json = {'rate': 5, 'count': 10};
      final rating = Rating.fromJson(json);
      expect(rating.rate, 5.0);
    });

    test('toJson serializa correctamente', () {
      const rating = Rating(rate: 3.5, count: 75);
      final json = rating.toJson();
      expect(json['rate'], 3.5);
      expect(json['count'], 75);
    });
  });

  group('Category', () {
    test('fromJson con String crea Category', () {
      final category = Category.fromJson('electronics');
      expect(category.name, 'electronics');
    });

    test('fromJson con dynamic no String usa toString', () {
      final category = Category.fromJson(123);
      expect(category.name, '123');
    });

    test('toJson serializa correctamente', () {
      const category = Category(name: 'jewelery');
      final json = category.toJson();
      expect(json['name'], 'jewelery');
    });

    test('toString retorna name', () {
      const category = Category(name: 'men\'s clothing');
      expect(category.toString(), 'men\'s clothing');
    });
  });

  group('Name', () {
    test('fromJson crea Name correctamente', () {
      final json = {'firstname': 'John', 'lastname': 'Doe'};
      final name = Name.fromJson(json);
      expect(name.firstname, 'John');
      expect(name.lastname, 'Doe');
    });

    test('fullName concatena firstname y lastname', () {
      const name = Name(firstname: 'Jane', lastname: 'Smith');
      expect(name.fullName, 'Jane Smith');
    });

    test('toJson serializa correctamente', () {
      const name = Name(firstname: 'A', lastname: 'B');
      final json = name.toJson();
      expect(json['firstname'], 'A');
      expect(json['lastname'], 'B');
    });
  });

  group('Geolocation', () {
    test('fromJson crea Geolocation correctamente', () {
      final json = {'lat': '40.7128', 'long': '-74.0060'};
      final geo = Geolocation.fromJson(json);
      expect(geo.lat, '40.7128');
      expect(geo.long, '-74.0060');
    });

    test('toJson serializa correctamente', () {
      const geo = Geolocation(lat: '0', long: '0');
      final json = geo.toJson();
      expect(json['lat'], '0');
      expect(json['long'], '0');
    });
  });

  group('Address', () {
    test('fromJson crea Address correctamente', () {
      final json = {
        'city': 'Madrid',
        'street': 'Calle Mayor',
        'number': 1,
        'zipcode': '28013',
        'geolocation': {'lat': '40.4', 'long': '-3.7'},
      };
      final address = Address.fromJson(json);
      expect(address.city, 'Madrid');
      expect(address.street, 'Calle Mayor');
      expect(address.number, 1);
      expect(address.zipcode, '28013');
      expect(address.geolocation.lat, '40.4');
      expect(address.geolocation.long, '-3.7');
    });

    test('toJson serializa correctamente', () {
      const address = Address(
        city: 'Barcelona',
        street: 'Rambla',
        number: 5,
        zipcode: '08001',
        geolocation: Geolocation(lat: '41.4', long: '2.2'),
      );
      final json = address.toJson();
      expect(json['city'], 'Barcelona');
      expect(json['street'], 'Rambla');
      expect(json['number'], 5);
      expect(json['zipcode'], '08001');
      expect(json['geolocation'], isA<Map<String, dynamic>>());
    });
  });

  group('User', () {
    test('fromJson crea User correctamente', () {
      final json = {
        'id': 1,
        'email': 'user@test.com',
        'username': 'user1',
        'name': {'firstname': 'John', 'lastname': 'Doe'},
        'address': {
          'city': 'NY',
          'street': '5th Ave',
          'number': 100,
          'zipcode': '10001',
          'geolocation': {'lat': '40.7', 'long': '-74.0'},
        },
        'phone': '555-1234',
      };
      final user = User.fromJson(json);
      expect(user.id, 1);
      expect(user.email, 'user@test.com');
      expect(user.username, 'user1');
      expect(user.name.firstname, 'John');
      expect(user.name.lastname, 'Doe');
      expect(user.address.city, 'NY');
      expect(user.phone, '555-1234');
    });

    test('toJson serializa correctamente', () {
      const user = User(
        id: 2,
        email: 'e@e.com',
        username: 'u',
        name: Name(firstname: 'A', lastname: 'B'),
        address: Address(
          city: 'C',
          street: 'S',
          number: 1,
          zipcode: 'Z',
          geolocation: Geolocation(lat: '0', long: '0'),
        ),
        phone: '123',
      );
      final json = user.toJson();
      expect(json['id'], 2);
      expect(json['email'], 'e@e.com');
      expect(json['username'], 'u');
      expect(json['name'], isA<Map<String, dynamic>>());
      expect(json['address'], isA<Map<String, dynamic>>());
      expect(json['phone'], '123');
    });
  });
}
