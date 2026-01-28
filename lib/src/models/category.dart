/// Modelo de Categoría de Fake Store API
class Category {
  final String name;

  const Category({required this.name});

  factory Category.fromJson(dynamic json) {
    return Category(name: json.toString());
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  String toString() => name;
}
