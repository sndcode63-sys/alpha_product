import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_theme.dart';
import '../data/models.dart';
import '../core/widgets.dart';
import 'attendance_controller.dart';
import 'delivery_controller.dart';

class VehicleController extends GetxController {
  // Dummy assignment — replace with API.
  final vehicleNo = 'MH 12 AB 4821';
  final vehicleType = 'Tata Ace (Mini Truck)';
  final capacity = '750 kg';
  final driverName = 'Rakesh Kumar';
  final driverPhone = '+91 98765 43210';

  final tripActive = false.obs;
  final tripStart = Rxn<DateTime>();
  final distance = 0.0.obs;
  final currentLocation = 'Alpha Warehouse, Hadapsar, Pune'.obs;
  final lastUpdated = DateTime.now().obs;
  final history = <LocationPoint>[].obs;
  final trips = <Trip>[].obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    trips.assignAll(MockData.trips());
    final now = DateTime.now();
    history.assignAll([
      LocationPoint(now.subtract(const Duration(hours: 26)), 'Trip ended - Alpha Warehouse', 58.2),
      LocationPoint(now.subtract(const Duration(hours: 28)), 'Krishna Departmental, Camp', 41.0),
      LocationPoint(now.subtract(const Duration(hours: 30)), 'Trip started - Alpha Warehouse', 0),
    ]);
  }

  Future<void> startTrip() async {
    if (!Get.find<AttendanceController>().checkedIn.value) {
      await AppDialogs.warning('Check-in required', 'Trip shuru karne se pehle attendance check-in karo.');
      return;
    }
    final ok = await AppDialogs.confirm(
      title: 'Start trip?',
      message: '$vehicleNo ki trip shuru karni hai?',
      confirmText: 'Start Trip',
      icon: Icons.play_circle_outline,
    );
    if (!ok) return;
    tripActive.value = true;
    tripStart.value = DateTime.now();
    distance.value = 0;
    currentLocation.value = 'On route from Alpha Warehouse';
    history.insert(0, LocationPoint(DateTime.now(), 'Trip started - Alpha Warehouse', 0));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      distance.value += 0.15; // GPS se real distance calculate karo
      lastUpdated.value = DateTime.now();
    });
  }

  Future<void> endTrip() async {
    final ok = await AppDialogs.confirm(
      title: 'End trip?',
      message: 'Ab tak ${distance.value.toStringAsFixed(1)} km chala. Trip end karni hai?',
      confirmText: 'End Trip',
      icon: Icons.stop_circle_outlined,
      color: AppColors.danger,
    );
    if (!ok) return;
    final start = tripStart.value ?? DateTime.now();
    final end = DateTime.now();
    trips.insert(
      0,
      Trip('TRP-${(trips.length + 32).toString().padLeft(4, '0')}', end, fmtTime(start), fmtTime(end), distance.value,
          Get.find<DeliveryController>().count(DeliveryStatus.completed), end.difference(start)),
    );
    _timer?.cancel();
    tripActive.value = false;
    currentLocation.value = 'Alpha Warehouse, Hadapsar, Pune';
    history.insert(0, LocationPoint(DateTime.now(), 'Trip ended - Alpha Warehouse', distance.value));
    AppDialogs.success('Trip ended', 'Total distance: ${distance.value.toStringAsFixed(1)} km');
  }

  Duration get tripDuration =>
      tripStart.value == null ? Duration.zero : DateTime.now().difference(tripStart.value!);

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
