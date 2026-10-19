import 'package:alpha_field_app/imports.dart';

class ReceiptScreen extends GetView<VisitController> {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final v = controller.current.value;
      if (v == null) return const AppScaffold(title: 'Receipt', children: [EmptyHint('No visit')]);
      return AppScaffold(
        title: 'Meeting closed',
        chip: 'SALES ROLE',
        showBack: false,
        footer: PrimaryButton('Back to visits', () => Get.offNamedUntil(Routes.visitList, (r) => r.settings.name == Routes.salesHome || r.isFirst)),
        children: [
          InfoCard(v.customerName, sub: v.status == 'followup' ? 'Closed · Follow-up required' : (v.status == 'unsuccessful' ? 'Unsuccessful visit' : 'Closed'), selected: true),
          RowCard('Duration', sub: '${timeOf(v.arrivalAt)} – ${timeOf(v.endAt)}', trailing: '${minutesBetween(v.arrivalAt, v.endAt)} min'),
          RowCard('Outcome', trailing: v.outcome.isEmpty ? '—' : v.outcome),
          if (v.followUpDate.isNotEmpty) RowCard('Next action', sub: v.nextAction, trailing: dayOf(v.followUpDate)),
          RowCard('Selfie', trailing: v.selfiePath.isEmpty ? '—' : '✓'),
        ],
      );
    });
  }
}
