import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class CheckInScreen extends GetView<AttendanceController> {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: AppStrings.checkIn),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xl),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Obx(
                  () => controller.selfieCaptured.value
                      ? ClipOval(
                          child: Image.network(
                            'https://i.pravatar.cc/300?img=15',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(2.r),
                          child: ClipOval(
                            child: Image.network(
                              Get.find<DashboardController>().user['avatar']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: AppSpacing.l),
              Text(
                AppStrings.locationCaptured,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
              // GPS/Map placeholder
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
                    // Fake map pattern
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFE8F4F0),
                            const Color(0xFFDDEBF5),
                            const Color(0xFFF2ECE3),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _MapGridPainter(),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 72.r,
                        height: 72.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentGreen.withOpacity(0.15),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 56.r,
                          height: 56.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentGreen,
                            border: Border.all(color: AppColors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGreen.withOpacity(0.5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.white,
                            size: 28.r,
                          ),
                        ),
                      ),
                    ),
                    // Bottom floating label
                    Positioned(
                      left: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.radar, size: 14.r, color: AppColors.accentGreen),
                            SizedBox(width: 4.w),
                            Text(
                              'GPS Active',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.l),
              // Capture selfie button
              Obx(
                () => Container(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  decoration: BoxDecoration(
                    color: controller.selfieCaptured.value
                        ? AppColors.successBg
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radius12),
                    border: Border.all(
                      color: controller.selfieCaptured.value
                          ? AppColors.success
                          : AppColors.divider,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.radius12),
                      onTap: () {
                        controller.selfieCaptured.toggle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: controller.selfieCaptured.value
                                ? AppColors.success
                                : AppColors.primary,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.selfieCaptured.value ? 'Selfie Captured' : AppStrings.captureSelfie,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: controller.selfieCaptured.value
                                  ? AppColors.success
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxxl + 8.h),
              Obx(
                () => PrimaryButton(
                  text: AppStrings.checkIn,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.performCheckIn,
                  bgColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1;
    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.15, 0), Offset(size.width * 0.15, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
