import 'package:alpha_field_app/imports.dart';

class ArrivedStopScreen extends GetView<TripController> {
  const ArrivedStopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s = controller.stop.value;
      final f = controller.fix.value;
      final d = controller.distanceToStop;
      return AppScaffold(
        title: 'You have arrived',
        chip: 'DRIVER ROLE',
        footer: PrimaryButton('Proceed to delivery', controller.prepareDelivery),
        children: [
          InfoCard(s?.customer ?? '', sub: 'Arrived ${timeOf(s?.arrivedAt ?? '')}', selected: true),
          RowCard(f == null ? 'GPS' : 'GPS accuracy ${f.accuracy.round()} m', sub: d == null ? '' : '${d.round()} m from the address', trailing: d == null ? '' : (d < 200 ? 'Near' : 'Far')),
          const Text('Arrival is recorded with GPS as a status claim. Add a reason if the location looks off.', style: TextStyle(color: AppColors.muted)),
          LabeledField('Reason (optional)', controller: controller.remarks, hint: 'Gate closed, parked outside'),
        ],
      );
    });
  }
}
