import 'package:get/get.dart';

import '../screens/attendance_history_screen.dart';
import '../screens/delivery_complete_screen.dart';
import '../screens/delivery_details_screen.dart';
import '../screens/delivery_route_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/location_history_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/new_order_screen.dart';
import '../screens/signature_screen.dart';
import '../screens/about_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/delivery_summary_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/legal_screen.dart';
import '../screens/order_details_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/photo_preview_screen.dart';
import '../screens/report_problem_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/status_screen.dart';
import '../screens/trip_history_screen.dart';
import '../screens/vehicle_route_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const deliverySummary = '/delivery-summary';
  static const photoPreview = '/photo-preview';
  static const vehicleRoute = '/vehicle-route';
  static const tripHistory = '/trip-history';
  static const orderHistory = '/order-history';
  static const orderDetails = '/order-details';
  static const editProfile = '/edit-profile';
  static const changePassword = '/change-password';
  static const settings = '/settings';
  static const help = '/help';
  static const reportProblem = '/report-problem';
  static const about = '/about';
  static const legal = '/legal';
  static const noInternet = '/no-internet';
  static const permissionDenied = '/permission-denied';
  static const updateRequired = '/update-required';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const notifications = '/notifications';
  static const main = '/main';
  static const attendanceHistory = '/attendance-history';
  static const deliveryDetails = '/delivery-details';
  static const deliveryRoute = '/delivery-route';
  static const deliveryComplete = '/delivery-complete';
  static const signature = '/signature';
  static const newOrder = '/new-order';
  static const locationHistory = '/location-history';

  static final pages = <GetPage>[
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(name: deliverySummary, page: () => const DeliverySummaryScreen()),
    GetPage(name: photoPreview, page: () => const PhotoPreviewScreen()),
    GetPage(name: vehicleRoute, page: () => const VehicleRouteScreen()),
    GetPage(name: tripHistory, page: () => const TripHistoryScreen()),
    GetPage(name: orderHistory, page: () => const OrderHistoryScreen()),
    GetPage(name: orderDetails, page: () => const OrderDetailsScreen()),
    GetPage(name: editProfile, page: () => const EditProfileScreen()),
    GetPage(name: changePassword, page: () => const ChangePasswordScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: help, page: () => const HelpSupportScreen()),
    GetPage(name: reportProblem, page: () => const ReportProblemScreen()),
    GetPage(name: about, page: () => const AboutScreen()),
    GetPage(name: legal, page: () => const LegalScreen()),
    GetPage(name: noInternet, page: () => const NoInternetScreen()),
    GetPage(name: permissionDenied, page: () => const PermissionDeniedScreen()),
    GetPage(name: updateRequired, page: () => const UpdateRequiredScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: main, page: () => const MainShell()),
    GetPage(name: attendanceHistory, page: () => const AttendanceHistoryScreen()),
    GetPage(name: deliveryDetails, page: () => const DeliveryDetailsScreen()),
    GetPage(name: deliveryRoute, page: () => const DeliveryRouteScreen()),
    GetPage(name: deliveryComplete, page: () => const DeliveryCompleteScreen()),
    GetPage(name: signature, page: () => const SignatureScreen()),
    GetPage(name: newOrder, page: () => const NewOrderScreen()),
    GetPage(name: locationHistory, page: () => const LocationHistoryScreen()),
  ];
}
