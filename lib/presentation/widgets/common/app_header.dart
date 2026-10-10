import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Color? bgColor;
  final Color? fgColor;
  final Widget? titleWidget;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.bgColor,
    this.fgColor,
    this.titleWidget,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? AppColors.primary,
      foregroundColor: fgColor ?? AppColors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      title: titleWidget ??
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: fgColor ?? AppColors.white,
            ),
          ),
      actions: actions,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 20.r),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PrimaryHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? bgColor;
  final Color? fgColor;
  final bool showBack;
  final VoidCallback? onBack;

  const PrimaryHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.bgColor,
    this.fgColor,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: bgColor ?? AppColors.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
        child: Row(
          children: [
            if (showBack)
              GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: fgColor ?? AppColors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            SizedBox(width: AppSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: fgColor ?? AppColors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: (fgColor ?? AppColors.white).withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppSpacing.toolbarHeight + 60.h);
}
