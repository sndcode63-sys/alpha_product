import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/splash_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/attendance_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<AttendanceController>(() => AttendanceController(), fenix: true);
  }
}
