import 'package:alpha_field_app/imports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo Box
            Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/app_icon.png',
                errorBuilder: (_, __, ___) => const Center(
                  child: Text('A', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: AppColors.teal)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text('Alpha Field App', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            const SizedBox(height: 6),

            // Subtitle
            const Text('Sales visits · Deliveries · Attendance', style: TextStyle(color: Color(0xFFE3F2FD), fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),

            // Progress Indicator
            SizedBox(
              width: 140,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1800),
                onEnd: () {
                  final a = Get.find<AuthController>();
                  final att = Get.find<AttendanceController>();
                  if (a.user.value == null) {
                    Get.offAllNamed(Routes.login);
                  } else if (!att.checkedIn) {
                    Get.offAllNamed(Routes.attendance);
                    AppToast.show('Pehle attendance check-in karein');
                  } else {
                    Get.offAllNamed(a.homeRoute);
                  }
                },
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  color: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
