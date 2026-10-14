import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vehicle_controller.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class DeliveryRouteScreen extends StatelessWidget {
  const DeliveryRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = Get.arguments as Delivery;
    final v = Get.find<VehicleController>();
    final eta = (d.distanceKm * 3).round(); // dummy ETA

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Route')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const MapPlaceholder(height: 260),
          const SizedBox(height: 12),
          Row(
            children: [
              StatTile(Icons.route_outlined, '${d.distanceKm} km', 'Distance'),
              const SizedBox(width: 10),
              StatTile(Icons.timer_outlined, '$eta min', 'Est. time'),
              const SizedBox(width: 10),
              StatTile(Icons.local_shipping_outlined, v.vehicleNo.split(' ').last, 'Vehicle'),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                _Stop(Icons.circle, AppColors.success, 'Start', 'Alpha Warehouse, Hadapsar', true),
                _Stop(Icons.location_on, AppColors.danger, d.customer, d.address, false),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {}, // TODO: Google Maps intent / url_launcher
            icon: const Icon(Icons.navigation_outlined),
            label: const Text('Start Navigation'),
          ),
        ],
      ),
    );
  }
}

class _Stop extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  final bool line;
  const _Stop(this.icon, this.color, this.title, this.sub, this.line);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, color: color, size: 20),
              if (line) Expanded(child: Container(width: 2, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: line ? 18 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(sub, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
