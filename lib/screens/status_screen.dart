import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_theme.dart';

class _StatusView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String primary;
  final VoidCallback onPrimary;
  final String? secondary;
  final VoidCallback? onSecondary;

  const _StatusView({
    required this.icon,
    required this.title,
    required this.message,
    required this.primary,
    required this.onPrimary,
    this.secondary,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: Icon(icon, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 28),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, height: 1.5)),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: onPrimary, child: Text(primary)),
              if (secondary != null) ...[
                const SizedBox(height: 12),
                OutlinedButton(onPressed: onSecondary, child: Text(secondary!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _StatusView(
      icon: Icons.wifi_off_rounded,
      title: 'Internet nahi hai',
      message: 'Apna internet connection check karo aur dobara try karo. Offline data safe hai.',
      primary: 'Retry',
      onPrimary: () async {
        AppDialogs.loading('Connection check ho raha hai...');
        await Future.delayed(const Duration(seconds: 1)); // connectivity_plus se check karo
        AppDialogs.hideLoading();
        Get.back();
      },
      secondary: 'Go back',
      onSecondary: Get.back,
    );
  }
}

class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final what = Get.arguments == 'camera' ? 'Camera' : 'Location';
    return _StatusView(
      icon: what == 'Camera' ? Icons.no_photography_outlined : Icons.location_off_outlined,
      title: '$what permission chahiye',
      message: 'Is feature ke liye $what access zaroori hai. Phone Settings me jaakar app ko permission do.',
      primary: 'Open Settings',
      onPrimary: () => AppDialogs.snack('Settings', 'Phone settings khul rahi hai...'), // permission_handler: openAppSettings()
      secondary: 'Go back',
      onSecondary: Get.back,
    );
  }
}

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: _StatusView(
        icon: Icons.system_update_outlined,
        title: 'Update zaroori hai',
        message: 'App ka naya version available hai. Continue karne ke liye app update karo.',
        primary: 'Update Now',
        onPrimary: () => AppDialogs.snack('Update', 'Play Store / App Store khul raha hai...'),
        secondary: 'Dev: close',
        onSecondary: Get.back,
      ),
    );
  }
}
