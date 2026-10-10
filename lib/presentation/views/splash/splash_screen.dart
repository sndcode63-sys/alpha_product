import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';
import '../../widgets/common/app_icon.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background decorations
                Positioned(
                  top: -100.r,
                  left: -100.r,
                  child: _decorationCircle(200.r, AppColors.white.withOpacity(0.05)),
                ),
                Positioned(
                  top: 100.r,
                  right: -80.r,
                  child: _decorationCircle(150.r, AppColors.white.withOpacity(0.03)),
                ),
                Positioned(
                  bottom: -80.r,
                  left: 80.r,
                  child: _decorationCircle(180.r, AppColors.white.withOpacity(0.04)),
                ),
                // Center content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(size: 120.r, withShadow: true),
                    SizedBox(height: 40.h),
                    Text(
                      AppStrings.fieldForce,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppStrings.workSmarter,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 8,
                      ),
                    ),
                  ],
                ),
                // Bottom loader
                Positioned(
                  bottom: 80.h,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40.r,
                        height: 40.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.white,
                          backgroundColor: AppColors.white.withOpacity(0.2),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _decorationCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
