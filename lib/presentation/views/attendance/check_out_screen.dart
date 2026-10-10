import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class CheckOutScreen extends GetView<AttendanceController> {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: AppStrings.checkOut),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xl),
          child: Column(
            children: [
              // CheckOut icon
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successBg,
                  border: Border.all(color: AppColors.success.withOpacity(0.3), width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.white,
                    size: 30.r,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.l),
              Text(
                AppStrings.checkOut,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  controller.location.value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              // Check Out time
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radius24),
                  border: Border.all(color: AppColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Obx(
                      () => Text(
                        controller.checkOutTime.value,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.l),
                    const Divider(color: AppColors.divider),
                    SizedBox(height: AppSpacing.l),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, color: AppColors.success, size: 22.r),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Total Working Hours',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.workingHours.value,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              // Tips
              Container(
                padding: EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radius16),
                  border: Border.all(color: AppColors.success.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(FontAwesomeIcons.circleCheck,
                        color: AppColors.success, size: 18.sp),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Thank you for your hard work today! Please confirm your check-out.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.success,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxxl + 8.h),
              Obx(
                () => PrimaryButton(
                  text: AppStrings.checkOut,
                  isLoading: controller.isLoading.value,
                  bgColor: AppColors.success,
                  onPressed: controller.performCheckOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
