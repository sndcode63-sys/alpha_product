import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/delivery_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class DeliveryListScreen extends GetView<DeliveryController> {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Deliveries')),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.only(bottom: 14),
            child: SizedBox(
              height: 38,
              child:ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final t = controller.tabs[i];
                      final sel = controller.filter.value == t;
                      return GestureDetector(
                        onTap: () => controller.filter.value = t,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: sel ? Colors.white : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(t,
                              style: TextStyle(
                                  color: sel ? AppColors.primary : Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
            ),
          ),
          Expanded(
            child: Obx(() {
              controller.version.value;
              final list = controller.filtered;
              if (list.isEmpty) {
                return const Center(child: Text('Koi delivery nahi mili', style: TextStyle(color: AppColors.muted)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, i) => DeliveryCard(list[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DeliveryCard extends StatelessWidget {
  final Delivery d;
  const DeliveryCard(this.d, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Get.toNamed(AppRoutes.deliveryDetails, arguments: d),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(d.id, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
              StatusChip(d.status.label, d.status.color),
            ],
          ),
          const SizedBox(height: 8),
          Text(d.customer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.muted),
              const SizedBox(width: 4),
              Expanded(child: Text(d.address, style: const TextStyle(fontSize: 13, color: AppColors.muted))),
            ],
          ),
          const Divider(height: 22),
          Row(
            children: [
              _Meta(Icons.schedule, d.slot),
              const Spacer(),
              _Meta(Icons.inventory_2_outlined, '${d.totalQty} units'),
              const Spacer(),
              _Meta(Icons.route_outlined, '${d.distanceKm} km'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text)),
      ],
    );
  }
}
