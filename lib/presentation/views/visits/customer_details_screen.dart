import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/visit_controller.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class CustomerDetailsScreen extends GetView<VisitController> {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller.selected.value ?? controller.customers.first;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'Customer Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.m),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radius16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52.r,
                            height: 52.r,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radius12),
                            ),
                            child: Icon(Icons.storefront,
                                color: AppColors.primary, size: 26.sp),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  c.cityLabel,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.m),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radius16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          _row(Icons.person, 'Contact Person', c.contactPerson),
                          _div(),
                          _row(Icons.phone, 'Phone', c.phone),
                          _div(),
                          _row(Icons.place, 'Address', c.address),
                          _div(),
                          _row(Icons.email, 'Email', c.email),
                          _div(),
                          _row(Icons.my_location, 'GPS Location', c.gps),
                          _div(),
                          _row(Icons.receipt_long, 'GST Number', c.gst),
                          _div(),
                          _row(Icons.badge, 'Assigned Salesperson',
                              c.salesperson),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.m),
              child: PrimaryButton(
                text: 'Start Visit',
                onPressed: controller.openStartVisit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _div() => const Divider(height: 1, color: AppColors.divider);

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
