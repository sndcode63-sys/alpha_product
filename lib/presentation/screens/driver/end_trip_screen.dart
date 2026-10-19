import 'package:alpha_field_app/imports.dart';

class EndTripScreen extends GetView<TripController> {
  const EndTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = controller.trip.value;
      final failed = controller.failedCount;
      return AppScaffold(
        title: 'End Trip',
        chip: 'DRIVER ROLE',
        footer: PrimaryButton('End Trip', controller.endTrip),
        children: [
          Row(children: [
            Expanded(child: StatBox('${controller.stops.length - failed}', 'Delivered')),
            const SizedBox(width: 8),
            Expanded(child: StatBox('$failed', 'Failed', color: failed > 0 ? AppColors.red : null)),
          ]),
          RowCard('Odometer start', trailing: '${t?.odoStart.round() ?? 0} km'),
          LabeledField('Odometer end (km)', controller: controller.odo, keyboard: TextInputType.number),
          if (failed > 0) ...[
            InfoCard('$failed pending exception', sub: 'Add a reason and follow-up action', selected: true),
            LabeledField('Exception reason', controller: controller.exception, lines: 2),
          ],
        ],
      );
    });
  }
}
