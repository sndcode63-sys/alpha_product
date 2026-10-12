import 'package:get/get.dart';
import '../../core/constants/app_routes.dart';
import 'auth_controller.dart';

class CustomerModel {
  final String name;
  final String city;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final String gps;
  final String gst;
  final String salesperson;

  const CustomerModel({
    required this.name,
    required this.city,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.gps,
    required this.gst,
    required this.salesperson,
  });

  String get cityLabel => '$city, India';
}

class VisitController extends GetxController {
  final RxString query = ''.obs;
  final Rxn<CustomerModel> selected = Rxn<CustomerModel>();
  final RxBool selfieCaptured = false.obs;
  final RxBool isLoading = false.obs;

  final List<CustomerModel> customers = const [
    CustomerModel(
      name: 'ABC Traders',
      city: 'Delhi',
      contactPerson: 'Ramesh Gupta',
      phone: '+91 98765 43210',
      email: 'ramesh@abctraders.com',
      address: '12, Karol Bagh Market, New Delhi - 110005',
      gps: '28.6139, 77.2090',
      gst: '07ABCDE1234F1Z5',
      salesperson: 'Rahul Sharma',
    ),
    CustomerModel(
      name: 'Sharma Store',
      city: 'Noida',
      contactPerson: 'Anil Sharma',
      phone: '+91 98111 22334',
      email: 'anil@sharmastore.in',
      address: 'Shop 8, Sector 18 Market, Noida - 201301',
      gps: '28.5708, 77.3261',
      gst: '09FGHIJ5678K1Z2',
      salesperson: 'Rahul Sharma',
    ),
    CustomerModel(
      name: 'Mega Mart',
      city: 'Gurgaon',
      contactPerson: 'Vikas Mehta',
      phone: '+91 99100 55667',
      email: 'vikas@megamart.in',
      address: 'Plot 21, Sector 29, Gurgaon - 122001',
      gps: '28.4595, 77.0266',
      gst: '06KLMNO9012P1Z8',
      salesperson: 'Rahul Sharma',
    ),
    CustomerModel(
      name: 'Rahul Retail',
      city: 'Gurgaon',
      contactPerson: 'Rahul Verma',
      phone: '+91 97180 77889',
      email: 'rahul@rahulretail.com',
      address: '45, MG Road, Gurgaon - 122002',
      gps: '28.4800, 77.0800',
      gst: '06PQRST3456U1Z1',
      salesperson: 'Rahul Sharma',
    ),
    CustomerModel(
      name: 'Green World',
      city: 'Delhi',
      contactPerson: 'Sunita Singh',
      phone: '+91 98990 11223',
      email: 'sunita@greenworld.in',
      address: '7, Lajpat Nagar II, New Delhi - 110024',
      gps: '28.5677, 77.2433',
      gst: '07UVWXY7890Z1Z4',
      salesperson: 'Rahul Sharma',
    ),
  ];

  List<CustomerModel> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return customers;
    return customers
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.city.toLowerCase().contains(q) ||
            c.contactPerson.toLowerCase().contains(q))
        .toList();
  }

  void onSearch(String value) => query.value = value;

  // Navigation flow:
  // Customers -> Customer Details -> Start Visit (map) -> Visit Check-in
  void openCustomers() {
    query.value = '';
    Get.toNamed(AppRoutes.customers);
  }

  void openDetails(CustomerModel customer) {
    selected.value = customer;
    Get.toNamed(AppRoutes.customerDetails);
  }

  void openStartVisit() => Get.toNamed(AppRoutes.startVisit);

  void openVisitCheckIn() {
    selfieCaptured.value = false;
    Get.toNamed(AppRoutes.visitCheckIn);
  }

  void toggleSelfie() => selfieCaptured.toggle();

  Future<void> completeCheckIn() async {
    final auth = Get.find<AuthController>();
    if (!selfieCaptured.value) {
      auth.showToast('Please capture a selfie first');
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;
    Get.until((route) => route.settings.name == AppRoutes.dashboard);
    auth.showToast('Visit started at ${selected.value?.name ?? 'customer'}',
        isError: false);
  }
}
