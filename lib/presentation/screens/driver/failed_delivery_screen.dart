import 'package:alpha_field_app/imports.dart';

class FailedDeliveryScreen extends GetView<TripController> {
  const FailedDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          title: 'Delivery not completed',
          chip: 'DRIVER ROLE',
          footer: PrimaryButton('Submit & next stop', controller.failDelivery),
          children: [
            Text('${controller.stop.value?.customer ?? ''} · Stop ${controller.stop.value?.seq ?? ''}', style: const TextStyle(color: AppColors.muted)),
            FilterChips(TripController.failReasons, controller.failReason.value, (v) => controller.failReason.value = v),
            LabeledField('Remarks', controller: controller.remarks, lines: 3),
            PhotoTile('Photo of location', controller.photo.value, controller.pickPhoto),
            const Text('Order goes to the dispatcher for re-delivery or return.', style: TextStyle(color: AppColors.muted)),
          ],
        ));
  }
}
