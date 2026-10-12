import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class AttendanceDashboardScreen extends GetView<AttendanceController> {
  const AttendanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: AppStrings.attendanceDashboard),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's attendance card
              Text(
                AppStrings.todayAttendance,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radius20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.checkInLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Obx(
                                () => Text(
                                  controller.checkInTime.value,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.accentGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 40.h,
                          color: AppColors.divider,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.checkOutLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Obx(
                                () => Text(
                                  controller.checkOutTime.value,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.l),
                    // Animated Present badge
                    Container(
                      width: 120.r,
                      height: 120.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGreenLight,
                        border: Border.all(color: AppColors.accentGreen.withOpacity(0.2), width: 10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGreen.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48.r,
                            height: 48.r,
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.white,
                              size: 26.r,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            AppStrings.present,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.l),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radius16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Chip(
                              label: Text(
                                'Total Working Hours',
                                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                              ),
                              side: BorderSide.none,
                              backgroundColor: Colors.transparent,
                              visualDensity: VisualDensity.compact,
                            ),
                            Text(
                              controller.workingHours.value,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              // Action row
              Row(
                children: [
                  Expanded(
                    child: _actionTile(
                      AppStrings.checkIn,
                      Icons.login,
                      AppColors.primary,
                      controller.goCheckIn,
                    ),
                  ),
                  SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: _actionTile(
                      AppStrings.checkOut,
                      Icons.logout,
                      AppColors.accentRed,
                      controller.goCheckOut,
                    ),
                  ),
                  SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: _actionTile(
                      AppStrings.history,
                      Icons.history,
                      AppColors.accentOrange,
                      controller.goHistory,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxl),
              // Weekly summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.thisWeek,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    AppStrings.seeMore,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.m),
              Container(
                padding: EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radius20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dayTile('M', AppColors.chipPresent, true),
                    _dayTile('T', AppColors.chipPresent, true),
                    _dayTile('W', AppColors.chipPresent, true),
                    _dayTile('T', AppColors.chipAbsent, false),
                    _dayTile('F', AppColors.chipAlert, true),
                    _dayTile('S', AppColors.chipPresent, true),
                    _dayTile('S', AppColors.divider, false, isToday: false, disabled: true),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.l, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radius16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.r),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayTile(String day, Color color, bool present, {bool isToday = false, bool disabled = false}) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: disabled ? AppColors.background : color.withOpacity(0.15),
            border: Border.all(
              color: disabled ? AppColors.divider : color,
              width: isToday ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: disabled
              ? null
              : Icon(
                  present ? Icons.check : Icons.close,
                  size: 16.r,
                  color: color,
                ),
        ),
      ],
    );
  }
}
