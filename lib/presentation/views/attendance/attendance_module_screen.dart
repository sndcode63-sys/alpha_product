import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../widgets/common/app_icon.dart';
import '../../controllers/attendance_controller.dart';

class AttendanceModuleScreen extends GetView<AttendanceController> {
  const AttendanceModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AttendanceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
        leading: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: AppIcon(size: 32.r),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildAttendanceCard()),
            SizedBox(height: 16.h),
            Obx(() => _buildQuickActions()),
            SizedBox(height: 16.h),
            Obx(() => _buildAttendanceHistory()),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard() {
    final attendance = controller.todayAttendance.value;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Status',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            attendance?.status.toUpperCase() ?? 'NOT CHECKED IN',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildInfoItem(
                'Check In',
                attendance != null ? controller.formatTime(attendance.checkInTime) : '--:--',
              ),
              SizedBox(width: 32.w),
              _buildInfoItem(
                'Check Out',
                attendance != null ? controller.formatTime(attendance.checkOutTime) : '--:--',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.7),
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final attendance = controller.todayAttendance.value;
    final canCheckIn = attendance == null;
    final canCheckOut = attendance != null && attendance.checkOutTime == null;

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.login,
            label: 'Check In',
            color: canCheckIn ? AppColors.success : AppColors.textHint,
            onTap: canCheckIn ? () => controller.performCheckIn() : null,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            icon: Icons.logout,
            label: 'Check Out',
            color: canCheckOut ? AppColors.alert : AppColors.textHint,
            onTap: canCheckOut ? () => controller.performCheckOut() : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceHistory() {
    if (controller.historyList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No attendance history yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...controller.historyList.take(5).map((attendance) {
          final checkIn = controller.formatTime(attendance.checkInTime);
          final checkOut = controller.formatTime(attendance.checkOutTime);
          final time = '$checkIn - $checkOut';
          return _buildHistoryItem(
            controller.formatDate(attendance.date),
            attendance.status,
            time,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(String date, String status, String time) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'present':
        statusColor = AppColors.success;
        break;
      case 'late':
        statusColor = AppColors.accentOrange;
        break;
      case 'absent':
        statusColor = AppColors.alert;
        break;
      default:
        statusColor = AppColors.textHint;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
