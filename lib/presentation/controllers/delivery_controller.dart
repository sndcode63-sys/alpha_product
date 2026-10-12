import 'package:get/get.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/delivery.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/local/delivery_repository.dart';
import 'auth_controller.dart';

class DeliveryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Delivery> deliveryList = <Delivery>[].obs;
  final Rx<Delivery?> selectedDelivery = Rx<Delivery?>(null);

  final DeliveryRepository _deliveryRepository = DeliveryRepository();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadDeliveries();
  }

  // Load deliveries
  Future<void> loadDeliveries() async {
    if (_authController.currentUser.value == null) return;

    try {
      final userId = _authController.currentUser.value!.id!;
      final deliveries = await _deliveryRepository.getDeliveriesByUser(userId);
      deliveryList.value = deliveries;
    } catch (e) {
      print('Error loading deliveries: $e');
    }
  }

  // Create new delivery
  Future<void> createDelivery(Delivery delivery) async {
    isLoading.value = true;
    try {
      await _deliveryRepository.createDelivery(delivery);
      await loadDeliveries();
      isLoading.value = false;
      _authController.showToast('Delivery created successfully!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to create delivery');
    }
  }

  // Update delivery status
  Future<void> updateDeliveryStatus(int id, String status) async {
    isLoading.value = true;
    try {
      await _deliveryRepository.updateDeliveryStatus(id, status);
      await loadDeliveries();
      isLoading.value = false;
      _authController.showToast('Status updated!', isError: false);
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to update status');
    }
  }

  // Start delivery (mark as in_progress)
  Future<void> startDelivery(Delivery delivery) async {
    isLoading.value = true;
    try {
      // Open map with directions
      if (delivery.lat != null && delivery.lng != null) {
        final position = await LocationService.getCurrentPosition();
        if (position != null) {
          await LocationService.openGoogleMapsDirections(
            position.latitude,
            position.longitude,
            delivery.lat!,
            delivery.lng!,
          );
        }
      }

      await _deliveryRepository.updateDeliveryStatus(delivery.id!, 'in_progress');
      await loadDeliveries();
      isLoading.value = false;
      _authController.showToast('Delivery started!', isError: false);
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to start delivery');
    }
  }

  // Complete delivery with proof
  Future<void> completeDelivery(
    int id,
    String? photoPath,
    String? signaturePath,
  ) async {
    isLoading.value = true;
    try {
      await _deliveryRepository.updateDeliveryProof(id, photoPath, signaturePath);
      await _deliveryRepository.updateDeliveryStatus(id, 'delivered');
      await loadDeliveries();
      isLoading.value = false;
      _authController.showToast('Delivery completed!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to complete delivery');
    }
  }

  // Get delivery details
  void selectDelivery(Delivery delivery) {
    selectedDelivery.value = delivery;
  }

  // Navigation
  void goDeliveryDetails(Delivery delivery) {
    selectedDelivery.value = delivery;
    Get.toNamed('/delivery-details', arguments: delivery);
  }

  // Status helper
  String getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return '#FF8A3C';
      case 'in_progress':
        return '#3498DB';
      case 'delivered':
        return '#10B981';
      default:
        return '#94A3B8';
    }
  }
}
