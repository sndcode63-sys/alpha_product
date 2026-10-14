import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/app_dialogs.dart';
import '../core/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final old = TextEditingController();
  final nw = TextEditingController();
  final confirm = TextEditingController();
  bool hide = true;

  Future<void> _save() async {
    if (old.text.isEmpty || nw.text.isEmpty || confirm.text.isEmpty) {
      return AppDialogs.snack('Required', 'Saari fields bharo', type: SnackType.warning);
    }
    if (nw.text.length < 6) {
      return AppDialogs.snack('Weak password', 'Naya password kam se kam 6 character ka ho', type: SnackType.warning);
    }
    if (nw.text != confirm.text) {
      return AppDialogs.snack('Mismatch', 'Naya password aur confirm password same nahi hai', type: SnackType.error);
    }
    if (nw.text == old.text) {
      return AppDialogs.snack('Same password', 'Naya password purane se alag hona chahiye', type: SnackType.warning);
    }
    AppDialogs.loading('Password change ho raha hai...');
    await Future.delayed(const Duration(seconds: 1)); // API call yahan
    AppDialogs.hideLoading();
    if (!Get.find<AuthController>().changePassword(old.text, nw.text)) {
      return AppDialogs.error('Failed', 'Current password galat hai.');
    }
    Get.back();
    AppDialogs.success('Password changed', 'Aapka password change ho gaya.');
  }

  Widget _field(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: c,
          obscureText: hide,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => hide = !hide),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    old.dispose();
    nw.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Strong password rakho: kam se kam 6 character.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 20),
          _field(old, 'Current password'),
          _field(nw, 'New password'),
          _field(confirm, 'Confirm new password'),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: _save, child: const Text('Update Password')),
        ],
      ),
    );
  }
}
