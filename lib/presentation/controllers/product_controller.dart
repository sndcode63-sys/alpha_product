import 'package:get/get.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/local/product_repository.dart';
import 'auth_controller.dart';

class ProductController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Product> productList = <Product>[].obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxString searchQuery = ''.obs;

  final ProductRepository _productRepository = ProductRepository();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  // Load all products
  Future<void> loadProducts() async {
    try {
      final products = await _productRepository.getAllProducts();
      productList.value = products;
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      await loadProducts();
    } else {
      try {
        final products = await _productRepository.getAllProducts();
        productList.value = products
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.sku.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } catch (e) {
        print('Error searching products: $e');
      }
    }
  }

  // Add new product
  Future<void> addProduct(Product product) async {
    isLoading.value = true;
    try {
      await _productRepository.addProduct(product);
      await loadProducts();
      isLoading.value = false;
      _authController.showToast('Product added successfully!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to add product');
    }
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    isLoading.value = true;
    try {
      await _productRepository.updateProduct(product);
      await loadProducts();
      isLoading.value = false;
      _authController.showToast('Product updated!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to update product');
    }
  }

  // Update stock
  Future<void> updateStock(int id, int newStock) async {
    isLoading.value = true;
    try {
      await _productRepository.updateStock(id, newStock);
      await loadProducts();
      isLoading.value = false;
      _authController.showToast('Stock updated!', isError: false);
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to update stock');
    }
  }

  // Select product
  void selectProduct(Product product) {
    selectedProduct.value = product;
  }

  // Go to product details
  void goProductDetails(Product product) {
    selectedProduct.value = product;
    Get.toNamed('/product-details', arguments: product);
  }

  // Get low stock products
  Future<void> loadLowStockProducts(int threshold) async {
    try {
      final products = await _productRepository.getLowStockProducts(threshold);
      productList.value = products;
    } catch (e) {
      print('Error loading low stock products: $e');
    }
  }

  // Get stock status
  String getStockStatus(int stock) {
    if (stock == 0) return 'Out of Stock';
    if (stock < 10) return 'Low Stock';
    return 'In Stock';
  }

  // Get stock color
  String getStockColor(int stock) {
    if (stock == 0) return '#EF4444';
    if (stock < 10) return '#FF8A3C';
    return '#10B981';
  }
}
