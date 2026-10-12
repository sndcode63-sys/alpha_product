import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/visit_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class StartVisitScreen extends GetView<VisitController> {
  const StartVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller.selected.value ?? controller.customers.first;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'Start Visit'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFE9F1EC),
                      child: CustomPaint(painter: _RouteMapPainter()),
                    ),
                  ),
                  // Destination pin
                  Align(
                    alignment: const Alignment(0.45, -0.35),
                    child: Icon(Icons.location_on,
                        color: AppColors.accentRed, size: 44.sp),
                  ),
                  // Current location dot
                  Align(
                    alignment: const Alignment(-0.45, 0.45),
                    child: Container(
                      width: 20.r,
                      height: 20.r,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentBlue.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radius24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radius12),
                        ),
                        child: Icon(Icons.storefront,
                            color: AppColors.primary, size: 20.sp),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              c.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.m),
                  PrimaryButton(
                    text: 'Start Visit',
                    onPressed: controller.openVisitCheckIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.2, 0),
        Offset(size.width * 0.2, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.62),
        Offset(size.width, size.height * 0.62), road);
    canvas.drawLine(Offset(size.width * 0.72, 0),
        Offset(size.width * 0.72, size.height), road);

    // Route from current location to destination
    final route = Paint()
      ..color = AppColors.accentBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.275, size.height * 0.72)
      ..lineTo(size.width * 0.275, size.height * 0.62)
      ..lineTo(size.width * 0.72, size.height * 0.62)
      ..lineTo(size.width * 0.72, size.height * 0.33);
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
