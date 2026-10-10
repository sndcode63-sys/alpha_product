import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_routes.dart';

class MyProfileScreen extends GetView<DashboardController> {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: AppStrings.myProfile),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header card
              Container(
                width: double.infinity,
                color: AppColors.primary,
                padding: EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, 60.h),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: AppSpacing.avatarLg,
                          backgroundColor: AppColors.white,
                          backgroundImage: NetworkImage(controller.user['avatar']!),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 32.r,
                            height: 32.r,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.primary,
                              size: 16.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.m),
                    Text(
                      controller.user['name']!,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.badge, size: 12.r, color: AppColors.white),
                          SizedBox(width: 4.w),
                          Text(
                            controller.user['role']!,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Profile info card
              Transform.translate(
                offset: Offset(0, -40.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.l),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radius20),
                      border: Border.all(color: AppColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _infoRow(AppStrings.name, controller.user['name']!, FontAwesomeIcons.user,
                            AppColors.accentBlue),
                        const Divider(color: AppColors.divider, height: 1),
                        _infoRow(AppStrings.phone, controller.user['phone']!,
                            FontAwesomeIcons.phone, AppColors.accentGreen),
                        const Divider(color: AppColors.divider, height: 1),
                        _infoRow(AppStrings.email, controller.user['email']!,
                            FontAwesomeIcons.envelope, AppColors.accentOrange),
                        const Divider(color: AppColors.divider, height: 1),
                        _infoRow(AppStrings.role, controller.user['role']!, FontAwesomeIcons.userTie,
                            AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              // Menu actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radius20),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      _menuTile(
                        AppStrings.changePassword,
                        FontAwesomeIcons.key,
                        AppColors.accentPurple,
                        onTap: () => Get.toNamed(AppRoutes.changePassword),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _menuTile(AppStrings.settings, FontAwesomeIcons.gear, AppColors.accentBlue,
                          onTap: () {}),
                      const Divider(height: 1, color: AppColors.divider),
                      _menuTile(
                        AppStrings.logout,
                        FontAwesomeIcons.rightFromBracket,
                        AppColors.accentRed,
                        onTap: () {
                          _showLogoutDialog();
                        },
                        isLogout: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radius12),
            ),
            child: Icon(icon, color: color, size: 16.r),
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
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textHint, size: 20.r),
        ],
      ),
    );
  }

  Widget _menuTile(String title, IconData icon, Color color,
      {required VoidCallback onTap, bool isLogout = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 4.h),
      leading: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppSpacing.radius12),
        ),
        child: Icon(icon, color: color, size: 16.r),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: isLogout ? AppColors.alert : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textHint, size: 20.r),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radius24)),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: AppColors.alertBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: FaIcon(FontAwesomeIcons.rightFromBracket,
                    color: AppColors.alert, size: 26.sp),
              ),
              SizedBox(height: AppSpacing.l),
              Text(
                AppStrings.logoutConfirmTitle,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.logoutConfirmMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide(color: AppColors.divider, width: 1.2),
                        minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radius12),
                        ),
                      ),
                      child: const Text(AppStrings.cancel),
                    ),
                  ),
                  SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.find<AuthController>().logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.alert,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radius12),
                        ),
                      ),
                      child: const Text(AppStrings.logoutBtn),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
