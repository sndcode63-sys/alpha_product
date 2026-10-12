

import '../../core/network/api_response.dart';
import '../../core/network/api_service.dart';

class AttendanceRepository {
  final ApiService _apiService = ApiService();

  // Get attendance data
  Future<ApiResponse<Map<String, dynamic>>> getAttendance() async {
    try {
      final response = await _apiService.get('/attendance');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch attendance');
    }
  }

  // Check in
  Future<ApiResponse<Map<String, dynamic>>> checkIn(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/attendance/check-in', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to check in');
    }
  }

  // Check out
  Future<ApiResponse<Map<String, dynamic>>> checkOut(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/attendance/check-out', data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to check out');
    }
  }

  // Get attendance history
  Future<ApiResponse<List<dynamic>>> getAttendanceHistory() async {
    try {
      final response = await _apiService.get('/attendance/history');
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch history');
    }
  }
}
