import 'package:alpha_field_app/imports.dart';

class AdHocVisitScreen extends GetView<VisitController> {
  const AdHocVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = Get.find<CustomerController>().all;
    final picked = Rxn<Customer>();
    return AppScaffold(
      title: 'Unplanned Visit',
      chip: 'SALES ROLE',
      footer: PrimaryButton('Start visit', () => controller.startAdHoc(picked.value, controller.reason.text)),
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Business'),
          items: [for (final c in customers) DropdownMenuItem(value: c.id, child: Text(c.name))],
          onChanged: (id) => picked.value = customers.firstWhere((c) => c.id == id),
        ),
        DropdownButtonFormField<String>(
          value: controller.purpose.value,
          decoration: const InputDecoration(labelText: 'Purpose'),
          items: [for (final p in VisitController.purposes) DropdownMenuItem(value: p, child: Text(p))],
          onChanged: (p) => controller.purpose.value = p!,
        ),
        LabeledField('Reason for unplanned visit', controller: controller.reason, lines: 3),
        const Text('Your manager will see this visit and may review it.', style: TextStyle(color: AppColors.muted)),
      ],
    );
  }
}
