import 'package:alpha_field_app/imports.dart';

class VisitHistoryScreen extends GetView<VisitController> {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.history;
      return AppScaffold(
        title: 'Visit History',
        chip: 'SALES ROLE',
        nav: true,
        children: [
          FilterChips(const ['All', 'Order', 'Follow-up', 'Unsuccessful'], controller.historyFilter.value, (v) => controller.historyFilter.value = v),
          if (rows.isEmpty) const EmptyHint('No visits for this filter'),
          for (final v in rows)
            RowCard(v.customerName, sub: '${dayOf(v.date)} · ${v.outcome.isEmpty ? v.status : v.outcome}', trailing: v.endAt.isEmpty ? '—' : '${minutesBetween(v.arrivalAt, v.endAt)} min', onTap: () {
              controller.current.value = v;
              Get.toNamed(Routes.receipt);
            }),
        ],
      );
    });
  }
}
