import 'package:alpha_field_app/imports.dart';

class OrderReviewScreen extends GetView<OrderController> {
  const OrderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller.customer.value;
      return AppScaffold(
        title: 'Review Order',
        footer: Column(mainAxisSize: MainAxisSize.min, children: [
          PrimaryButton('Submit Order', controller.submit),
          const SizedBox(height: 8),
          PrimaryButton('Edit items', Get.back, ghost: true),
        ]),
        children: [
          InfoCard(c?.name ?? '', sub: 'Delivery: ${c?.address ?? ''}'),
          for (final p in controller.lines)
            RowCard('${p.name} × ${controller.cart[p.sku]}', sub: '${money(p.price)} each', trailing: money(p.price * controller.cart[p.sku]!)),
          RowCard('Subtotal', trailing: money(controller.subtotal)),
          RowCard('GST 12%', trailing: money(controller.gst)),
          RowCard('Total', trailing: money(controller.total), selected: true),
          LabeledField('Notes', controller: controller.notes, hint: 'Optional'),
        ],
      );
    });
  }
}
