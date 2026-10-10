import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? bgColor;
  final Color? fgColor;
  final Color? borderColor;
  final Widget? icon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
    this.borderRadius,
    this.bgColor,
    this.fgColor,
    this.borderColor,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.primary,
          foregroundColor: fgColor ?? AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radius12),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.2)
                : BorderSide.none,
          ),
          textStyle: TextStyle(
            fontSize: fontSize ?? 15.sp,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: fgColor ?? AppColors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, SizedBox(width: 8.w)],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class OutlinedAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? borderRadius;

  const OutlinedAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radius12),
          ),
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
