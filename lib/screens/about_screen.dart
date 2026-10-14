import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About App')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          Center(child: Image.asset('assets/images/logo_full.png', width: 240)),
          const SizedBox(height: 12),
          const Center(child: Text('Version 1.0.0 (1)', style: TextStyle(color: AppColors.muted))),
          const SizedBox(height: 24),
          const AppCard(
            child: Text(
              'Alpha Products Employee App: attendance, delivery aur vehicle tracking ek hi jagah.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
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
          const SizedBox(height: 8),
          const Center(child: Text('© Alpha Products. All rights reserved.', style: TextStyle(fontSize: 12, color: AppColors.muted))),
        ],
      ),
    );
  }
}
