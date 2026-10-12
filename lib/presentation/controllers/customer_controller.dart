import 'package:get/get.dart';
import '../../../data/models/customer.dart';
import '../../../data/repositories/local/customer_repository.dart';
import 'auth_controller.dart';

class CustomerController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Customer> customerList = <Customer>[].obs;
  final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
  final RxString searchQuery = ''.obs;

  final CustomerRepository _customerRepository = CustomerRepository();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  // Load all customers
  Future<void> loadCustomers() async {
    try {
      final customers = await _customerRepository.getAllCustomers();
      customerList.value = customers;
    } catch (e) {
      print('Error loading customers: $e');
    }
  }

  // Search customers
  Future<void> searchCustomers(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      await loadCustomers();
    } else {
      try {
        final results = await _customerRepository.searchCustomers(query);
        customerList.value = results;
      } catch (e) {
        print('Error searching customers: $e');
      }
    }
  }

  // Add new customer
  Future<void> addCustomer(Customer customer) async {
    isLoading.value = true;
    try {
      await _customerRepository.addCustomer(customer);
      await loadCustomers();
      isLoading.value = false;
      _authController.showToast('Customer added successfully!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to add customer');
    }
  }

  // Update customer
  Future<void> updateCustomer(Customer customer) async {
    isLoading.value = true;
    try {
      await _customerRepository.updateCustomer(customer);
      await loadCustomers();
      isLoading.value = false;
      _authController.showToast('Customer updated!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Failed to update customer');
    }
  }

  // Select customer
  void selectCustomer(Customer customer) {
    selectedCustomer.value = customer;
  }

  // Go to customer details
  void goCustomerDetails(Customer customer) {
    selectedCustomer.value = customer;
    Get.toNamed('/customer-details', arguments: customer);
  }

  // Filter by status
  void filterByStatus(String status) async {
    try {
      final customers = await _customerRepository.getAllCustomers();
      if (status == 'all') {
        customerList.value = customers;
      } else {
        customerList.value = customers.where((c) => c.status == status).toList();
      }
    } catch (e) {
      print('Error filtering customers: $e');
    }
  }

  // Get status color
  String getStatusColor(String status) {
    switch (status) {
      case 'active':
        return '#10B981';
      case 'inactive':
        return '#94A3B8';
      case 'vip':
        return '#FF8A3C';
      default:
        return '#94A3B8';
    }
  }
}
