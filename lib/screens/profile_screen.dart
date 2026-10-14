import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class ProfileScreen extends GetView<AuthController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Obx(() => Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(controller.name.value[0],
                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ),
                    const SizedBox(height: 12),
                    Text(controller.name.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    StatusChip(controller.role, controller.currentRole.value.color),
                    const SizedBox(height: 20),
                  ],
                )),
          ),
          Obx(() => AppCard(
                child: Column(
                  children: [
                    InfoRow(Icons.badge_outlined, 'Employee ID', controller.employeeCode.value),
                    InfoRow(Icons.phone_outlined, 'Mobile', controller.mobile.value),
                    InfoRow(Icons.email_outlined, 'Email', controller.email.value),
                  ],
                ),
              )),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Tile(Icons.edit_outlined, 'Edit Profile', AppRoutes.editProfile),
                _Tile(Icons.lock_outline, 'Change Password', AppRoutes.changePassword),
                _Tile(Icons.receipt_long_outlined, 'My Orders', AppRoutes.orderHistory),
                _Tile(Icons.local_shipping_outlined, 'Trip History', AppRoutes.tripHistory),
                _Tile(Icons.history, 'Attendance History', AppRoutes.attendanceHistory),
                _Tile(Icons.settings_outlined, 'Settings', AppRoutes.settings),
                _Tile(Icons.help_outline, 'Help & Support', AppRoutes.help),
                _Tile(Icons.info_outline, 'About App', AppRoutes.about, last: true),
              ],
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool last;
  const _Tile(this.icon, this.title, this.route, {this.last = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
          onTap: () => Get.toNamed(route),
        ),
        if (!last) const Divider(height: 1, indent: 56),
      ],
    );
  }
}
