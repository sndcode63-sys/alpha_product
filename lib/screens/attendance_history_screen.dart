import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/attendance_controller.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class AttendanceHistoryScreen extends GetView<AttendanceController> {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  StatTile(Icons.check_circle_outline, '${controller.presentDays}', 'Present'),
                  const SizedBox(width: 10),
                  StatTile(Icons.cancel_outlined, '${controller.absentDays}', 'Absent'),
                  const SizedBox(width: 10),
                  StatTile(Icons.timer_outlined, fmtHm(controller.history.fold(Duration.zero, (a, b) => a + b.worked)), 'Total hours'),
                ],
              ),
              const SizedBox(height: 16),
              ...controller.history.map((r) => AttendanceTile(r)),
            ],
          )),
    );
  }
}

class AttendanceTile extends StatelessWidget {
  final AttendanceRecord r;
  const AttendanceTile(this.r, {super.key});

  Color get _color => switch (r.status) {
        'Present' => AppColors.success,
        'Late' || 'Half Day' => AppColors.warning,
        _ => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(two(r.date.day),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                Text(fmtDate(r.date).substring(3, 6), style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${r.checkIn}  →  ${r.checkOut}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Working hours: ${fmtHm(r.worked)}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          StatusChip(r.status, _color),
        ],
      ),
    );
  }
}
