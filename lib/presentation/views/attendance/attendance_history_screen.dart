import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class AttendanceHistoryScreen extends GetView<AttendanceController> {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: AppStrings.attendanceHistory),
      body: SafeArea(
        child: Column(
          children: [
            // Top Summary bar
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, AppSpacing.m),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radius16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    _summaryTile('24', 'Present', AppColors.chipPresent),
                    _vDivider(),
                    _summaryTile('4', 'Absent', AppColors.chipAbsent),
                    _vDivider(),
                    _summaryTile('2', 'Late', AppColors.chipAlert),
                  ],
                ),
              ),
            ),
            // Filter chips
            SizedBox(
              height: 36.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => SizedBox(width: AppSpacing.s),
                itemBuilder: (_, i) {
                  final filters = ['Today', 'This Week', 'This Month', 'Year'];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
                    decoration: BoxDecoration(
                      color: i == 1 ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: i == 1 ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filters[i],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: i == 1 ? AppColors.white : AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.l),
            // Header row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppStrings.date,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Check In / Out',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppStrings.duration,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            // List
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
                  itemCount: controller.historyList.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final item = controller.historyList[i];
                    Color? statusColor;
                    String statusLabel;
                    if (item.status == 'Present') {
                      statusColor = AppColors.chipPresent;
                      statusLabel = 'Present';
                    } else if (item.status == 'Absent') {
                      statusColor = AppColors.chipAbsent;
                      statusLabel = 'Absent';
                    } else if (item.status == 'Late') {
                      statusColor = AppColors.chipAlert;
                      statusLabel = 'Late';
                    } else {
                      statusColor = AppColors.alert;
                      statusLabel = 'Alert';
                    }
                    return GestureDetector(
                      onTap: () => controller.goDetails(item),
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radius16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.date,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.s, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          item.status == 'Absent'
                                              ? Icons.close
                                              : Icons.check,
                                          size: 9.sp,
                                          color: statusColor,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          statusLabel,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.login, size: 12.r, color: AppColors.chipPresent),
                                      SizedBox(width: 4.w),
                                      Text(
                                        item.checkIn,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.logout, size: 12.r, color: AppColors.alert),
                                      SizedBox(width: 4.w),
                                      Text(
                                        item.checkOut,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.workingHours,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12.r,
                                    color: AppColors.textHint,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(String count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      width: 1.w,
      height: 32.h,
      color: AppColors.divider,
    );
  }
}
