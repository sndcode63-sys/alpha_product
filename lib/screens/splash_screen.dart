import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_routes.dart';
import '../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: token check karke seedha AppRoutes.main bhejo agar user logged in hai
    Future.delayed(const Duration(milliseconds: 2500), () => Get.offAllNamed(AppRoutes.login));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutBack,
                  builder: (_, v, child) => Opacity(
                    opacity: v.clamp(0.0, 1.0),
                    child: Transform.scale(scale: 0.85 + 0.15 * v, child: child),
                  ),
                  child: Image.asset('assets/images/logo_full.png', width: 280),
                ),
              ),
            ),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('Employee App', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('v1.0.0', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
