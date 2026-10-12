

import '../../core/network/api_response.dart';
import '../../core/network/api_service.dart';

class CustomerRepository {
  final ApiService _apiService = ApiService();

  // Get all customers
  Future<ApiResponse<List<dynamic>>> getCustomers() async {
    try {
      final response = await _apiService.get('/customer');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch customers');
    }
  }

  // Get customer details
  Future<ApiResponse<Map<String, dynamic>>> getCustomerDetails(String id) async {
    try {
      final response = await _apiService.get('/customer/$id');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch customer details');
    }
  }

  // Add new customer
  Future<ApiResponse<Map<String, dynamic>>> addCustomer(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/customer', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to add customer');
    }
  }

  // Update customer
  Future<ApiResponse<Map<String, dynamic>>> updateCustomer(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put('/customer/$id', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to update customer');
    }
  }

  // Search customers
  Future<ApiResponse<List<dynamic>>> searchCustomers(String query) async {
    try {
      final response = await _apiService.get('/customer/search', queryParameters: {'q': query});
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to search customers');
    }
  }
}
