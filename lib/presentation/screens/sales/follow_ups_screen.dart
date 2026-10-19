import 'package:alpha_field_app/imports.dart';

class FollowUpsScreen extends GetView<VisitController> {
  const FollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.filteredFollowUps;
      final tab = controller.fuTab.value;
      return AppScaffold(
        title: 'Follow-ups',
        chip: 'SALES ROLE',
        nav: true,
        showBack: false,
        children: [
          Wrap(spacing: 8, children: [
            for (final t in const ['Overdue', 'Today', 'Upcoming'])
              ChoiceChip(
                label: Text('$t ${controller.followCount(t)}'),
                selected: tab == t,
                showCheckmark: false,
                selectedColor: AppColors.ink,
                labelStyle: TextStyle(color: tab == t ? Colors.white : AppColors.muted, fontSize: 13),
                onSelected: (_) => controller.fuTab.value = t,
              ),
          ]),
          if (rows.isEmpty) EmptyHint('No $tab follow-ups'),
          for (final f in rows) RowCard(f.customerName, sub: '${f.action} · due ${dayOf(f.dueDate)}', trailing: 'Mark done', onTap: () => controller.completeFollowUp(f)),
          const Text('Reminders arrive as notifications.', style: TextStyle(color: AppColors.muted)),
        ],
      );
    });
  }
}
