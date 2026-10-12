import '../../core/network/api_response.dart';
import '../../core/network/api_service.dart';

class DeliveryRepository {
  final ApiService _apiService = ApiService();

  // Get all deliveries
  Future<ApiResponse<List<dynamic>>> getDeliveries() async {
    try {
      final response = await _apiService.get('/delivery');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch deliveries');
    }
  }

  // Get delivery details
  Future<ApiResponse<Map<String, dynamic>>> getDeliveryDetails(String id) async {
    try {
      final response = await _apiService.get('/delivery/$id');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch delivery details');
    }
  }

  // Create new delivery
  Future<ApiResponse<Map<String, dynamic>>> createDelivery(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/delivery', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to create delivery');
    }
  }

  // Update delivery status
  Future<ApiResponse<Map<String, dynamic>>> updateDeliveryStatus(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put('/delivery/$id', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to update delivery');
    }
  }
}
