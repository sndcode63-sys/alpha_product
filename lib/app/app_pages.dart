import 'package:alpha_field_app/imports.dart';
import 'package:alpha_field_app/presentation/screens/common/splash_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/login_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/attendance_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/attendance_history_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/customer_list_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/customer_detail_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/order_create_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/order_review_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/camera_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/notifications_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/sync_screen.dart';
import 'package:alpha_field_app/presentation/screens/common/profile_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/sales_home_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/meeting_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/start_field_work_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/visit_list_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/arrival_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/receipt_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/visit_history_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/follow_ups_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/ad_hoc_visit_screen.dart';
import 'package:alpha_field_app/presentation/screens/sales/end_field_work_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/trips_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/start_trip_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/trip_list_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/route_map_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/stop_detail_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/arrived_stop_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/delivery_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/failed_delivery_screen.dart';
import 'package:alpha_field_app/presentation/screens/driver/end_trip_screen.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.attendance, page: () => const AttendanceScreen()),
    GetPage(name: Routes.attHistory, page: () => const AttendanceHistoryScreen()),
    GetPage(name: Routes.custList, page: () => const CustomerListScreen()),
    GetPage(name: Routes.custDetail, page: () => const CustomerDetailScreen()),
    GetPage(name: Routes.orderCreate, page: () => const OrderCreateScreen()),
    GetPage(name: Routes.orderReview, page: () => const OrderReviewScreen()),
    GetPage(name: Routes.camera, page: () => const CameraScreen(), binding: BindingsBuilder(() => Get.put(PhotoController()))),
    GetPage(name: Routes.notifications, page: () => const NotificationsScreen()),
    GetPage(name: Routes.sync, page: () => const SyncScreen()),
    GetPage(name: Routes.profile, page: () => const ProfileScreen()),
    GetPage(name: Routes.salesHome, page: () => const SalesHomeScreen()),
    GetPage(name: Routes.meeting, page: () => const MeetingScreen()),
    GetPage(name: Routes.startFw, page: () => const StartFieldWorkScreen()),
    GetPage(name: Routes.visitList, page: () => const VisitListScreen()),
    GetPage(name: Routes.arrival, page: () => const ArrivalScreen()),
    GetPage(name: Routes.receipt, page: () => const ReceiptScreen()),
    GetPage(name: Routes.visitHistory, page: () => const VisitHistoryScreen()),
    GetPage(name: Routes.followUps, page: () => const FollowUpsScreen()),
    GetPage(name: Routes.adHoc, page: () => const AdHocVisitScreen()),
    GetPage(name: Routes.endFw, page: () => const EndFieldWorkScreen()),
    GetPage(name: Routes.trips, page: () => const TripsScreen()),
    GetPage(name: Routes.startTrip, page: () => const StartTripScreen()),
    GetPage(name: Routes.tripList, page: () => const TripListScreen()),
    GetPage(name: Routes.routeMap, page: () => const RouteMapScreen()),
    GetPage(name: Routes.stopDetail, page: () => const StopDetailScreen()),
    GetPage(name: Routes.arrivedStop, page: () => const ArrivedStopScreen()),
    GetPage(name: Routes.delivery, page: () => const DeliveryScreen()),
    GetPage(name: Routes.failedDelivery, page: () => const FailedDeliveryScreen()),
    GetPage(name: Routes.endTrip, page: () => const EndTripScreen()),
  ];
}
