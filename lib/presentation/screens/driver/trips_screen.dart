import 'package:alpha_field_app/imports.dart';

class TripsScreen extends GetView<TripController> {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.tabTrips;
      return AppScaffold(
        title: 'My Trips',
        chip: 'DRIVER ROLE',
        nav: true,
        showBack: false,
        children: [
          FilterChips(const ['Today', 'Upcoming', 'Done'], controller.tab.value, (v) => controller.tab.value = v),
          if (rows.isEmpty) const EmptyHint('No trips here'),
          for (final t in rows)
            RowCard('Trip ${t.id}', sub: '${t.vehicle} · ${t.stopCount} stops · ${dayOf(t.date)}', trailing: switch (t.status) { 'active' => 'In progress', 'completed' => 'Completed', _ => 'Ready' }, selected: t.status == 'active', onTap: () => controller.openTrip(t)),
        ],
      );
    });
  }
}
