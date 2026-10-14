import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNotification {
  final IconData icon;
  final String title;
  final String body;
  final String time;
  bool read;
  AppNotification(this.icon, this.title, this.body, this.time, {this.read = false});
}

class NotificationController extends GetxController {
  final items = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    items.assignAll([
      AppNotification(Icons.inventory_2_outlined, 'New delivery assigned', 'DLV-1023 - Balaji Kirana Store aapko assign hui hai', '10 min ago'),
      AppNotification(Icons.schedule, 'Delivery reminder', 'DLV-1021 ka slot 10:00 AM se shuru hoga', '1 hr ago'),
      AppNotification(Icons.fingerprint, 'Attendance reminder', 'Check-out karna na bhoolein', 'Yesterday', read: true),
      AppNotification(Icons.local_shipping_outlined, 'Vehicle assigned', 'MH 12 AB 4821 aapko assign hua hai', '2 days ago', read: true),
    ]);
  }

  int get unread => items.where((n) => !n.read).length;

  void markAllRead() {
    for (final n in items) {
      n.read = true;
    }
    items.refresh();
  }

  void markRead(AppNotification n) {
    n.read = true;
    items.refresh();
  }

  void clear() => items.clear();
}
