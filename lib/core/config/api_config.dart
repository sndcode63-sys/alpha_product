class ApiConfig {
  ApiConfig._();

  // Base URL - Change this dynamically based on environment
  static const String baseUrl = 'https://api.example.com';

  // API Endpoints
  static const String apiVersion = '/v1';

  // Endpoints for different modules
  static const String auth = '$apiVersion/auth';
  static const String attendance = '$apiVersion/attendance';
  static const String delivery = '$apiVersion/delivery';
  static const String vehicle = '$apiVersion/vehicle';
  static const String customer = '$apiVersion/customer';
  static const String product = '$apiVersion/product';
  static const String employee = '$apiVersion/employee';

  // Timeout durations
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
}
