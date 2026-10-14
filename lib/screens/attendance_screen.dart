import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/attendance_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import 'attendance_history_screen.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() {
            final inn = controller.checkedIn.value;
            return AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  StatusChip(inn ? 'Checked In' : 'Not Checked In', inn ? AppColors.success : AppColors.warning),
                  const SizedBox(height: 14),
                  Text(
                    fmtClock(controller.worked.value),
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1),
                  ),
                  const Text('Working hours', style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _TimeBox('Check-in', controller.checkInAt.value),
                      const SizedBox(width: 12),
                      _TimeBox('Check-out', controller.checkOutAt.value),
                    ],
                  ),
                ],
              ),
            );
          }),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selfie', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 10),
                Obx(() => PhotoBox(
                      taken: controller.selfieTaken.value,
                      emptyLabel: 'Tap to take selfie',
                      takenLabel: 'Selfie captured',
                      icon: Icons.face_retouching_natural,
                      onTap: controller.captureSelfie,
                    )),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => InfoRow(Icons.location_on_outlined, 'GPS Location', controller.location.value)),
                    ),
                    IconButton(
                      onPressed: controller.refreshLocation,
                      icon: const Icon(Icons.my_location, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(() => ElevatedButton.icon(
                style: controller.checkedIn.value
                    ? ElevatedButton.styleFrom(backgroundColor: AppColors.danger)
                    : null,
                onPressed: controller.checkedIn.value ? controller.checkOut : controller.checkIn,
                icon: Icon(controller.checkedIn.value ? Icons.logout : Icons.login),
                label: Text(controller.checkedIn.value ? 'Check Out' : 'Check In'),
              )),
          SectionTitle('Recent Attendance', action: 'View all', onAction: () => Get.toNamed(AppRoutes.attendanceHistory)),
          Obx(() => Column(
                children: controller.history.take(3).map((r) => AttendanceTile(r)).toList(),
              )),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final DateTime? time;
  const _TimeBox(this.label, this.time);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 4),
            Text(time == null ? '--:--' : fmtTime(time!),
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}
