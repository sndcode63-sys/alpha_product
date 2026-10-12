import 'package:get/get.dart';
import '../../core/constants/app_routes.dart';
import '../controllers/splash_controller.dart';
import '../views/splash/splash_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/auth/otp_verify_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/profile/my_profile_screen.dart';
import '../views/profile/change_password_screen.dart';
// Old attendance screens removed - using new module screen
// import '../views/attendance/attendance_dashboard_screen.dart';
// import '../views/attendance/check_in_screen.dart';
// import '../views/attendance/check_out_screen.dart';
// import '../views/attendance/attendance_history_screen.dart';
// import '../views/attendance/attendance_details_screen.dart';
// Old visit screens removed
// import '../views/visits/customers_screen.dart';
// import '../views/visits/customer_details_screen.dart';
// import '../views/visits/start_visit_screen.dart';
// import '../views/visits/visit_checkin_screen.dart';
import '../views/main_tab_screen.dart';

class AppPages {
  AppPages._();
  static String get initial => AppRoutes.splash;
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder.put(() => SplashController()),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.otpVerify,
      page: () => const OtpVerifyScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.myProfile,
      page: () => const MyProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
    ),
    // Old attendance routes removed - using new module screen
    // GetPage(
    //   name: AppRoutes.attendanceDashboard,
    //   page: () => const AttendanceDashboardScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.checkIn,
    //   page: () => const CheckInScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.checkOut,
    //   page: () => const CheckOutScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.attendanceHistory,
    //   page: () => const AttendanceHistoryScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.attendanceDetails,
    //   page: () => const AttendanceDetailsScreen(),
    // ),
    // Old visit routes removed
    // GetPage(
    //   name: AppRoutes.customers,
    //   page: () => const CustomersScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.customerDetails,
    //   page: () => const CustomerDetailsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.startVisit,
    //   page: () => const StartVisitScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.visitCheckIn,
    //   page: () => const VisitCheckInScreen(),
    // ),
    GetPage(
      name: AppRoutes.mainTab,
      page: () => const MainTabScreen(),
    ),
  ];
}
