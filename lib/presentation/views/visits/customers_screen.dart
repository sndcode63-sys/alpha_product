import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/visit_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class CustomersScreen extends GetView<VisitController> {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'My Assigned Customers'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.m, AppSpacing.m, AppSpacing.m, AppSpacing.s),
              child: TextField(
                onChanged: controller.onSearch,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle:
                      TextStyle(fontSize: 14.sp, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search,
                      size: 20.sp, color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final list = controller.filtered;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No customers found',
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.all(AppSpacing.m),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) => _customerTile(list[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerTile(CustomerModel c) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radius16),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius16),
        onTap: () => controller.openDetails(c),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radius16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radius12),
                ),
                child: Icon(Icons.storefront,
                    color: AppColors.primary, size: 22.sp),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      c.cityLabel,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: AppColors.textHint, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}
