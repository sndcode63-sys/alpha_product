import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/delivery_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class VehicleScreen extends GetView<VehicleController> {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final del = Get.find<DeliveryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() => Stack(
                children: [
                  const MapPlaceholder(height: 220, showRoute: false),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(controller.currentLocation.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                Text('Updated ${fmtTime(controller.lastUpdated.value)}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Assigned Vehicle', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    Obx(() => StatusChip(controller.tripActive.value ? 'On Trip' : 'Idle',
                        controller.tripActive.value ? AppColors.success : AppColors.warning)),
                  ],
                ),
                const SizedBox(height: 8),
                InfoRow(Icons.local_shipping_outlined, 'Vehicle number', controller.vehicleNo),
                InfoRow(Icons.directions_car_outlined, 'Type / Capacity', '${controller.vehicleType} • ${controller.capacity}'),
                InfoRow(Icons.person_outline, 'Driver', '${controller.driverName} • ${controller.driverPhone}'),
              ],
            ),
          ),
          Obx(() => Row(
                children: [
                  StatTile(Icons.route_outlined, controller.distance.value.toStringAsFixed(1), 'Km travelled'),
                  const SizedBox(width: 10),
                  StatTile(Icons.timer_outlined,
                      controller.tripActive.value ? fmtHm(controller.tripDuration) : '0h 00m', 'Trip time'),
                  const SizedBox(width: 10),
                  StatTile(
                    Icons.inventory_2_outlined,
                    () {
                      del.version.value;
                      return '${del.count(DeliveryStatus.completed)}/${del.deliveries.length}';
                    }(),
                    'Delivered',
                  ),
                ],
              )),
          const SizedBox(height: 16),
          Obx(() => controller.tripActive.value
              ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                  onPressed: controller.endTrip,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('End Trip'),
                )
              : ElevatedButton.icon(
                  onPressed: controller.startTrip,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Trip'),
                )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => Get.toNamed(AppRoutes.vehicleRoute),
                  icon: const Icon(Icons.alt_route),
                  label: const Text('Route', style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => Get.toNamed(AppRoutes.locationHistory),
                  icon: const Icon(Icons.place_outlined),
                  label: const Text('Locations', style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => Get.toNamed(AppRoutes.tripHistory),
                  icon: const Icon(Icons.history),
                  label: const Text('Trips', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
          const SectionTitle('Delivery Status'),
          Obx(() {
            del.version.value;
            return Column(
              children: del.deliveries
                  .map((d) => AppCard(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        onTap: () => Get.toNamed(AppRoutes.deliveryDetails, arguments: d),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.customer, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text('${d.id} • ${d.distanceKm} km', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                            ),
                            StatusChip(d.status.label, d.status.color),
                          ],
                        ),
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}
