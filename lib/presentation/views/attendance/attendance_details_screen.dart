import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class AttendanceDetailsScreen extends GetView<AttendanceController> {
  const AttendanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceModel record = Get.arguments ??
        const AttendanceModel(
          date: '12 Apr 2025',
          checkIn: '09:15 AM',
          checkOut: '06:30 PM',
          workingHours: '9h 15m',
          status: 'Present',
          location: '28.6138, 77.2089',
        );

    Color? statusColor;
    String statusLabel;
    if (record.status == 'Present') {
      statusColor = AppColors.chipPresent;
      statusLabel = 'Present';
    } else if (record.status == 'Absent') {
      statusColor = AppColors.chipAbsent;
      statusLabel = 'Absent';
    } else if (record.status == 'Late') {
      statusColor = AppColors.chipAlert;
      statusLabel = 'Late';
    } else {
      statusColor = AppColors.alert;
      statusLabel = 'Alert';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(title: AppStrings.attendanceDetails, bgColor: statusColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xl),
          child: Column(
            children: [
              // Date + status card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radius20),
                  border: Border.all(color: statusColor.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56.r,
                      height: 56.r,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(AppSpacing.radius16),
                      ),
                      child: Icon(
                        Icons.event_available_rounded,
                        color: AppColors.white,
                        size: 28.r,
                      ),
                    ),
                    SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.date,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(FontAwesomeIcons.check, size: 12.r, color: statusColor),
                              SizedBox(width: 6.w),
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Details
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radius20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _detailRow(
                      AppStrings.checkIn,
                      record.checkIn,
                      FontAwesomeIcons.arrowRightToBracket,
                      AppColors.chipPresent,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _detailRow(
                      AppStrings.checkOut,
                      record.checkOut,
                      FontAwesomeIcons.arrowRightFromBracket,
                      AppColors.alert,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _detailRow(
                      AppStrings.workingHours,
                      record.workingHours,
                      FontAwesomeIcons.clock,
                      AppColors.primary,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _detailRow(
                      AppStrings.location,
                      record.location,
                      FontAwesomeIcons.locationDot,
                      AppColors.accentOrange,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _detailRow(
                      AppStrings.status,
                      statusLabel,
                      Icons.verified_user_outlined,
                      statusColor,
                      statusColor: statusColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              // Map placeholder
              Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radius20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFE8F4F0), Color(0xFFDDEBF5), Color(0xFFF2ECE3)],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 3),
                        ),
                        child: Icon(Icons.location_on, color: AppColors.white, size: 26.r),
                      ),
                    ),
                    Positioned(
                      right: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          record.location,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
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

  Widget _detailRow(String label, String value, IconData icon, Color iconColor,
      {Color? statusColor}) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.m),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radius12),
            ),
            child: Icon(icon, color: iconColor, size: 18.r),
          ),
          SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
