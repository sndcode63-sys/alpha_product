import 'package:alpha_field_app/imports.dart';

class NotificationsScreen extends GetView<SupportController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          title: 'Notifications',
          nav: true,
          children: [
            for (final n in controller.notifications) RowCard(n.title, sub: n.body, trailing: n.time, onTap: () => Get.toNamed(n.route)),
          ],
        ));
  }
}
