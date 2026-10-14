import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

enum SnackType { success, error, warning, info }

/// Saare alerts / dialogs / popups yahin se call hote hain.
class AppDialogs {
  // ---------- Snackbar (top pop message) ----------
  static void snack(String title, String message, {SnackType type = SnackType.info}) {
    final (color, icon) = switch (type) {
      SnackType.success => (AppColors.success, Icons.check_circle),
      SnackType.error => (AppColors.danger, Icons.error),
      SnackType.warning => (AppColors.warning, Icons.warning_amber_rounded),
      SnackType.info => (AppColors.primary, Icons.info),
    };
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: color),
      backgroundColor: Colors.white,
      colorText: AppColors.text,
      borderColor: color,
      borderWidth: 1.2,
      borderRadius: 14,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // ---------- Confirm dialog (Yes / Cancel) ----------
  static Future<bool> confirm({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    IconData icon = Icons.help_outline,
    Color color = AppColors.primary,
  }) async {
    final r = await Get.dialog<bool>(
      _DialogBase(
        icon: icon,
        color: color,
        title: title,
        message: message,
        actions: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46)),
              onPressed: () => Get.back(result: false),
              child: Text(cancelText),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 46), backgroundColor: color),
              onPressed: () => Get.back(result: true),
              child: Text(confirmText),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return r ?? false;
  }

  // ---------- Success dialog ----------
  static Future<void> success(String title, String message, {String button = 'OK'}) =>
      _single(Icons.check_circle, AppColors.success, title, message, button);

  // ---------- Warning / error dialog ----------
  static Future<void> warning(String title, String message, {String button = 'OK'}) =>
      _single(Icons.warning_amber_rounded, AppColors.warning, title, message, button);

  static Future<void> error(String title, String message, {String button = 'Close'}) =>
      _single(Icons.error_outline, AppColors.danger, title, message, button);

  static Future<void> _single(IconData icon, Color color, String title, String message, String button) async {
    await Get.dialog(
      _DialogBase(
        icon: icon,
        color: color,
        title: title,
        message: message,
        actions: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 46), backgroundColor: color),
              onPressed: () => Get.back(),
              child: Text(button),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ---------- Permission dialog ----------
  static Future<bool> permission({required String title, required String message, IconData icon = Icons.location_on}) =>
      confirm(title: title, message: message, confirmText: 'Allow', cancelText: 'Deny', icon: icon);

  // ---------- Loading dialog ----------
  static void loading([String message = 'Please wait...']) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                Text(message,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text, decoration: TextDecoration.none)),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  // ---------- Photo source bottom sheet ----------
  /// Returns 'camera' / 'gallery' / null. image_picker yahin se connect karna.
  static Future<String?> photoSource() {
    return Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 16),
            const Text('Photo select karo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: const Text('Camera'),
              onTap: () => Get.back(result: 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: const Text('Gallery'),
              onTap: () => Get.back(result: 'gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogBase extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final List<Widget> actions;

  const _DialogBase({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.4)),
            const SizedBox(height: 20),
            Row(children: actions),
          ],
        ),
      ),
    );
  }
}
