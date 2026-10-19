import 'package:alpha_field_app/imports.dart';

class CustomerDetailScreen extends GetView<CustomerController> {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller.selected.value;
      if (c == null) return const AppScaffold(title: 'Customer', children: [EmptyHint('No customer selected')]);
      final rows = controller.tabRows;
      return AppScaffold(
        title: c.name,
        children: [
          Text('${c.category} · ${c.territory}', style: const TextStyle(color: AppColors.muted)),
          InfoCard(c.contactPerson, sub: c.phone),
          InfoCard(c.address, sub: c.gst.isEmpty ? 'GST not added' : 'GST ${c.gst}'),
          RowCard('Outstanding', sub: c.lastVisit.isEmpty ? 'No previous visit' : 'Last visit ${c.lastVisit}', trailing: money(c.outstanding)),
          FilterChips(const ['Orders', 'Visits', 'Deliveries'], controller.tab.value, (v) => controller.tab.value = v),
          if (rows.isEmpty) const EmptyHint('Nothing here yet'),
          for (final r in rows) RowCard(r[0], sub: r[1], trailing: r[2]),
          Row(children: [
            Expanded(child: PrimaryButton('Navigate', () => openMaps(c.lat, c.lng))),
            const SizedBox(width: 8),
            Expanded(child: PrimaryButton('Call', () => callNumber(c.phone), ghost: true)),
          ]),
          PrimaryButton('New order', () {
            Get.find<OrderController>().forCustomer(c);
            Get.toNamed(Routes.orderCreate);
          }, ghost: true),
        ],
      );
    });
  }
}
