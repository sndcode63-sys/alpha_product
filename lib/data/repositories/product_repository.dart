

import '../../core/network/api_response.dart';
import '../../core/network/api_service.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<ApiResponse<List<dynamic>>> getProducts() async {
    try {
      final response = await _apiService.get('/product');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch products');
    }
  }

  // Get product details
  Future<ApiResponse<Map<String, dynamic>>> getProductDetails(String id) async {
    try {
      final response = await _apiService.get('/product/$id');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch product details');
    }
  }

  // Add new product
  Future<ApiResponse<Map<String, dynamic>>> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/product', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to add product');
    }
  }

  // Update product
  Future<ApiResponse<Map<String, dynamic>>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put('/product/$id', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to update product');
    }
  }

  // Update stock
  Future<ApiResponse<Map<String, dynamic>>> updateStock(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.patch('/product/$id/stock', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to update stock');
    }
  }
}
