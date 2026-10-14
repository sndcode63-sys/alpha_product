import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_theme.dart';
import '../data/models.dart';
import 'attendance_controller.dart';

class DeliveryController extends GetxController {
  final deliveries = <Delivery>[].obs;
  final version = 0.obs; // UI refresh tick
  final filter = 'All'.obs;
  final tabs = const ['All', 'Pending', 'In Transit', 'Completed'];

  @override
  void onInit() {
    super.onInit();
    deliveries.assignAll(MockData.deliveries());
  }

  List<Delivery> get filtered =>
      filter.value == 'All' ? deliveries.toList() : deliveries.where((d) => d.status.label == filter.value).toList();

  int count(DeliveryStatus s) => deliveries.where((d) => d.status == s).length;

  Future<void> startTrip(Delivery d) async {
    if (!Get.find<AttendanceController>().checkedIn.value) {
      await AppDialogs.warning('Check-in required', 'Delivery shuru karne se pehle attendance check-in karo.');
      return;
    }
    final ok = await AppDialogs.confirm(
      title: 'Start delivery trip?',
      message: '${d.customer} ki delivery shuru karni hai?',
      confirmText: 'Start',
      icon: Icons.play_circle_outline,
    );
    if (!ok) return;
    d.status = DeliveryStatus.inTransit;
    deliveries.refresh();
    version.value++;
    AppDialogs.snack('Trip started', '${d.customer} ki delivery start ho gayi', type: SnackType.success);
  }

  void markCompleted(Delivery d, {List<int>? qty, String remarks = '', List<List<Offset>>? signature}) {
    d.status = DeliveryStatus.completed;
    d.deliveredQty = qty ?? d.items.map((e) => e.qty).toList();
    d.remarks = remarks;
    d.completedAt = DateTime.now();
    d.proofPhoto = true;
    d.signature = signature ?? [];
    deliveries.refresh();
    version.value++;
  }
}

/// Per-delivery completion form state.
class CompleteController extends GetxController {
  final Delivery delivery;
  CompleteController(this.delivery);

  late final RxList<int> qty = delivery.items.map((e) => e.qty).toList().obs;
  final proofTaken = false.obs;
  final strokes = <List<Offset>>[].obs;
  final remarks = TextEditingController();
  final location = 'Delivery location captured: 18.5018° N, 73.8636° E';

  void inc(int i) => qty[i] = qty[i] + 1;
  void dec(int i) {
    if (qty[i] > 0) qty[i] = qty[i] - 1;
  }

  int diff(int i) => qty[i] - delivery.items[i].qty;

  Future<void> captureProof() async {
    final src = await AppDialogs.photoSource();
    if (src == null) return;
    // TODO: image_picker se src ('camera'/'gallery') ke hisaab se photo lo
    proofTaken.value = true;
  }

  Future<void> submit() async {
    if (!proofTaken.value) {
      return AppDialogs.warning('Proof required', 'Delivery proof photo upload karo.');
    }
    if (strokes.isEmpty) {
      return AppDialogs.warning('Signature required', 'Customer ka signature lo.');
    }

    final short = List.generate(qty.length, (i) => diff(i)).where((x) => x < 0).length;
    final excess = List.generate(qty.length, (i) => diff(i)).where((x) => x > 0).length;
    if (short > 0 || excess > 0) {
      final go = await AppDialogs.confirm(
        title: 'Quantity mismatch',
        message: '${short > 0 ? '$short item short' : ''}${short > 0 && excess > 0 ? ' aur ' : ''}${excess > 0 ? '$excess item excess' : ''} hai. Phir bhi submit karna hai?',
        confirmText: 'Submit',
        icon: Icons.warning_amber_rounded,
        color: AppColors.warning,
      );
      if (!go) return;
    } else {
      final go = await AppDialogs.confirm(
        title: 'Submit delivery?',
        message: '${delivery.id} ko completed mark kar diya jayega.',
        confirmText: 'Submit',
        icon: Icons.check_circle_outline,
      );
      if (!go) return;
    }

    AppDialogs.loading('Delivery submit ho rahi hai...');
    await Future.delayed(const Duration(seconds: 1)); // API call yahan
    AppDialogs.hideLoading();

    Get.find<DeliveryController>().markCompleted(
      delivery,
      qty: qty.toList(),
      remarks: remarks.text.trim(),
      signature: strokes.map((e) => List<Offset>.from(e)).toList(),
    );
    Get.until((r) => r.settings.name == '/main');
    AppDialogs.success('Delivery completed', '${delivery.id} successfully submit ho gayi.');
  }

  @override
  void onClose() {
    remarks.dispose();
    super.onClose();
  }
}
