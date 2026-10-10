import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import 'auth_controller.dart';

class AttendanceModel {
  final String date;
  final String checkIn;
  final String checkOut;
  final String workingHours;
  final String status; // Present, Absent, Late, Alert
  final String location;

  const AttendanceModel({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.workingHours,
    required this.status,
    required this.location,
  });
}

class AttendanceController extends GetxController {
  final RxString checkInTime = '09:15 AM'.obs;
  final RxString checkOutTime = '06:30 PM'.obs;
  final RxString workingHours = '9h 15m'.obs;
  final RxString location = '28.6139, 77.2090'.obs;
  final RxBool selfieCaptured = false.obs;
  final RxBool isLoading = false.obs;

  final RxList<AttendanceModel> historyList = <AttendanceModel>[
    const AttendanceModel(
      date: '13 Apr 2025',
      checkIn: '09:10 AM',
      checkOut: '06:25 PM',
      workingHours: '9h 15m',
      status: 'Present',
      location: '28.6139, 77.2090',
    ),
    const AttendanceModel(
      date: '12 Apr 2025',
      checkIn: '09:15 AM',
      checkOut: '06:30 PM',
      workingHours: '9h 15m',
      status: 'Present',
      location: '28.6138, 77.2089',
    ),
    const AttendanceModel(
      date: '11 Apr 2025',
      checkIn: '09:20 AM',
      checkOut: '06:05 PM',
      workingHours: '8h 45m',
      status: 'Present',
      location: '28.6137, 77.2088',
    ),
    const AttendanceModel(
      date: '10 Apr 2025',
      checkIn: '-',
      checkOut: '-',
      workingHours: '-',
      status: 'Absent',
      location: '-',
    ),
    const AttendanceModel(
      date: '09 Apr 2025',
      checkIn: '09:30 AM',
      checkOut: '06:40 PM',
      workingHours: '9h 10m',
      status: 'Late',
      location: '28.6136, 77.2087',
    ),
    const AttendanceModel(
      date: '08 Apr 2025',
      checkIn: '09:05 AM',
      checkOut: '06:10 PM',
      workingHours: '9h 05m',
      status: 'Present',
      location: '28.6135, 77.2086',
    ),
  ].obs;

  final Rx<AttendanceModel?> selectedDetail = Rx<AttendanceModel?>(null);

  void goCheckIn() {
    Get.toNamed(AppRoutes.checkIn);
  }

  void goCheckOut() {
    Get.toNamed(AppRoutes.checkOut);
  }

  void goHistory() {
    Get.toNamed(AppRoutes.attendanceHistory);
  }

  void goDetails(AttendanceModel record) {
    selectedDetail.value = record;
    Get.toNamed(AppRoutes.attendanceDetails, arguments: record);
  }

  Future<void> performCheckIn() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    checkInTime.value = _nowFormatted();
    selfieCaptured.value = true;
    isLoading.value = false;
    Get.find<AuthController>().showToast(AppStrings.checkIn + ' successful!', isError: false);
    Future.delayed(const Duration(milliseconds: 800), () => Get.back());
  }

  Future<void> performCheckOut() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    checkOutTime.value = _nowFormatted();
    isLoading.value = false;
    Get.find<AuthController>().showToast(AppStrings.checkOut + ' successful!', isError: false);
    Future.delayed(const Duration(milliseconds: 800), () => Get.back());
  }

  String _nowFormatted() {
    final now = DateTime.now();
    final hh = now.hour;
    final mm = now.minute.toString().padLeft(2, '0');
    final period = hh >= 12 ? 'PM' : 'AM';
    final hr = (hh % 12 == 0) ? 12 : hh % 12;
    return '$hr:$mm $period';
  }
}
