import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vehicle_controller.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

class TripHistoryScreen extends GetView<VehicleController> {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip History')),
      body: Obx(() {
        final trips = controller.trips;
        final km = trips.fold<double>(0, (a, b) => a + b.km);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                StatTile(Icons.local_shipping_outlined, '${trips.length}', 'Trips'),
                const SizedBox(width: 10),
                StatTile(Icons.route_outlined, km.toStringAsFixed(1), 'Total km'),
                const SizedBox(width: 10),
                StatTile(Icons.inventory_2_outlined, '${trips.fold<int>(0, (a, b) => a + b.deliveries)}', 'Deliveries'),
              ],
            ),
            const SizedBox(height: 16),
            ...trips.map((t) => AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t.id, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                          Text(fmtDate(t.date), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${t.start}  →  ${t.end}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Divider(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _M(Icons.route_outlined, '${t.km.toStringAsFixed(1)} km'),
                          _M(Icons.timer_outlined, fmtHm(t.duration)),
                          _M(Icons.inventory_2_outlined, '${t.deliveries} deliveries'),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}

class _M extends StatelessWidget {
  final IconData icon;
  final String text;
  const _M(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      );
}
