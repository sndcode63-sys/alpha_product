import 'package:get/get.dart';

import '../controllers/attendance_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/delivery_controller.dart';
import '../controllers/nav_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/vehicle_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(NavController(), permanent: true);
    Get.put(OrderController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(AttendanceController(), permanent: true);
    Get.put(DeliveryController(), permanent: true);
    Get.put(VehicleController(), permanent: true);
  }
}
