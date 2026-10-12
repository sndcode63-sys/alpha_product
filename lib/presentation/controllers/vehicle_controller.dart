import 'package:get/get.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/vehicle.dart';
import '../../../data/repositories/local/vehicle_repository.dart';
import 'auth_controller.dart';

class VehicleController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Vehicle> vehicleList = <Vehicle>[].obs;
  final Rx<Vehicle?> selectedVehicle = Rx<Vehicle?>(null);

  final VehicleRepository _vehicleRepository = VehicleRepository();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadVehicles();
  }

  // Load all vehicles
  Future<void> loadVehicles() async {
    try {
      final vehicles = await _vehicleRepository.getAllVehicles();
      vehicleList.value = vehicles;
    } catch (e) {
      print('Error loading vehicles: $e');
    }
  }

  // Add new vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    isLoading.value = true;
    try {
      await _vehicleRepository.addVehicle(vehicle);
      await loadVehicles();
      isLoading.value = false;
      _authController.showToast('Vehicle added successfully!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to add vehicle');
    }
  }

  // Update vehicle location
  Future<void> updateVehicleLocation(int id) async {
    isLoading.value = true;
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        await _vehicleRepository.updateVehicleLocation(
          id,
          position.latitude,
          position.longitude,
        );
        await loadVehicles();
        isLoading.value = false;
        _authController.showToast('Location updated!', isError: false);
      } else {
        isLoading.value = false;
        _authController.showToast('Failed to get location');
      }
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to update location');
    }
  }

  // Update vehicle status
  Future<void> updateVehicleStatus(int id, String status) async {
    isLoading.value = true;
    try {
      await _vehicleRepository.updateVehicleStatus(id, status);
      await loadVehicles();
      isLoading.value = false;
      _authController.showToast('Status updated!', isError: false);
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to update status');
    }
  }

  // Select vehicle
  void selectVehicle(Vehicle vehicle) {
    selectedVehicle.value = vehicle;
  }

  // Open vehicle on map
  Future<void> openVehicleOnMap(Vehicle vehicle) async {
    if (vehicle.currentLat != null && vehicle.currentLng != null) {
      await LocationService.openGoogleMaps(
        vehicle.currentLat!,
        vehicle.currentLng!,
      );
    } else {
      _authController.showToast('No location data available');
    }
  }

  // Get status color
  String getStatusColor(String status) {
    switch (status) {
      case 'active':
        return '#10B981';
      case 'idle':
        return '#FF8A3C';
      case 'maintenance':
        return '#EF4444';
      default:
        return '#94A3B8';
    }
  }
}
