import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/attendance.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/local/attendance_repository.dart';
import 'auth_controller.dart';

class AttendanceController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<Attendance?> todayAttendance = Rx<Attendance?>(null);
  final RxList<Attendance> historyList = <Attendance>[].obs;

  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadTodayAttendance();
    loadAttendanceHistory();
  }

  // Load today's attendance
  Future<void> loadTodayAttendance() async {
    if (_authController.currentUser.value == null) return;

    try {
      final userId = _authController.currentUser.value!.id!;
      final attendance = await _attendanceRepository.getTodayAttendance(userId);
      todayAttendance.value = attendance;
    } catch (e) {
      print('Error loading today attendance: $e');
    }
  }

  // Load attendance history
  Future<void> loadAttendanceHistory() async {
    if (_authController.currentUser.value == null) return;

    try {
      final userId = _authController.currentUser.value!.id!;
      final history = await _attendanceRepository.getAttendanceHistory(userId);
      historyList.value = history;
    } catch (e) {
      print('Error loading attendance history: $e');
    }
  }

  // Check in
  Future<void> performCheckIn() async {
    if (_authController.currentUser.value == null) {
      _authController.showToast('Please login first');
      return;
    }

    isLoading.value = true;

    try {
      // Get current location
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        isLoading.value = false;
        _authController.showToast('Failed to get location. Please enable GPS.');
        return;
      }

      final userId = _authController.currentUser.value!.id!;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final now = DateTime.now();

      final attendance = Attendance(
        userId: userId,
        date: today,
        checkInTime: now.toIso8601String(),
        checkInLat: position.latitude,
        checkInLng: position.longitude,
        checkInAddress: 'Location captured',
        status: 'present',
      );

      await _attendanceRepository.checkIn(attendance);
      await loadTodayAttendance();
      await loadAttendanceHistory();

      isLoading.value = false;
      _authController.showToast('Check-in successful!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Check-in failed. Please try again.');
    }
  }

  // Check out
  Future<void> performCheckOut() async {
    if (todayAttendance.value == null) {
      _authController.showToast('No check-in record found');
      return;
    }

    isLoading.value = true;

    try {
      // Get current location
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        isLoading.value = false;
        _authController.showToast('Failed to get location. Please enable GPS.');
        return;
      }

      final now = DateTime.now();
      final checkInTime = DateTime.parse(todayAttendance.value!.checkInTime!);
      final workingHours = now.difference(checkInTime).inHours.toDouble();

      final updatedAttendance = Attendance(
        id: todayAttendance.value!.id,
        userId: todayAttendance.value!.userId,
        date: todayAttendance.value!.date,
        checkInTime: todayAttendance.value!.checkInTime,
        checkOutTime: now.toIso8601String(),
        checkInLat: todayAttendance.value!.checkInLat,
        checkInLng: todayAttendance.value!.checkInLng,
        checkOutLat: position.latitude,
        checkOutLng: position.longitude,
        checkOutAddress: 'Location captured',
        status: 'present',
        workingHours: workingHours,
      );

      await _attendanceRepository.checkOut(updatedAttendance);
      await loadTodayAttendance();
      await loadAttendanceHistory();

      isLoading.value = false;
      _authController.showToast('Check-out successful!', isError: false);
      Get.back();
    } catch (e) {
      isLoading.value = false;
      _authController.showToast('Check-out failed. Please try again.');
    }
  }

  // Navigation methods
  void goCheckIn() {
    Get.toNamed(AppRoutes.checkIn);
  }

  void goCheckOut() {
    Get.toNamed(AppRoutes.checkOut);
  }

  void goHistory() {
    Get.toNamed(AppRoutes.attendanceHistory);
  }

  void goDetails(Attendance record) {
    Get.toNamed(AppRoutes.attendanceDetails, arguments: record);
  }

  // Format time for display
  String formatTime(String? isoTime) {
    if (isoTime == null) return '--:--';
    final dt = DateTime.parse(isoTime);
    final hh = dt.hour;
    final mm = dt.minute.toString().padLeft(2, '0');
    final period = hh >= 12 ? 'PM' : 'AM';
    final hr = (hh % 12 == 0) ? 12 : hh % 12;
    return '$hr:$mm $period';
  }

  // Format date for display
  String formatDate(String date) {
    final dt = DateTime.parse(date);
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // Calculate working hours display
  String formatWorkingHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return '${h}h ${m}m';
  }
}
