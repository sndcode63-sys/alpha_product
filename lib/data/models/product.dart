class Product {
  final int? id;
  final String name;
  final String sku;
  final String? description;
  final double price;
  final int stock;
  final String? category;
  final String? imagePath;
  final String createdAt;

  Product({
    this.id,
    required this.name,
    required this.sku,
    this.description,
    required this.price,
    this.stock = 0,
    this.category,
    this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'image_path': imagePath,
      'created_at': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      sku: map['sku'],
      description: map['description'],
      price: map['price'],
      stock: map['stock'] ?? 0,
      category: map['category'],
      imagePath: map['image_path'],
      createdAt: map['created_at'],
    );
  }
}
