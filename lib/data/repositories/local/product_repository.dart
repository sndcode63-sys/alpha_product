import '../../../data/models/product.dart';
import '../../../data/database/database_helper.dart';

class ProductRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Get all products
  Future<List<Product>> getAllProducts() async {
    final results = await _db.query('products', orderBy: 'id DESC');
    return results.map((map) => Product.fromMap(map)).toList();
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    final results = await _db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Product.fromMap(results.first);
    }
    return null;
  }

  // Add new product
  Future<int> addProduct(Product product) async {
    return await _db.insert('products', product.toMap());
  }

  // Update product
  Future<int> updateProduct(Product product) async {
    return await _db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Update stock
  Future<int> updateStock(int id, int newStock) async {
    return await _db.update(
      'products',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get low stock products
  Future<List<Product>> getLowStockProducts(int threshold) async {
    final results = await _db.query(
      'products',
      where: 'stock < ?',
      whereArgs: [threshold],
      orderBy: 'stock ASC',
    );

    return results.map((map) => Product.fromMap(map)).toList();
  }
}
