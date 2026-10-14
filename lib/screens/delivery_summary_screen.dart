import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class DeliverySummaryScreen extends StatelessWidget {
  const DeliverySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = Get.arguments as Delivery;
    final qty = d.deliveredQty ?? d.items.map((e) => e.qty).toList();
    final done = d.completedAt ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 56, color: AppColors.success),
                const SizedBox(height: 8),
                const Text('Delivery Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('${d.id} • ${fmtDate(done)}, ${fmtTime(done)}', style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
          AppCard(
            child: Column(
              children: [
                InfoRow(Icons.store_outlined, 'Customer', d.customer),
                InfoRow(Icons.person_outline, 'Received by', d.contact),
                InfoRow(Icons.location_on_outlined, 'Address', d.address),
              ],
            ),
          ),
          const SectionTitle('Items'),
          AppCard(
            child: Column(
              children: List.generate(d.items.length, (i) {
                final it = d.items[i];
                final diff = qty[i] - it.qty;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('Ordered ${it.qty} • Delivered ${qty[i]} ${it.unit}',
                                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      if (diff < 0) StatusChip('Short ${-diff}', AppColors.danger),
                      if (diff > 0) StatusChip('Excess $diff', AppColors.warning),
                      if (diff == 0) const StatusChip('Full', AppColors.success),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SectionTitle('Proof & Signature'),
          Row(
            children: [
              Expanded(
                child: _ProofTile(
                  icon: Icons.photo_camera_outlined,
                  label: 'Delivery photo',
                  onTap: () => Get.toNamed(AppRoutes.photoPreview, arguments: {'title': 'Delivery Proof'}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProofTile(
                  icon: Icons.draw_outlined,
                  label: 'Customer signature',
                  onTap: () => Get.toNamed(AppRoutes.photoPreview,
                      arguments: {'title': 'Customer Signature', 'strokes': d.signature}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                InfoRow(Icons.notes, 'Remarks', d.remarks.isEmpty ? 'No remarks' : d.remarks),
                const InfoRow(Icons.my_location, 'Delivery location', '18.5018° N, 73.8636° E'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProofTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProofTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 2),
          const Text('Tap to view', style: TextStyle(fontSize: 11, color: AppColors.muted)),
        ],
      ),
    );
  }
}
