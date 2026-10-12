import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/visit_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class VisitCheckInScreen extends GetView<VisitController> {
  const VisitCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller.selected.value ?? controller.customers.first;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'Visit Check-in'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.l, vertical: AppSpacing.xl),
          child: Column(
            children: [
              Text(
                'Customer Visit',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                c.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGreen.withOpacity(0.12),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 78.r,
                  height: 78.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentGreen,
                    border: Border.all(color: AppColors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGreen.withOpacity(0.45),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Icon(Icons.location_on,
                      color: AppColors.white, size: 34.sp),
                ),
              ),
              SizedBox(height: AppSpacing.l),
              Text(
                'GPS Captured',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                c.gps,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Obx(() {
                final done = controller.selfieCaptured.value;
                return Container(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  decoration: BoxDecoration(
                    color: done ? AppColors.successBg : AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radius12),
                    border: Border.all(
                        color: done ? AppColors.success : AppColors.divider),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.radius12),
                      onTap: controller.toggleSelfie,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            done ? Icons.check_circle : Icons.camera_alt,
                            size: 18.sp,
                            color: done ? AppColors.success : AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            done ? 'Selfie Captured' : AppStrings.captureSelfie,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: done
                                  ? AppColors.success
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: AppSpacing.xxl),
              Obx(
                () => PrimaryButton(
                  text: 'Next',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.completeCheckIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
