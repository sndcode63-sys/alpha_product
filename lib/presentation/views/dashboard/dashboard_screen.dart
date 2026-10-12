import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/attendance_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Top blue header
            Container(
              height: 210.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
            ),
            Column(
              children: [
                // Greeting
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: AppSpacing.avatarMd,
                        backgroundColor: AppColors.white,
                        backgroundImage: NetworkImage(
                          controller.user['avatar']!,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2.w),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.goodMorning,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Icon(Icons.badge, size: 14.r, color: AppColors.white.withOpacity(0.8)),
                                SizedBox(width: 4.w),
                                Text(
                                  AppStrings.supervisor,
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.85),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.navigateToProfile,
                        child: Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_outline, color: AppColors.white, size: 20.r),
                        ),
                      ),
                    ],
                  ),
                ),
                // Card with stats (mini)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radius16),
                    ),
                    child: Row(
                      children: [
                        _miniStat('Today', '4 Visits', AppColors.accentGreen, Icons.groups),
                        Container(width: 1.w, height: 36.h, color: AppColors.white.withOpacity(0.2)),
                        _miniStat('Pending', '8 Tasks', AppColors.accentOrange, Icons.checklist),
                        Container(width: 1.w, height: 36.h, color: AppColors.white.withOpacity(0.2)),
                        _miniStat('Orders', '₹12.3k', AppColors.accentBlue, Icons.shopping_cart),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),
                // Grid menu
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.l),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radius24)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.m),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: AppSpacing.m,
                            crossAxisSpacing: AppSpacing.m,
                            childAspectRatio: 0.98,
                            children: [
                              _menuCard(AppStrings.attendance, Icons.event_available,
                                  AppColors.accentGreen, controller.navigateToAttendance),
                              _menuCard(AppStrings.visits, Icons.place,
                                  AppColors.accentOrange, controller.navigateToVisits),
                              _menuCard(AppStrings.orders, Icons.receipt_long,
                                  AppColors.accentRed, () => controller.comingSoon(AppStrings.orders)),
                              _menuCard(AppStrings.expenses, Icons.monetization_on,
                                  AppColors.accentGreen, () => controller.comingSoon(AppStrings.expenses)),
                              _menuCard(AppStrings.customers, Icons.people,
                                  AppColors.accentBlue, controller.navigateToVisits),
                              _menuCard(AppStrings.profile, Icons.person,
                                  AppColors.primary, controller.navigateToProfile),
                            ],
                          ),
                          SizedBox(height: AppSpacing.xl),
                          // Recent Activity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Activity',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.m),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(AppSpacing.radius16),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              children: [
                                _activityItem(AppStrings.attendance, 'Checked in at 09:15 AM',
                                    Icons.event_available, AppColors.accentGreen),
                                const Divider(height: 1, color: AppColors.divider),
                                _activityItem('Visits', 'Visited Kumar Stores',
                                    Icons.place, AppColors.accentOrange),
                                const Divider(height: 1, color: AppColors.divider),
                                _activityItem('Orders', 'New order received (₹4,500)',
                                    Icons.receipt_long, AppColors.accentBlue),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radius20)),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_outlined, Icons.home, AppStrings.home),
            _navItem(1, Icons.assignment_outlined, Icons.assignment, AppStrings.tasks),
            _buildFab(),
            _navItem(2, Icons.chat_outlined, Icons.chat, AppStrings.chat),
            _navItem(3, Icons.person_outline, Icons.person, AppStrings.profile,
                onTap: controller.navigateToProfile),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label,
      {VoidCallback? onTap}) {
    final selected = controller.currentIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: onTap ?? () => controller.onTapIndex(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? AppColors.primary : AppColors.textHint,
              size: 22.r,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return SizedBox(
      width: 56.r,
      height: 56.r,
      child: FloatingActionButton(
        elevation: 4,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
          side: BorderSide(color: AppColors.white, width: 3.w),
        ),
        onPressed: () => Get.find<AttendanceController>().goCheckIn(),
        child: Icon(Icons.navigation, color: AppColors.white, size: 22.sp),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color accent, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.white, size: 16.sp),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radius16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radius16),
              ),
              child: Icon(icon, color: color, size: 24.r),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(String title, String desc, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.m),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radius12),
            ),
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
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
}
