import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../controllers/auth_controller.dart';
import 'attendance/attendance_module_screen.dart';
import 'delivery/delivery_module_screen.dart';
import 'vehicle/vehicle_module_screen.dart';
import 'customer/customer_module_screen.dart';
import 'product/product_module_screen.dart';
import '../../core/theme/app_colors.dart';

class MainTabScreen extends GetView<MainTabController> {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainTabController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alpha Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: const [
          AttendanceModuleScreen(),
          DeliveryModuleScreen(),
          VehicleModuleScreen(),
          CustomerModuleScreen(),
          ProductModuleScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                MainTabController.tabTitles.length,
                (index) => _buildTabItem(index),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildTabItem(int index) {
    final isSelected = controller.currentIndex.value == index;
    final iconData = _getIconData(index);

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: isSelected ? AppColors.primary : AppColors.textHint,
              size: 24.r,
            ),
            SizedBox(height: 4.h),
            Text(
              MainTabController.tabTitles[index],
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.calendar_today_outlined;
      case 1:
        return Icons.local_shipping_outlined;
      case 2:
        return Icons.directions_car_outlined;
      case 3:
        return Icons.people_outline;
      case 4:
        return Icons.inventory_2_outlined;
      default:
        return Icons.home_outlined;
    }
  }
}
