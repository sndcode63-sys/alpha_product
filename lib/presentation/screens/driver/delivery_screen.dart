import 'package:alpha_field_app/imports.dart';

class DeliveryScreen extends GetView<TripController> {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.qtyTick.value; // rebuild when quantities change
      final s = controller.stop.value;
      if (s == null) return const AppScaffold(title: 'Delivery', children: [EmptyHint('No stop selected')]);
      final shortBy = controller.shortBy;
      return AppScaffold(
        title: s.customer,
        chip: 'DRIVER · STOP ${s.seq} OF ${controller.stops.length}',
        footer: Column(mainAxisSize: MainAxisSize.min, children: [
          PrimaryButton('Complete Delivery', controller.complete),
          const SizedBox(height: 8),
          PrimaryButton('Delivery failed / return', () => Get.toNamed(Routes.failedDelivery), ghost: true),
        ]),
        children: [
          InfoCard('', child: Column(children: [
            for (var i = 0; i < controller.qty.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Expanded(child: Text(i == 0 ? 'Biscuit carton' : 'Namkeen pack')),
                  Text('Ordered ${controller.ordered[i]}  ', style: const TextStyle(color: AppColors.muted)),
                  SizedBox(
                    width: 64,
                    child: TextField(controller: controller.qty[i], keyboardType: TextInputType.number, textAlign: TextAlign.center, onChanged: (_) => controller.qtyTick.value++),
                  ),
                ]),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(shortBy > 0 ? 'Short: $shortBy units · add a reason below' : (shortBy < 0 ? 'Excess: ${-shortBy} units' : 'Full quantity delivered'), style: TextStyle(color: shortBy == 0 ? AppColors.teal : AppColors.red)),
            ),
          ])),
          LabeledField('Customer OTP', controller: controller.otp, hint: '4 digits', keyboard: TextInputType.number, maxLength: 4),
          Row(children: [
            Expanded(child: InfoCard(controller.photo.value.isEmpty ? 'Delivery photo' : 'Delivery photo ✓', onTap: controller.pickPhoto)),
            const SizedBox(width: 8),
            Expanded(child: InfoCard(controller.signed.value.isEmpty ? 'Signature' : 'Signature ✓', onTap: controller.signPad)),
          ]),
          LabeledField('Remarks', controller: controller.remarks, hint: 'Optional'),
        ],
      );
    });
  }
}
