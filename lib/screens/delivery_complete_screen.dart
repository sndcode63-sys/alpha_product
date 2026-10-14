import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/delivery_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import 'signature_screen.dart';

class DeliveryCompleteScreen extends StatefulWidget {
  const DeliveryCompleteScreen({super.key});

  @override
  State<DeliveryCompleteScreen> createState() => _DeliveryCompleteScreenState();
}

class _DeliveryCompleteScreenState extends State<DeliveryCompleteScreen> {
  late final Delivery d;
  late final CompleteController c;

  @override
  void initState() {
    super.initState();
    d = Get.arguments as Delivery;
    c = Get.put(CompleteController(d), tag: d.id);
  }

  @override
  void dispose() {
    Get.delete<CompleteController>(tag: d.id);
    super.dispose();
  }

  Future<void> _sign() async {
    final result = await Get.toNamed(AppRoutes.signature, arguments: c.strokes.toList());
    if (result is List<List<Offset>>) c.strokes.assignAll(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Delivery')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.store_outlined, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.customer, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(d.id, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SectionTitle('Delivered Quantity'),
                ...List.generate(d.items.length, (i) {
                  final it = d.items[i];
                  return Obx(() {
                    final diff = c.diff(i);
                    return AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Ordered: ${it.qty} ${it.unit}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _Stepper(Icons.remove, () => c.dec(i)),
                              Container(
                                width: 64,
                                alignment: Alignment.center,
                                child: Text('${c.qty[i]}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                              ),
                              _Stepper(Icons.add, () => c.inc(i)),
                              const Spacer(),
                              if (diff < 0) StatusChip('Short ${-diff}', AppColors.danger),
                              if (diff > 0) StatusChip('Excess $diff', AppColors.warning),
                              if (diff == 0) const StatusChip('Full', AppColors.success),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                }),
                const SectionTitle('Delivery Proof'),
                AppCard(
                  child: Obx(() => PhotoBox(
                        taken: c.proofTaken.value,
                        emptyLabel: 'Upload delivery photo',
                        takenLabel: 'Proof photo added',
                        onTap: c.captureProof,
                      )),
                ),
                const SectionTitle('Customer Signature'),
                AppCard(
                  child: Obx(() => c.strokes.isEmpty
                      ? OutlinedButton.icon(
                          onPressed: _sign,
                          icon: const Icon(Icons.draw_outlined),
                          label: const Text('Take signature'),
                        )
                      : Column(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: CustomPaint(painter: SignaturePainter(c.strokes.toList(), fit: true)),
                            ),
                            TextButton.icon(
                              onPressed: _sign,
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('Re-sign'),
                            ),
                          ],
                        )),
                ),
                const SectionTitle('Remarks & Location'),
                AppCard(
                  child: Column(
                    children: [
                      TextField(
                        controller: c.remarks,
                        maxLines: 3,
                        decoration: const InputDecoration(hintText: 'Delivery remarks (optional)'),
                      ),
                      const SizedBox(height: 8),
                      InfoRow(Icons.my_location, 'GPS', c.location),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.newOrder, arguments: d),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Take New Order'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: ElevatedButton(onPressed: c.submit, child: const Text('Submit Delivery')),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Stepper(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
