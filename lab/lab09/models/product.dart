class Product {
  final int id;
  String name;
  String category;
  double price;
  bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      inStock: json['inStock'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'inStock': inStock,
      };
}
