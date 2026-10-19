import 'package:alpha_field_app/imports.dart';

class MeetingScreen extends GetView<VisitController> {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final v = controller.current.value;
      return AppScaffold(
        title: v?.customerName ?? 'Meeting',
        chip: 'SALES · VISIT IN PROGRESS',
        footer: PrimaryButton('Close Meeting', controller.closeMeeting),
        children: [
          Text('${v?.category ?? ''} · Arrived ${timeOf(v?.arrivalAt ?? '')}${(v?.gpsNote.isNotEmpty ?? false) ? ' · ${v!.gpsNote}' : ''}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          LabeledField('Contact person', controller: controller.contact),
          LabeledField('Products discussed', controller: controller.products, hint: 'e.g. Biscuit, Namkeen'),
          LabeledField('Order potential (₹)', controller: controller.potential, keyboard: TextInputType.number),
          DropdownButtonFormField<String>(
            value: controller.purpose.value,
            decoration: const InputDecoration(labelText: 'Purpose'),
            items: [for (final p in VisitController.purposes) DropdownMenuItem(value: p, child: Text(p))],
            onChanged: (p) => controller.purpose.value = p!,
          ),
          LabeledField('Discussion summary', controller: controller.summary, lines: 3),
          const Text('Outcome', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          FilterChips(VisitController.outcomes, controller.outcome.value, (o) => controller.outcome.value = o),
          if (controller.outcome.value == 'Follow-up needed') ...[
            DropdownButtonFormField<String>(
              value: controller.nextAction.value,
              decoration: const InputDecoration(labelText: 'Next action'),
              items: [for (final a in VisitController.actions) DropdownMenuItem(value: a, child: Text(a))],
              onChanged: (a) => controller.nextAction.value = a!,
            ),
            RowCard('Follow-up date', trailing: controller.followDate.value.isEmpty ? 'Pick date' : dayOf(controller.followDate.value), onTap: () => controller.pickFollowDate(context)),
          ],
          PhotoTile('Selfie with contact', controller.selfie.value, controller.takeSelfie),
          PrimaryButton('+ Create order', () {
            final c = Get.find<CustomerController>().all.firstWhereOrNull((c) => c.id == v?.customerId);
            Get.find<OrderController>().forCustomer(c);
            Get.toNamed(Routes.orderCreate);
          }, ghost: true),
        ],
      );
    });
  }
}
