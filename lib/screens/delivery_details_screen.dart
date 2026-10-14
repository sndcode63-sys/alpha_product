import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/delivery_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = Get.arguments as Delivery;
    final c = Get.find<DeliveryController>();

    return Scaffold(
      appBar: AppBar(title: Text(d.id)),
      body: Obx(() {
        c.version.value;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Customer Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            StatusChip(d.status.label, d.status.color),
                          ],
                        ),
                        const SizedBox(height: 8),
                        InfoRow(Icons.store_outlined, 'Customer', d.customer),
                        InfoRow(Icons.person_outline, 'Contact person', d.contact),
                        InfoRow(Icons.phone_outlined, 'Mobile', d.phone),
                        InfoRow(Icons.location_on_outlined, 'Address', d.address),
                        InfoRow(Icons.schedule, 'Delivery slot', d.slot),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                                onPressed: () {},
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Call'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                                onPressed: () => Get.toNamed(AppRoutes.deliveryRoute, arguments: d),
                                icon: const Icon(Icons.directions, size: 18),
                                label: const Text('Route'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Products to Deliver', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 10),
                        ...d.items.map((it) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.inventory_2_outlined, size: 18, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(it.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                  Text('${it.qty} ${it.unit}',
                                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                                ],
                              ),
                            )),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total quantity', style: TextStyle(color: AppColors.muted)),
                            Text('${d.totalQty}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: d.status == DeliveryStatus.pending
                    ? ElevatedButton.icon(
                        onPressed: () => c.startTrip(d),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Start Delivery Trip'),
                      )
                    : d.status == DeliveryStatus.inTransit
                        ? ElevatedButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.deliveryComplete, arguments: d),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Mark as Delivered'),
                          )
                        : ElevatedButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.deliverySummary, arguments: d),
                            icon: const Icon(Icons.receipt_long_outlined),
                            label: const Text('View Delivery Summary'),
                          ),
              ),
          ],
        );
      }),
    );
  }
}
