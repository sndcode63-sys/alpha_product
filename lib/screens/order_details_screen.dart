import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import 'order_history_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final o = Get.arguments as Order;
    const steps = ['Placed', 'Confirmed', 'Dispatched', 'Delivered'];
    final current = steps.indexOf(o.status);

    return Scaffold(
      appBar: AppBar(title: Text(o.id)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(o.customer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                    StatusChip(o.status, orderColor(o.status)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(fmtDate(o.date), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      return Expanded(child: Container(height: 2, color: (i ~/ 2) < current ? AppColors.primary : AppColors.border));
                    }
                    final done = (i ~/ 2) <= current;
                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: done ? AppColors.primary : AppColors.border,
                      child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: steps.map((s) => Text(s, style: const TextStyle(fontSize: 10, color: AppColors.muted))).toList(),
                ),
              ],
            ),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 8),
                ...o.lines.map((l) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text('${l.qty} × ₹${l.price.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                          ),
                          Text('₹${l.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    )),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('₹${o.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
