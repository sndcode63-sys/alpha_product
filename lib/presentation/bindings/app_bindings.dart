import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/visit_controller.dart';
import '../controllers/main_tab_controller.dart';
import '../controllers/delivery_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../controllers/customer_controller.dart';
import '../controllers/product_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<AttendanceController>(() => AttendanceController(), fenix: true);
    Get.lazyPut<VisitController>(() => VisitController(), fenix: true);
    Get.lazyPut<MainTabController>(() => MainTabController(), fenix: true);
    Get.lazyPut<DeliveryController>(() => DeliveryController(), fenix: true);
    Get.lazyPut<VehicleController>(() => VehicleController(), fenix: true);
    Get.lazyPut<CustomerController>(() => CustomerController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
  }
}
