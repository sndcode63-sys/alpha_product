import 'package:alpha_field_app/imports.dart';

class ProfileScreen extends GetView<AuthController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final u = controller.user.value;
      return AppScaffold(
        title: 'Profile',
        nav: true,
        showBack: false,
        footer: PrimaryButton('Logout', controller.logout, ghost: true),
        children: [
          Row(children: [
            const CircleAvatar(radius: 32, backgroundColor: AppColors.mint, child: Icon(Icons.person, color: AppColors.teal, size: 32)),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
              Text('${u?.empCode ?? ''} · ${controller.isSales ? 'Salesperson' : 'Driver'}', style: const TextStyle(color: AppColors.muted)),
            ]),
          ]),
          RowCard('Manager', trailing: u?.manager ?? ''),
          RowCard('Territory', trailing: u?.territory ?? ''),
          RowCard('Phone', trailing: u?.phone ?? ''),
          RowCard('Notifications', trailing: '›', onTap: () => Get.toNamed(Routes.notifications)),
          RowCard('Sync status', trailing: '›', onTap: () => Get.toNamed(Routes.sync)),
          RowCard('Help & Support', sub: 'FAQ, call support', trailing: '›', onTap: () => AppToast.show('Support: 1800-000-0000')),
          const RowCard('App version', trailing: '1.0.0'),
        ],
      );
    });
  }
}
