import 'package:alpha_field_app/imports.dart';

class StopDetailScreen extends GetView<TripController> {
  const StopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s = controller.stop.value;
      if (s == null) return const AppScaffold(title: 'Stop', children: [EmptyHint('No stop selected')]);
      final pending = s.status == 'pending';
      return AppScaffold(
        title: s.customer,
        chip: 'DRIVER ROLE',
        footer: Column(mainAxisSize: MainAxisSize.min, children: [
          if (pending) PrimaryButton('Arrived', controller.arrive),
          const SizedBox(height: 8),
          PrimaryButton('Navigate', () => openMaps(s.lat, s.lng), ghost: true),
        ]),
        children: [
          Text('Stop ${s.seq} of ${controller.stops.length} · ${s.address}', style: const TextStyle(color: AppColors.muted)),
          InfoCard(s.customer, sub: s.phone, onTap: () => callNumber(s.phone)),
          RowCard('Items to deliver', sub: s.status == 'delivered' ? 'Delivered ${s.delivered}' : '', trailing: '${s.items}'),
          InfoCard('Instructions', sub: s.instructions),
          if (s.reason.isNotEmpty) InfoCard('Note', sub: s.reason),
          PrimaryButton('+ New order for this customer', () {
            final c = Get.find<CustomerController>().all.firstWhereOrNull((c) => c.name == s.customer);
            Get.find<OrderController>().forCustomer(c);
            Get.toNamed(Routes.orderCreate);
          }, ghost: true),
        ],
      );
    });
  }
}
