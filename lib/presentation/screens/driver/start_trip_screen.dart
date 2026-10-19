import 'package:alpha_field_app/imports.dart';

class StartTripScreen extends GetView<TripController> {
  const StartTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = controller.trip.value;
      const items = ['Documents carried', 'Fuel level OK', 'Load secured'];
      return AppScaffold(
        title: 'Start Trip',
        chip: 'DRIVER ROLE',
        footer: PrimaryButton('Start Trip', controller.startTrip),
        children: [
          RowCard('Vehicle', sub: t?.vehicle ?? '', trailing: 'Confirm'),
          RowCard('Stops', sub: 'Trip ${t?.id ?? ''}', trailing: '${t?.stopCount ?? 0} stops'),
          LabeledField('Odometer start (km)', controller: controller.odo, keyboard: TextInputType.number),
          for (var i = 0; i < items.length; i++)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.teal,
              title: Text(items[i]),
              value: controller.checks[i],
              onChanged: (v) => controller.checks[i] = v ?? false,
            ),
          const Text('Location tracking starts when the trip starts.', style: TextStyle(color: AppColors.muted)),
        ],
      );
    });
  }
}
