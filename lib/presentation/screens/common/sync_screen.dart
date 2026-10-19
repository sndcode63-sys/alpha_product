import 'package:alpha_field_app/imports.dart';

class SyncScreen extends GetView<SupportController> {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          title: 'Sync Status',
          footer: PrimaryButton('Sync now', controller.syncNow),
          children: [
            InfoCard(controller.pending == 0 ? 'All synced' : 'Offline queue', sub: '${controller.pending} items waiting', selected: controller.pending > 0),
            for (final q in controller.queue) RowCard(q.label, sub: q.detail, trailing: q.status == 'pending' ? 'Pending' : 'Synced'),
            const Text('Records sync safely, no duplicate visits.', style: TextStyle(color: AppColors.muted)),
          ],
        ));
  }
}
