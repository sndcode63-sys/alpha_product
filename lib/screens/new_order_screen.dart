import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';
import '../core/app_dialogs.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final products = MockData.products();
  late final RxList<int> qty = List<int>.filled(products.length, 0).obs;
  final Delivery? d = Get.arguments is Delivery ? Get.arguments as Delivery : null;

  int get totalItems => qty.fold(0, (a, b) => a + b);
  double get totalAmount {
    double t = 0;
    for (var i = 0; i < products.length; i++) {
      t += products[i].price * qty[i];
    }
    return t;
  }

  Future<void> _submit() async {
    if (totalItems == 0) {
      AppDialogs.warning('Koi product nahi', 'Kam se kam ek product select karo.');
      return;
    }
    final ok = await AppDialogs.confirm(
      title: 'Place order?',
      message: '$totalItems items • ₹${totalAmount.toStringAsFixed(0)} ka order create hoga.',
      confirmText: 'Place Order',
      icon: Icons.shopping_cart_checkout,
    );
    if (!ok) return;
    AppDialogs.loading('Order place ho raha hai...');
    await Future.delayed(const Duration(seconds: 1)); // API call yahan
    AppDialogs.hideLoading();
    Get.find<OrderController>().add(d?.customer ?? 'Walk-in Customer', [
      for (var i = 0; i < products.length; i++)
        if (qty[i] > 0) OrderLine(products[i].name, qty[i], products[i].price),
    ]);
    Get.back();
    AppDialogs.success('Order placed', '$totalItems items ka order create ho gaya.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Order')),
      body: Column(
        children: [
          if (d != null)
            Container(
              width: double.infinity,
              color: AppColors.primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.store_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(d!.customer, style: const TextStyle(fontWeight: FontWeight.w700))),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];
                return Obx(() => AppCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text('${p.sku} • ₹${p.price.toStringAsFixed(0)} / ${p.unit}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: qty[i] > 0 ? () => qty[i] = qty[i] - 1 : null,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 28,
                            child: Text('${qty[i]}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ),
                          IconButton(
                            onPressed: () => qty[i] = qty[i] + 1,
                            icon: const Icon(Icons.add_circle),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$totalItems items', style: const TextStyle(color: AppColors.muted)),
                        Text('₹${totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    )),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _submit, child: const Text('Place Order')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
