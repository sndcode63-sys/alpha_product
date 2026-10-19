import 'package:alpha_field_app/imports.dart';

class SalesHomeScreen extends GetView<VisitController> {
  const SalesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final att = Get.find<AttendanceController>();
    final name = Get.find<AuthController>().user.value?.name.split(' ').first ?? '';
    return Obx(() {
      final planned = controller.todayVisits.where((v) => v.status == 'planned').take(3).toList();
      return AppScaffold(
        title: 'Hello, $name',
        chip: 'SALES ROLE',
        nav: true,
        showBack: false,
        children: [
          Text(att.checkedIn ? 'Checked in ${timeOf(att.today.value!.checkIn)}' : 'Not checked in yet', style: const TextStyle(color: AppColors.muted)),
          PrimaryButton(controller.fieldActive.value ? 'Field work in progress' : 'Start Field Work', controller.fieldActive.value ? () => Get.toNamed(Routes.visitList) : controller.beginFieldWork),
          Row(children: [
            Expanded(child: StatBox('${controller.plannedCount}', 'Planned')),
            const SizedBox(width: 8),
            Expanded(child: StatBox('${controller.doneCount}', 'Done')),
            const SizedBox(width: 8),
            Expanded(child: InkWell(onTap: () => Get.toNamed(Routes.followUps), child: StatBox('${controller.followCount('Overdue')}', 'Overdue', color: AppColors.red))),
          ]),
          const Text("Today's visits", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          if (planned.isEmpty) const EmptyHint('No planned visits'),
          for (final v in planned) RowCard(v.customerName, sub: '${v.category} · ${v.purpose}', trailing: v.priority, onTap: () => controller.openVisit(v)),
          RowCard('Customers', sub: 'Search all vendors, distributors and retailers', trailing: '›', onTap: () => Get.toNamed(Routes.custList)),
          RowCard('Visit history', trailing: '›', onTap: () => Get.toNamed(Routes.visitHistory)),
        ],
      );
    });
  }
}
