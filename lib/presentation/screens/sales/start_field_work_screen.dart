import 'package:alpha_field_app/imports.dart';

class StartFieldWorkScreen extends GetView<VisitController> {
  const StartFieldWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final att = Get.find<AttendanceController>();
    return Obx(() => AppScaffold(
          title: 'Start Field Work',
          chip: 'SALES ROLE',
          footer: PrimaryButton('Start Field Work', controller.startField),
          children: [
            InfoCard('Checked in at ${att.today.value == null ? '—' : timeOf(att.today.value!.checkIn)}', sub: 'Location verified'),
            Row(children: [
              Expanded(child: StatBox('${controller.plannedCount}', 'Planned visits')),
              const SizedBox(width: 8),
              Expanded(child: StatBox('${controller.followCount('Today') + controller.followCount('Overdue')}', 'Follow-ups due')),
            ]),
            RowCard('Route preview', sub: controller.todayVisits.take(3).map((v) => v.customerName.split(' ').first).join(' → '), trailing: '${controller.plannedCount} of ${controller.todayVisits.length}', onTap: () => Get.toNamed(Routes.visitList)),
            const Text('Your starting location is saved with this session.', style: TextStyle(color: AppColors.muted)),
          ],
        ));
  }
}
