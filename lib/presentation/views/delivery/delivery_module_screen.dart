import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/app_icon.dart';
import '../../controllers/delivery_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../data/models/delivery.dart';

class DeliveryModuleScreen extends GetView<DeliveryController> {
  const DeliveryModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DeliveryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Management'),
        leading: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: AppIcon(size: 32.r),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsRow(),
              SizedBox(height: 20.h),
              _buildDeliveriesList(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeliveryDialog(context),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: AppColors.white, size: 24.r),
      ),
    );
  }

  Widget _buildStatsRow() {
    final deliveries = controller.deliveryList;
    final total = deliveries.length;
    final pending = deliveries.where((d) => d.status == 'pending').length;
    final completed = deliveries.where((d) => d.status == 'delivered').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Total', total.toString(), AppColors.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard('Pending', pending.toString(), AppColors.accentOrange),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard('Completed', completed.toString(), AppColors.success),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveriesList() {
    if (controller.deliveryList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No deliveries yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deliveries',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...controller.deliveryList.map((delivery) {
          return _buildDeliveryCard(
            delivery.deliveryNumber,
            'Customer ${delivery.customerId}',
            delivery.address,
            delivery.status,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDeliveryCard(
    String id,
    String customer,
    String address,
    String status,
  ) {
    Color statusColor;
    switch (status) {
      case 'pending':
        statusColor = AppColors.accentOrange;
        break;
      case 'in_progress':
        statusColor = AppColors.accentBlue;
        break;
      case 'delivered':
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.textHint;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            customer,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16.r, color: AppColors.textHint),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (status == 'pending')
            ElevatedButton(
              onPressed: () => controller.startDelivery(
                controller.deliveryList.firstWhere((d) => d.deliveryNumber == id),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 40.h),
              ),
              child: Text(
                'Start Delivery',
                style: TextStyle(fontSize: 14.sp, color: AppColors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddDeliveryDialog(BuildContext context) {
    final addressCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Delivery'),
        content: TextField(
          controller: addressCtrl,
          decoration: const InputDecoration(
            labelText: 'Delivery Address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressCtrl.text.isNotEmpty) {
                final delivery = Delivery(
                  deliveryNumber: 'DLV-${DateTime.now().millisecondsSinceEpoch}',
                  customerId: 1,
                  userId: Get.find<AuthController>().currentUser.value!.id!,
                  status: 'pending',
                  address: addressCtrl.text,
                  assignedDate: DateTime.now().toIso8601String(),
                );
                controller.createDelivery(delivery);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
