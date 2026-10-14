import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../core/app_dialogs.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  void _pickLanguage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Language', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ...controller.languages.map((l) => Obx(() => ListTile(
                  title: Text(l),
                  trailing: controller.language.value == l
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : const Icon(Icons.circle_outlined, color: AppColors.muted),
                  onTap: () {
                    controller.language.value = l;
                    Get.back();
                  },
                ))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle('Notifications'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Obx(() => Column(
                  children: [
                    SwitchListTile(
                      activeColor: AppColors.primary,
                      title: const Text('Delivery alerts'),
                      subtitle: const Text('Nayi delivery assign hone par'),
                      value: controller.deliveryAlerts.value,
                      onChanged: (v) => controller.deliveryAlerts.value = v,
                    ),
                    SwitchListTile(
                      activeColor: AppColors.primary,
                      title: const Text('Attendance reminder'),
                      subtitle: const Text('Check-in / check-out yaad dilane ke liye'),
                      value: controller.attendanceReminder.value,
                      onChanged: (v) => controller.attendanceReminder.value = v,
                    ),
                    SwitchListTile(
                      activeColor: AppColors.primary,
                      title: const Text('Sound'),
                      value: controller.sound.value,
                      onChanged: (v) => controller.sound.value = v,
                    ),
                  ],
                )),
          ),
          const SectionTitle('General'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Obx(() => ListTile(
                      leading: const Icon(Icons.language, color: AppColors.primary),
                      title: const Text('Language'),
                      subtitle: Text(controller.language.value),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _pickLanguage,
                    )),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined, color: AppColors.primary),
                  title: const Text('Clear cache'),
                  onTap: () async {
                    final ok = await AppDialogs.confirm(
                      title: 'Clear cache?',
                      message: 'Offline saved data delete ho jayega.',
                      confirmText: 'Clear',
                      icon: Icons.cleaning_services_outlined,
                    );
                    if (ok) AppDialogs.snack('Done', 'Cache clear ho gaya', type: SnackType.success);
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed(AppRoutes.legal, arguments: 'terms'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed(AppRoutes.legal, arguments: 'privacy'),
                ),
              ],
            ),
          ),
          // Sirf testing ke liye - release me ye section hata do
          const SectionTitle('Test screens (dev only)'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.wifi_off, color: AppColors.muted),
                  title: const Text('No Internet screen'),
                  onTap: () => Get.toNamed(AppRoutes.noInternet),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.location_off_outlined, color: AppColors.muted),
                  title: const Text('Permission Denied screen'),
                  onTap: () => Get.toNamed(AppRoutes.permissionDenied, arguments: 'location'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.system_update_outlined, color: AppColors.muted),
                  title: const Text('Update Required screen'),
                  onTap: () => Get.toNamed(AppRoutes.updateRequired),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
