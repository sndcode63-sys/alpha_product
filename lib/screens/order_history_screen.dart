import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

Color orderColor(String s) => switch (s) {
      'Delivered' => AppColors.success,
      'Dispatched' => AppColors.primary,
      'Confirmed' => AppColors.warning,
      _ => AppColors.muted,
    };

class OrderHistoryScreen extends GetView<OrderController> {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return const Center(child: Text('Abhi koi order nahi hai', style: TextStyle(color: AppColors.muted)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (_, i) {
            final o = controller.orders[i];
            return AppCard(
              onTap: () => Get.toNamed(AppRoutes.orderDetails, arguments: o),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(o.id, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
                      StatusChip(o.status, orderColor(o.status)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(o.customer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${fmtDate(o.date)} • ${o.totalQty} items', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  const Divider(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('₹${o.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
