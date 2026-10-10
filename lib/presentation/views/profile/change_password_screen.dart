import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_textfield.dart';
import '../../widgets/common/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class ChangePasswordScreen extends GetView<AuthController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: AppStrings.changePassword),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 84.r,
                  height: 84.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    color: AppColors.primary,
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Center(
                child: Text(
                  AppStrings.changePassword,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  'Update your password with secure credentials',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxxl + 8.h),
              Text(
                AppStrings.currentPassword,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.s),
              PasswordTextField(
                controller: controller.currentPwdCtrl,
                hint: AppStrings.enterCurrentPassword,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: AppSpacing.l),
              Text(
                AppStrings.newPassword,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.s),
              PasswordTextField(
                controller: controller.newPwdCtrl,
                hint: AppStrings.enterNewPassword,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: AppSpacing.l),
              Text(
                AppStrings.confirmPassword,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.s),
              PasswordTextField(
                controller: controller.confirmPwdCtrl,
                hint: AppStrings.reEnterNewPassword,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: AppSpacing.xxl),
              // Tips
              Container(
                padding: EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radius16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20.r, color: AppColors.primary),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Password should be at least 8 characters long with a mix of letters, numbers, and symbols.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primaryDark,
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
                  text: AppStrings.update,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
