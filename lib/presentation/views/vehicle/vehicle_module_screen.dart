import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/app_icon.dart';
import '../../controllers/vehicle_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../data/models/vehicle.dart';

class VehicleModuleScreen extends GetView<VehicleController> {
  const VehicleModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VehicleController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Tracking'),
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
              if (controller.vehicleList.isNotEmpty) _buildVehicleItemDetail(controller.vehicleList.first),
              SizedBox(height: 20.h),
              _buildVehicleList(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVehicleDialog(context),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: AppColors.white, size: 24.r),
      ),
    );
  }

  Widget _buildVehicleItemDetail(Vehicle vehicle) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: AppColors.white, size: 32.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.plateNumber,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vehicle.model,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.8),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.white, size: 20.r),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    vehicle.currentLat != null && vehicle.currentLng != null
                        ? 'Location: ${vehicle.currentLat!.toStringAsFixed(4)}, ${vehicle.currentLng!.toStringAsFixed(4)}'
                        : 'Location not available',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleList() {
    if (controller.vehicleList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No vehicles added yet',
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
          'All Vehicles',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...controller.vehicleList.map((vehicle) {
          return _buildVehicleListItem(
            vehicle,
            vehicle.status,
            _getStatusColor(vehicle.status),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildVehicleListItem(Vehicle vehicle, String status, Color statusColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.directions_car, color: AppColors.primary, size: 24.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.plateNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  vehicle.model,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'idle':
        return AppColors.accentOrange;
      case 'maintenance':
        return AppColors.alert;
      default:
        return AppColors.textHint;
    }
  }

  void _showAddVehicleDialog(BuildContext context) {
    final plateCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Vehicle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: plateCtrl,
              decoration: const InputDecoration(
                labelText: 'Plate Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: modelCtrl,
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (plateCtrl.text.isNotEmpty && modelCtrl.text.isNotEmpty) {
                final vehicle = Vehicle(
                  plateNumber: plateCtrl.text,
                  model: modelCtrl.text,
                  type: 'Van',
                  status: 'active',
                  fuelLevel: 100,
                  lastUpdated: DateTime.now().toIso8601String(),
                );
                controller.addVehicle(vehicle);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
