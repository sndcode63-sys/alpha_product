# API Integration Guide

This Flutter application is designed for easy API integration. All API-related code is centralized in the `lib/core/network` and `lib/data/repositories` directories.

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # API base URL and endpoints configuration
│   └── network/
│       ├── api_service.dart         # Dio-based HTTP client with interceptors
│       └── api_response.dart        # Standardized API response wrapper
└── data/
    └── repositories/
        ├── attendance_repository.dart   # Attendance API calls
        ├── delivery_repository.dart     # Delivery API calls
        ├── vehicle_repository.dart      # Vehicle API calls
        ├── customer_repository.dart     # Customer API calls
        └── product_repository.dart      # Product API calls
```

## Quick Setup

### 1. Configure Base URL

Edit `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  // Change this to your API base URL
  static const String baseUrl = 'https://your-api-domain.com';

  // API Endpoints
  static const String apiVersion = '/v1';
  static const String attendance = '$apiVersion/attendance';
  static const String delivery = '$apiVersion/delivery';
  static const String vehicle = '$apiVersion/vehicle';
  static const String customer = '$apiVersion/customer';
  static const String product = '$apiVersion/product';
  // ... more endpoints
}
```

### 2. Add Authentication (Optional)

If your API requires authentication, update the interceptor in `lib/core/network/api_service.dart`:

```dart
_dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    // Get token from secure storage
    final token = await _getToken();

    // Add Authorization header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  },
  // ... other interceptors
));
```

### 3. Use Repositories in Controllers

Example usage in a controller:

```dart
import 'package:get/get.dart';
import '../../data/repositories/attendance_repository.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _repository = AttendanceRepository();

  Future<void> fetchAttendance() async {
    try {
      final response = await _repository.getAttendance();
      if (response.success) {
        // Handle success
        print(response.data);
      } else {
        // Handle error
        print(response.message);
      }
    } catch (e) {
      // Handle exception
    }
  }
}
```

## Available API Methods

### AttendanceRepository
- `getAttendance()` - Get attendance data
- `checkIn(data)` - Check in
- `checkOut(data)` - Check out
- `getAttendanceHistory()` - Get attendance history

### DeliveryRepository
- `getDeliveries()` - Get all deliveries
- `getDeliveryDetails(id)` - Get delivery details
- `createDelivery(data)` - Create new delivery
- `updateDeliveryStatus(id, data)` - Update delivery status

### VehicleRepository
- `getVehicles()` - Get all vehicles
- `getVehicleDetails(id)` - Get vehicle details
- `getVehicleTracking(id)` - Get vehicle tracking data
- `addVehicle(data)` - Add new vehicle

### CustomerRepository
- `getCustomers()` - Get all customers
- `getCustomerDetails(id)` - Get customer details
- `addCustomer(data)` - Add new customer
- `updateCustomer(id, data)` - Update customer
- `searchCustomers(query)` - Search customers

### ProductRepository
- `getProducts()` - Get all products
- `getProductDetails(id)` - Get product details
- `addProduct(data)` - Add new product
- `updateProduct(id, data)` - Update product
- `updateStock(id, data)` - Update stock

## API Response Format

All API calls return a standardized `ApiResponse<T>`:

```dart
class ApiResponse<T> {
  final bool success;      // true if request succeeded
  final String? message;   // error message if failed
  final T? data;           // response data if successful
  final int? statusCode;   // HTTP status code
}
```

## Error Handling

The API service includes global error handling via Dio interceptors. You can customize error handling in `api_service.dart`:

```dart
onError: (error, handler) {
  // Handle errors globally
  // For example: show toast, redirect to login, etc.
  return handler.next(error);
}
```

## Adding New API Endpoints

1. Add endpoint to `api_config.dart`
2. Create method in the appropriate repository
3. Use the repository in your controller

Example:

```dart
// In api_config.dart
static const String newEndpoint = '$apiVersion/new-endpoint';

// In repository.dart
Future<ApiResponse<Map<String, dynamic>>> newData() async {
  try {
    final response = await _apiService.get(ApiConfig.newEndpoint);
    return ApiResponse.success(response.data);
  } catch (e) {
    return ApiResponse.error('Failed to fetch data');
  }
}
```

## Testing API Integration

You can test the API integration by:

1. Mocking the repository responses
2. Using a test API server
3. Checking network logs in your IDE

## Environment Configuration

For different environments (dev, staging, prod), you can:

1. Create environment-specific config files
2. Use `--dart-define` to pass the base URL at build time
3. Use `flutter_dotenv` package for .env files

Example using dart-define:

```dart
// In api_config.dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.example.com',
);
```

Build command:
```bash
flutter run --dart-define=API_BASE_URL=https://dev-api.example.com
```
