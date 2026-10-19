import 'package:alpha_field_app/imports.dart';

class TripListScreen extends GetView<TripController> {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = controller.trip.value;
      final total = controller.stops.length;
      final next = controller.nextStop;
      return AppScaffold(
        title: 'Trip ${t?.id ?? ''}',
        chip: 'DRIVER ROLE',
        nav: true,
        showBack: false,
        footer: next == null ? PrimaryButton('End Trip', () { controller.odo.clear(); Get.toNamed(Routes.endTrip); }) : PrimaryButton('Navigate to next stop', () => Get.toNamed(Routes.routeMap)),
        children: [
          Text('${t?.vehicle ?? ''} · $total stops', style: const TextStyle(color: AppColors.muted)),
          InfoCard('', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${controller.resolved} of $total stops done', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: total == 0 ? 0 : controller.resolved / total, color: AppColors.teal, backgroundColor: AppColors.line, minHeight: 8, borderRadius: BorderRadius.circular(99)),
          ])),
          for (final s in controller.stops)
            RowCard('${s.seq}. ${s.customer}', sub: '${s.items} items · ${switch (s.status) { 'delivered' => 'Delivered', 'failed' => 'Failed', _ => s.id == next?.id ? 'Next' : 'Pending' }}', trailing: s.id == next?.id ? 'Next ›' : '', selected: s.id == next?.id, onTap: () => controller.openStop(s)),
        ],
      );
    });
  }
}
