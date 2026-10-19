import 'package:alpha_field_app/imports.dart';

class OrderCreateScreen extends GetView<OrderController> {
  const OrderCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.forCustomer(null);
    return Obx(() {
      final n = controller.itemCount;
      return AppScaffold(
        title: 'New Order',
        nav: true,
        footer: PrimaryButton('$n items · ${money(controller.subtotal)} — Review', n == 0 ? null : controller.review),
        children: [
          DropdownButtonFormField<String>(
            value: controller.customer.value?.id,
            decoration: const InputDecoration(labelText: 'Customer'),
            items: [for (final c in controller.allCustomers) DropdownMenuItem(value: c.id, child: Text(c.name))],
            onChanged: (id) => controller.customer.value = controller.allCustomers.firstWhere((c) => c.id == id),
          ),
          LabeledField('', hint: 'Search product or SKU', onChanged: (v) => controller.query.value = v),
          for (final p in controller.visible)
            InfoCard('', child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('SKU ${p.sku} · ${money(p.price)}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ])),
              IconButton(onPressed: () => controller.change(p.sku, -1), icon: const Icon(Icons.remove_circle_outline)),
              Text('${controller.cart[p.sku] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              IconButton(onPressed: () => controller.change(p.sku, 1), icon: const Icon(Icons.add_circle_outline, color: AppColors.teal)),
            ])),
        ],
      );
    });
  }
}
