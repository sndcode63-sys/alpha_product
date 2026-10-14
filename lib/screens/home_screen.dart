import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/attendance_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/delivery_controller.dart';
import '../controllers/nav_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import 'delivery_list_screen.dart';

Color _orderColor(String s) => switch (s) {
      'Delivered' => AppColors.success,
      'Dispatched' => AppColors.primary,
      'Confirmed' => AppColors.warning,
      _ => AppColors.muted,
    };

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final att = Get.find<AttendanceController>();
    final del = Get.find<DeliveryController>();
    final veh = Get.find<VehicleController>();
    final nav = Get.find<NavController>();
    final noti = Get.find<NotificationController>();
    final ord = Get.find<OrderController>();

    return Scaffold(
      body: Column(
        children: [
          // Header Bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Obx(() => Text(
                        auth.name.value.isNotEmpty ? auth.name.value[0] : 'U',
                        style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800),
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            'Hello, ${auth.name.value.split(' ').first}',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                          )),
                      Obx(() => Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${auth.role} • ${fmtDate(DateTime.now())}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          )),
                    ],
                  ),
                ),
                Obx(() => IconButton(
                      onPressed: () => Get.toNamed(AppRoutes.notifications),
                      icon: Badge(
                        isLabelVisible: noti.unread > 0,
                        label: Text('${noti.unread}'),
                        child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                      ),
                    )),
              ],
            ),
          ),

          // Scrollable Body
          Expanded(
            child: Obx(() {
              final role = auth.currentRole.value;
              switch (role) {
                case UserRole.delivery:
                  return _buildDeliveryHome(context, auth, att, del, veh, nav);
                case UserRole.sales:
                  return _buildSalesHome(context, auth, att, ord, nav);
                case UserRole.admin:
                  return _buildAdminHome(context, auth, att, del, ord, veh, nav);
              }
            }),
          ),
        ],
      ),
    );
  }

  // --- DELIVERY DRIVER VIEW ---
  Widget _buildDeliveryHome(
    BuildContext context,
    AuthController auth,
    AttendanceController att,
    DeliveryController del,
    VehicleController veh,
    NavController nav,
  ) {
    del.version.value;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Attendance summary
        _buildAttendanceCard(att, () => nav.go(1)),

        // Delivery Stats
        Row(
          children: [
            StatTile(Icons.schedule, '${del.count(DeliveryStatus.pending)}', 'Pending'),
            const SizedBox(width: 10),
            StatTile(Icons.local_shipping_outlined, '${del.count(DeliveryStatus.inTransit)}', 'In Transit'),
            const SizedBox(width: 10),
            StatTile(Icons.check_circle_outline, '${del.count(DeliveryStatus.completed)}', 'Completed'),
            const SizedBox(width: 10),
            StatTile(Icons.route_outlined, veh.distance.value.toStringAsFixed(1), 'Km today'),
          ],
        ),

        const SectionTitle('Quick Actions'),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.85,
          children: [
            _QuickAction(Icons.fingerprint, 'Attendance', () => nav.go(1)),
            _QuickAction(Icons.inventory_2_outlined, 'Deliveries', () => nav.go(2)),
            _QuickAction(Icons.local_shipping_outlined, 'Vehicle', () => nav.go(3)),
            _QuickAction(Icons.history, 'Att. History', () => Get.toNamed(AppRoutes.attendanceHistory)),
            _QuickAction(Icons.receipt_long_outlined, 'Orders', () => Get.toNamed(AppRoutes.orderHistory)),
            _QuickAction(Icons.route_outlined, 'Trips', () => Get.toNamed(AppRoutes.tripHistory)),
            _QuickAction(Icons.notifications_none, 'Alerts', () => Get.toNamed(AppRoutes.notifications)),
            _QuickAction(Icons.help_outline, 'Help', () => Get.toNamed(AppRoutes.help)),
          ],
        ),

        SectionTitle("Today's Deliveries", action: 'View all', onAction: () => nav.go(2)),
        Builder(builder: (_) {
          final upcoming = del.deliveries.where((d) => d.status != DeliveryStatus.completed).take(2).toList();
          if (upcoming.isEmpty) {
            return const AppCard(child: Center(child: Text('Saari deliveries complete ho gayi 🎉')));
          }
          return Column(children: upcoming.map((d) => DeliveryCard(d)).toList());
        }),
      ],
    );
  }

  // --- SALES EXECUTIVE VIEW ---
  Widget _buildSalesHome(
    BuildContext context,
    AuthController auth,
    AttendanceController att,
    OrderController ord,
    NavController nav,
  ) {
    final totalOrders = ord.orders.length;
    final confirmed = ord.orders.where((o) => o.status == 'Confirmed').length;
    final dispatched = ord.orders.where((o) => o.status == 'Dispatched').length;
    final totalValue = ord.orders.fold<double>(0, (sum, o) => sum + o.total);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Attendance summary
        _buildAttendanceCard(att, () => nav.go(1)),

        // Sales Stats
        Row(
          children: [
            StatTile(Icons.receipt_long, '$totalOrders', 'Total Orders'),
            const SizedBox(width: 10),
            StatTile(Icons.check_circle_outline, '$confirmed', 'Confirmed'),
            const SizedBox(width: 10),
            StatTile(Icons.local_shipping_outlined, '$dispatched', 'Dispatched'),
            const SizedBox(width: 10),
            StatTile(Icons.currency_rupee, '₹${(totalValue / 1000).toStringAsFixed(1)}k', 'Booked'),
          ],
        ),

        const SectionTitle('Sales Actions'),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.85,
          children: [
            _QuickAction(Icons.add_shopping_cart, 'New Order', () => nav.go(2)),
            _QuickAction(Icons.receipt_long_outlined, 'My Orders', () => nav.go(3)),
            _QuickAction(Icons.fingerprint, 'Attendance', () => nav.go(1)),
            _QuickAction(Icons.history, 'Att. History', () => Get.toNamed(AppRoutes.attendanceHistory)),
            _QuickAction(Icons.place_outlined, 'Locations', () => Get.toNamed(AppRoutes.locationHistory)),
            _QuickAction(Icons.notifications_none, 'Alerts', () => Get.toNamed(AppRoutes.notifications)),
            _QuickAction(Icons.settings_outlined, 'Settings', () => Get.toNamed(AppRoutes.settings)),
            _QuickAction(Icons.help_outline, 'Help', () => Get.toNamed(AppRoutes.help)),
          ],
        ),

        SectionTitle('Recent Booked Orders', action: 'Create New', onAction: () => nav.go(2)),
        if (ord.orders.isEmpty)
          const AppCard(child: Center(child: Text('Abhi koi order nahi hai. Naya order create karo!')))
        else
          Column(
            children: ord.orders.take(3).map((o) {
              return AppCard(
                onTap: () => Get.toNamed(AppRoutes.orderDetails, arguments: o),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(o.id, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
                        StatusChip(o.status, _orderColor(o.status)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(o.customer, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${fmtDate(o.date)} • ${o.totalQty} items',
                            style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                        Text('₹${o.total.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // --- ADMIN / MANAGER VIEW ---
  Widget _buildAdminHome(
    BuildContext context,
    AuthController auth,
    AttendanceController att,
    DeliveryController del,
    OrderController ord,
    VehicleController veh,
    NavController nav,
  ) {
    del.version.value;
    final totalDel = del.deliveries.length;
    final totalOrd = ord.orders.length;
    final inTransitDel = del.count(DeliveryStatus.inTransit);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Operations Overview Banner
        AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Operations Central', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    SizedBox(height: 2),
                    Text(
                      'All branches, fleet & orders status live',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Live', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
        ),

        // Admin Stats
        Row(
          children: [
            StatTile(Icons.inventory_2_outlined, '$totalDel', 'Deliveries'),
            const SizedBox(width: 10),
            StatTile(Icons.receipt_long_outlined, '$totalOrd', 'Orders'),
            const SizedBox(width: 10),
            const StatTile(Icons.local_shipping_outlined, '4', 'Fleet Units'),
            const SizedBox(width: 10),
            StatTile(Icons.navigation_outlined, '$inTransitDel', 'In Transit'),
          ],
        ),

        const SectionTitle('Manager Quick Controls'),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.85,
          children: [
            _QuickAction(Icons.inventory_2_outlined, 'Deliveries', () => nav.go(1)),
            _QuickAction(Icons.receipt_long_outlined, 'All Orders', () => nav.go(2)),
            _QuickAction(Icons.local_shipping_outlined, 'Fleet', () => nav.go(3)),
            _QuickAction(Icons.add_shopping_cart, 'New Order', () => Get.toNamed(AppRoutes.newOrder)),
            _QuickAction(Icons.history, 'Att. History', () => Get.toNamed(AppRoutes.attendanceHistory)),
            _QuickAction(Icons.route_outlined, 'Trip History', () => Get.toNamed(AppRoutes.tripHistory)),
            _QuickAction(Icons.notifications_none, 'Alerts', () => Get.toNamed(AppRoutes.notifications)),
            _QuickAction(Icons.settings_outlined, 'Settings', () => Get.toNamed(AppRoutes.settings)),
          ],
        ),

        SectionTitle('Active Fleet Deliveries', action: 'View all', onAction: () => nav.go(1)),
        Column(
          children: del.deliveries.take(2).map((d) => DeliveryCard(d)).toList(),
        ),

        SectionTitle('Latest Orders Placed', action: 'All Orders', onAction: () => nav.go(2)),
        Column(
          children: ord.orders.take(2).map((o) {
            return AppCard(
              onTap: () => Get.toNamed(AppRoutes.orderDetails, arguments: o),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.customer, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('${o.id} • ${o.totalQty} items', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                  StatusChip(o.status, _orderColor(o.status)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Common Attendance Tile
  Widget _buildAttendanceCard(AttendanceController att, VoidCallback onCheckIn) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (att.checkedIn.value ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              att.checkedIn.value ? Icons.timer_outlined : Icons.fingerprint,
              color: att.checkedIn.value ? AppColors.success : AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(att.checkedIn.value ? 'Checked In' : 'Not checked in',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                Text(
                  att.checkedIn.value
                      ? 'Working: ${fmtClock(att.worked.value)}'
                      : 'Din shuru karne ke liye check-in karo',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          if (!att.checkedIn.value)
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
                onPressed: onCheckIn,
                child: const Text('Check In', style: TextStyle(fontSize: 13)),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}
