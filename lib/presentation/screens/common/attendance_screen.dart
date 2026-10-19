import 'package:alpha_field_app/imports.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final inNow = controller.checkedIn;
      final t = controller.today.value;
      return AppScaffold(
        title: 'Attendance',
        nav: true,
        showBack: false,
        footer: PrimaryButton(inNow ? 'Check Out' : 'Check In', controller.busy.value ? null : (inNow ? controller.checkOut : controller.checkIn)),
        children: [
          InfoCard(inNow ? 'Checked in' : (t != null ? 'Checked out' : 'Not checked in'), sub: inNow ? 'Since ${timeOf(t!.checkIn)}' : DateTime.now().toString().substring(0, 10)),
          const InfoCard('Location', sub: 'GPS is captured and shown to you when you check in or out.'),
          if (!inNow) PhotoTile('Take attendance selfie', controller.selfie.value, controller.takeSelfie),
          if (inNow) InfoCard('Working today', sub: 'Tap History for your hours', onTap: () => Get.toNamed(Routes.attHistory)),
          PrimaryButton('Attendance history', () => Get.toNamed(Routes.attHistory), ghost: true),
        ],
      );
    });
  }
}
