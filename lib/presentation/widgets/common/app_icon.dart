import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class AppIcon extends StatelessWidget {
  final double? size;
  final bool withShadow;

  const AppIcon({
    super.key,
    this.size,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 80.r;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            AppColors.primaryLight,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Container(
          width: iconSize * 0.85,
          height: iconSize * 0.85,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'AP',
              style: TextStyle(
                fontSize: iconSize * 0.35,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
