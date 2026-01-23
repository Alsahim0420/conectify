# Conectify

Paquete Flutter para realizar conexiones HTTP **sin dependencias externas**, utilizando únicamente
`dart:io` y `dart:convert`.

---

## Demostración

[![Demo](https://res.cloudinary.com/panmecar/image/upload/v1769177870/Grabaci%C3%B3n-de-pantalla-2026-01-23-a-la_s_-8.45.49_a.m._jcityk.gif)](https://res.cloudinary.com/panmecar/video/upload/v1769175981/Grabaci%C3%B3n_de_pantalla_2026-01-23_a_la_s_8.45.49_a.m._c3x6do.mov)


---

## Características

- Realizar solicitudes HTTP **GET, POST, PUT, DELETE**
- **Sin dependencias externas** (usa solo `dart:io`)
- Manejo de errores
- Fácil de usar y bien documentado
- Nombres genéricos que funcionan con cualquier API REST
- Ligero y reutilizable

---

## Instalación

Agrega `conectify` a tu archivo `pubspec.yaml`:

```yaml
dependencies:
  conectify:
    git:
      url: https://github.com/tu-usuario/conectify.git
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

### Crear una instancia del cliente

```dart
final client = ConectifyClient(
  baseUrl: 'https://api.ejemplo.com',
);
```

---

### Realizar una solicitud GET

```dart
try {
  final data = await client.get('/endpoint');
  print(data);
} catch (e) {
  print('Error: $e');
}
```

---

### Realizar una solicitud GET con parámetros de consulta

```dart
try {
  final data = await client.get(
    '/endpoint',
    queryParams: {
      'limit': '10',
      'offset': '0',
    },
  );
  print(data);
} catch (e) {
  print('Error: $e');
}
```

---

### Realizar una solicitud GET que retorna una lista

```dart
try {
  final list = await client.getList('/endpoint');
  for (final item in list) {
    print(item);
  }
} catch (e) {
  print('Error: $e');
}
```

---

### Realizar una solicitud POST

```dart
try {
  final data = await client.post(
    '/endpoint',
    {
      'key': 'value',
      'otra_key': 'otro_valor',
    },
  );
  print(data);
} catch (e) {
  print('Error: $e');
}
```

---

### Realizar una solicitud PUT

```dart
try {
  final data = await client.put(
    '/endpoint',
    {
      'key': 'nuevo_valor',
    },
  );
  print(data);
} catch (e) {
  print('Error: $e');
}
```

---

### Realizar una solicitud DELETE

```dart
try {
  final data = await client.delete('/endpoint');
  print(data);
} catch (e) {
  print('Error: $e');
}
```

---

### Cerrar el cliente

Cuando hayas terminado de usar el cliente, es recomendable cerrarlo:

```dart
client.close();
```

---

## Ejemplo con Fake Store API

Ejemplo completo usando la [Fake Store API](https://fakestoreapi.com/):

```dart
final client = ConectifyClient(
  baseUrl: 'https://fakestoreapi.com',
);

// Obtener lista de productos
final products = await client.getList('/products');

// Obtener un producto específico
final product = await client.get('/products/1');

// Obtener productos por categoría
final electronics =
    await client.getList('/products/category/electronics');

// Obtener todas las categorías
final categories = await client.getList('/products/categories');
```

### Ejecutar el ejemplo

```bash
cd example
flutter pub get
flutter run
```

---

## Manejo de Errores

Todas las operaciones pueden lanzar excepciones. Se recomienda manejarlas adecuadamente:

```dart
try {
  final data = await client.get('/endpoint');
  // Usar los datos
} catch (e) {
  print('Error: $e');
}
```

---

## Ventajas

- **Sin dependencias externas**
- **Ligero**
- **Genérico**
- **API clara y simple**
- Ideal para proyectos que buscan control total sobre las conexiones HTTP

---

## Licencia

Este proyecto está bajo la **Licencia MIT**.  
Consulta el archivo `LICENSE` para más detalles.
