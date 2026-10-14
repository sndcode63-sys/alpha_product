import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';
import '../core/app_dialogs.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

class NotificationsScreen extends GetView<NotificationController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Mark all read',
            icon: const Icon(Icons.done_all),
            onPressed: controller.markAllRead,
          ),
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              if (controller.items.isEmpty) return;
              final ok = await AppDialogs.confirm(
                title: 'Clear all?',
                message: 'Saari notifications delete ho jayengi.',
                confirmText: 'Clear',
                icon: Icons.delete_outline,
                color: AppColors.danger,
              );
              if (ok) controller.clear();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.muted),
                SizedBox(height: 12),
                Text('Koi notification nahi hai', style: TextStyle(color: AppColors.muted)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.items.length,
          itemBuilder: (_, i) {
            final n = controller.items[i];
            return AppCard(
              onTap: () => controller.markRead(n),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                    child: Icon(n.icon, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.title,
                            style: TextStyle(fontWeight: n.read ? FontWeight.w600 : FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(n.body, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                        const SizedBox(height: 4),
                        Text(n.time, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  if (!n.read)
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
