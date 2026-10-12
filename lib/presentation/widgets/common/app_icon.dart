import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      child: SvgPicture.asset(
        'assets/images/app_icon.svg',
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
