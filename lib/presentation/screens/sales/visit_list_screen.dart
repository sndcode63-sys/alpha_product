import 'package:alpha_field_app/imports.dart';

String _label(String s) => const {'planned': 'Planned', 'closed': 'Done', 'followup': 'Follow-up', 'pending_sync': 'Pending sync', 'unsuccessful': 'Unsuccessful', 'in_progress': 'In progress'}[s] ?? s;

class VisitListScreen extends GetView<VisitController> {
  const VisitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.filteredToday;
      return AppScaffold(
        title: "Today's Visits",
        chip: 'SALES ROLE',
        nav: true,
        showBack: false,
        children: [
          LabeledField('', hint: 'Search business', onChanged: (v) => controller.search.value = v),
          FilterChips(const ['All', 'Planned', 'Done', 'Pending sync', 'Unsuccessful'], controller.filter.value, (v) => controller.filter.value = v),
          if (rows.isEmpty) const EmptyHint('No matching visits'),
          for (final v in rows) RowCard(v.customerName, sub: '${v.category} · ${v.purpose}${v.adHoc ? ' · Ad-hoc' : ''}', trailing: _label(v.status), onTap: () => controller.openVisit(v)),
          PrimaryButton('+ Ad-hoc visit', () => Get.toNamed(Routes.adHoc), ghost: true),
          PrimaryButton('End field work', () => Get.toNamed(Routes.endFw), ghost: true),
        ],
      );
    });
  }
}
