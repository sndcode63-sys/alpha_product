import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import 'auth_controller.dart';
import 'visit_controller.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final user = RxMap<String, String>({
    'name': AppStrings.rahulSharma,
    'role': AppStrings.supervisor,
    'phone': '9876543210',
    'email': 'rahul.sharma@company.com',
    'avatar': 'https://i.pravatar.cc/300?img=12',
  });

  void navigateToAttendance() {
    Get.toNamed(AppRoutes.attendanceDashboard);
  }

  void navigateToVisits() {
    Get.find<VisitController>().openCustomers();
  }

  void comingSoon(String feature) {
    Get.find<AuthController>().comingSoon(feature);
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.myProfile);
  }

  void onTapIndex(int index) {
    if (index == 1) {
      comingSoon('Tasks');
      return;
    }
    if (index == 2) {
      comingSoon('Chat');
      return;
    }
    currentIndex.value = index;
  }

  void showLogoutDialog() {
    final authCtrl = Get.find<AuthController>();
    authCtrl.showToast('Tap on Logout from profile page');
  }
}
