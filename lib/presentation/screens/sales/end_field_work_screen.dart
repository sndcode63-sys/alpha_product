import 'package:alpha_field_app/imports.dart';

class EndFieldWorkScreen extends GetView<VisitController> {
  const EndFieldWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          title: 'End Field Work',
          chip: 'SALES ROLE',
          footer: Column(mainAxisSize: MainAxisSize.min, children: [
            PrimaryButton('End Field Work', controller.endField),
            const SizedBox(height: 8),
            PrimaryButton('Check out (Attendance)', Get.find<AttendanceController>().checkOut, ghost: true),
          ]),
          children: [
            Row(children: [
              Expanded(child: StatBox('${controller.doneCount}', 'Done')),
              const SizedBox(width: 8),
              Expanded(child: StatBox('${controller.unsuccessfulCount}', 'Unsuccessful')),
              const SizedBox(width: 8),
              Expanded(child: StatBox('${controller.pendingCount}', 'Pending sync')),
            ]),
            if (controller.openCount > 0)
              InfoCard('${controller.openCount} visit not closed', sub: 'Resume or mark unsuccessful', selected: true, onTap: () {
                controller.current.value = controller.visits.firstWhere((v) => v.status == 'in_progress');
                Get.toNamed(Routes.meeting);
              }),
            RowCard('Follow-ups created', trailing: '${controller.followUps.length}'),
          ],
        ));
  }
}
