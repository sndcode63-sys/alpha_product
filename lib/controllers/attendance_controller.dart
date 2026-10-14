import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class AttendanceController extends GetxController {
  final checkedIn = false.obs;
  final checkInAt = Rxn<DateTime>();
  final checkOutAt = Rxn<DateTime>();
  final worked = Duration.zero.obs;
  final selfieTaken = false.obs;
  final locationGranted = false.obs;
  final location = 'Pune, Maharashtra (18.5204° N, 73.8567° E)'.obs;
  final history = <AttendanceRecord>[].obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    history.assignAll(MockData.attendance());
  }

  Future<bool> _ensureLocation() async {
    if (locationGranted.value) return true;
    // TODO: geolocator / permission_handler se real permission lo
    final ok = await AppDialogs.permission(
      title: 'Location permission',
      message: 'Attendance ke liye aapki GPS location chahiye. Allow karo.',
    );
    if (!ok) {
      Get.toNamed(AppRoutes.permissionDenied, arguments: 'location');
      return false;
    }
    locationGranted.value = true;
    return true;
  }

  Future<void> captureSelfie() async {
    final ok = await AppDialogs.permission(
      title: 'Camera permission',
      message: 'Selfie lene ke liye camera access chahiye.',
      icon: Icons.camera_alt_outlined,
    );
    if (!ok) {
      Get.toNamed(AppRoutes.permissionDenied, arguments: 'camera');
      return;
    }
    // TODO: image_picker se front camera open karo
    selfieTaken.value = true;
  }

  Future<void> refreshLocation() async {
    if (!await _ensureLocation()) return;
    AppDialogs.loading('Location fetch ho rahi hai...');
    await Future.delayed(const Duration(milliseconds: 800));
    AppDialogs.hideLoading();
    AppDialogs.snack('Location updated', 'GPS location update ho gayi', type: SnackType.success);
  }

  Future<void> checkIn() async {
    if (!selfieTaken.value) return _needSelfie();
    if (!await _ensureLocation()) return;
    final ok = await AppDialogs.confirm(
      title: 'Check In?',
      message: 'Abhi ${fmtTime(DateTime.now())} par aapki attendance mark hogi.',
      confirmText: 'Check In',
      icon: Icons.login,
    );
    if (!ok) return;
    AppDialogs.loading('Attendance mark ho rahi hai...');
    await Future.delayed(const Duration(milliseconds: 900)); // API call yahan
    AppDialogs.hideLoading();

    checkedIn.value = true;
    checkInAt.value = DateTime.now();
    checkOutAt.value = null;
    worked.value = Duration.zero;
    selfieTaken.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      worked.value = DateTime.now().difference(checkInAt.value!);
    });
    AppDialogs.success('Checked In', 'Attendance ${fmtTime(checkInAt.value!)} par mark ho gayi.');
  }

  Future<void> checkOut() async {
    if (!selfieTaken.value) return _needSelfie();
    final ok = await AppDialogs.confirm(
      title: 'Check Out?',
      message: 'Aaj ke working hours: ${fmtHm(worked.value)}. Check-out karna hai?',
      confirmText: 'Check Out',
      icon: Icons.logout,
      color: AppColors.danger,
    );
    if (!ok) return;
    AppDialogs.loading('Check-out ho raha hai...');
    await Future.delayed(const Duration(milliseconds: 900)); // API call yahan
    AppDialogs.hideLoading();

    _timer?.cancel();
    checkedIn.value = false;
    checkOutAt.value = DateTime.now();
    selfieTaken.value = false;
    AppDialogs.success('Checked Out', 'Total working hours: ${fmtHm(worked.value)}');
  }

  void _needSelfie() => AppDialogs.snack('Selfie required', 'Pehle selfie lo, phir attendance mark karo', type: SnackType.warning);

  int get presentDays => history.where((r) => r.status == 'Present' || r.status == 'Late').length;
  int get absentDays => history.where((r) => r.status == 'Absent').length;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
