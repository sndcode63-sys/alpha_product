import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final id = TextEditingController();

  Future<void> _send() async {
    if (id.text.trim().isEmpty) {
      AppDialogs.snack('Required', 'Employee ID ya mobile number daalo', type: SnackType.warning);
      return;
    }
    AppDialogs.loading('Reset link bhej rahe hain...');
    await Future.delayed(const Duration(seconds: 1)); // API call yahan
    AppDialogs.hideLoading();
    await AppDialogs.success('Link sent', 'Aapke registered mobile number par password reset ka link bhej diya gaya hai.');
    Get.back();
  }

  @override
  void dispose() {
    id.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.lock_reset, size: 44, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Password reset karo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Apna Employee ID ya registered mobile number daalo.', style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 24),
            TextField(
              controller: id,
              decoration: const InputDecoration(labelText: 'Employee ID / Mobile', prefixIcon: Icon(Icons.badge_outlined)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _send, child: const Text('Send Reset Link')),
          ],
        ),
      ),
    );
  }
}
