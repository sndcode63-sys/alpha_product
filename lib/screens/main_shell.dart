import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/nav_controller.dart';
import '../core/app_dialogs.dart';
import '../core/app_theme.dart';
import '../data/models.dart';
import 'attendance_screen.dart';
import 'delivery_list_screen.dart';
import 'home_screen.dart';
import 'new_order_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';
import 'vehicle_screen.dart';

class MainShell extends GetView<NavController> {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      final role = auth.currentRole.value;
      final currentIndex = controller.index.value.clamp(0, 4);

      final List<Widget> screens;
      final List<NavigationDestination> destinations;

      switch (role) {
        case UserRole.delivery:
          screens = const [
            HomeScreen(),
            AttendanceScreen(),
            DeliveryListScreen(),
            VehicleScreen(),
            ProfileScreen(),
          ];
          destinations = const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.fingerprint), selectedIcon: Icon(Icons.fingerprint), label: 'Attendance'),
            NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Deliveries'),
            NavigationDestination(icon: Icon(Icons.local_shipping_outlined), selectedIcon: Icon(Icons.local_shipping), label: 'Vehicle'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ];
          break;

        case UserRole.sales:
          screens = const [
            HomeScreen(),
            AttendanceScreen(),
            NewOrderScreen(),
            OrderHistoryScreen(),
            ProfileScreen(),
          ];
          destinations = const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.fingerprint), selectedIcon: Icon(Icons.fingerprint), label: 'Attendance'),
            NavigationDestination(icon: Icon(Icons.add_shopping_cart_outlined), selectedIcon: Icon(Icons.add_shopping_cart), label: 'New Order'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ];
          break;

        case UserRole.admin:
          screens = const [
            HomeScreen(),
            DeliveryListScreen(),
            OrderHistoryScreen(),
            VehicleScreen(),
            ProfileScreen(),
          ];
          destinations = const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Deliveries'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
            NavigationDestination(icon: Icon(Icons.local_shipping_outlined), selectedIcon: Icon(Icons.local_shipping), label: 'Fleet'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ];
          break;
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          if (controller.index.value != 0) {
            controller.go(0);
            return;
          }
          final exit = await AppDialogs.confirm(
            title: 'Exit app?',
            message: 'Kya aap app band karna chahte ho?',
            confirmText: 'Exit',
            icon: Icons.exit_to_app,
            color: AppColors.danger,
          );
          if (exit) SystemNavigator.pop();
        },
        child: Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: controller.go,
            destinations: destinations,
          ),
        ),
      );
    });
  }
}
