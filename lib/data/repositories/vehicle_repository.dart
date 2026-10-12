
import '../../core/network/api_response.dart';
import '../../core/network/api_service.dart';

class VehicleRepository {
  final ApiService _apiService = ApiService();

  // Get all vehicles
  Future<ApiResponse<List<dynamic>>> getVehicles() async {
    try {
      final response = await _apiService.get('/vehicle');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch vehicles');
    }
  }

  // Get vehicle details
  Future<ApiResponse<Map<String, dynamic>>> getVehicleDetails(String id) async {
    try {
      final response = await _apiService.get('/vehicle/$id');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch vehicle details');
    }
  }

  // Get vehicle tracking data
  Future<ApiResponse<Map<String, dynamic>>> getVehicleTracking(String id) async {
    try {
      final response = await _apiService.get('/vehicle/$id/tracking');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch tracking data');
    }
  }

  // Add new vehicle
  Future<ApiResponse<Map<String, dynamic>>> addVehicle(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/vehicle', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to add vehicle');
    }
  }
}
