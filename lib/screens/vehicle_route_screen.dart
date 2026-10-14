import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/delivery_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

/// Vehicle ka aaj ka poora route - saari delivery stops ke saath.
class VehicleRouteScreen extends StatelessWidget {
  const VehicleRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final del = Get.find<DeliveryController>();
    final veh = Get.find<VehicleController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Today's Route")),
      body: Obx(() {
        del.version.value;
        final stops = del.deliveries.toList();
        final totalKm = stops.fold<double>(0, (a, b) => a + b.distanceKm);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const MapPlaceholder(height: 240),
            const SizedBox(height: 12),
            Row(
              children: [
                StatTile(Icons.pin_drop_outlined, '${stops.length}', 'Stops'),
                const SizedBox(width: 10),
                StatTile(Icons.route_outlined, totalKm.toStringAsFixed(1), 'Total km'),
                const SizedBox(width: 10),
                StatTile(Icons.local_shipping_outlined, veh.vehicleNo.split(' ').last, 'Vehicle'),
              ],
            ),
            const SectionTitle('Stops'),
            AppCard(
              child: Column(
                children: [
                  const _Stop('S', 'Alpha Warehouse', 'Starting point', AppColors.success, null),
                  ...List.generate(stops.length, (i) {
                    final s = stops[i];
                    return _Stop('${i + 1}', s.customer, s.address, s.status.color, s.status.label);
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Stop extends StatelessWidget {
  final String badge;
  final String title;
  final String sub;
  final Color color;
  final String? status;
  const _Stop(this.badge, this.title, this.sub, this.color, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color,
            child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          if (status != null) StatusChip(status!, color),
        ],
      ),
    );
  }
}
