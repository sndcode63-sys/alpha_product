import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../data/models.dart';
import 'nav_controller.dart';

class AuthController extends GetxController {
  final empId = TextEditingController();
  final password = TextEditingController();
  final obscure = true.obs;
  final remember = true.obs;
  final loading = false.obs;

  // Selected role on login screen
  final selectedRole = UserRole.delivery.obs;

  // Current active logged in role
  final currentRole = UserRole.delivery.obs;

  // Active user profile
  final name = 'Rakesh Kumar'.obs;
  final employeeCode = 'EMP-0142'.obs;
  final mobile = '+91 98765 43210'.obs;
  final email = 'rakesh.kumar@alphaproducts.in'.obs;

  String get role => currentRole.value.label;

  @override
  void onInit() {
    super.onInit();
    fillCredentialsForRole(selectedRole.value);
  }

  void selectRole(UserRole r) {
    selectedRole.value = r;
    fillCredentialsForRole(r);
  }

  void fillCredentialsForRole(UserRole r) {
    final user = MockData.mockUsers().firstWhereOrNull((u) => u.role == r);
    if (user != null) {
      empId.text = user.empId;
      password.text = user.defaultPassword;
    }
  }

  Future<void> login() async {
    final idText = empId.text.trim();
    if (idText.isEmpty || password.text.isEmpty) {
      AppDialogs.snack('Login', 'Employee ID aur password dono daalo', type: SnackType.warning);
      return;
    }
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    loading.value = false;

    if (password.text.length < 3) {
      AppDialogs.error('Login failed', 'Employee ID ya password galat hai. Dobara try karo.');
      return;
    }

    // Determine user by entered ID or selected role
    final matchedUser = MockData.mockUsers().firstWhereOrNull(
          (u) => u.empId.toLowerCase() == idText.toLowerCase(),
        ) ??
        MockData.mockUsers().firstWhereOrNull((u) => u.role == selectedRole.value) ??
        MockData.mockUsers().first;

    // Determine active role
    UserRole activeRole = matchedUser.role;
    final upperId = idText.toUpperCase();
    if (upperId.startsWith('ADMIN')) {
      activeRole = UserRole.admin;
    } else if (upperId.startsWith('SALE')) {
      activeRole = UserRole.sales;
    } else if (upperId.startsWith('EMP')) {
      activeRole = UserRole.delivery;
    }

    currentRole.value = activeRole;
    name.value = matchedUser.name;
    employeeCode.value = matchedUser.empId;
    mobile.value = matchedUser.mobile;
    email.value = matchedUser.email;

    // Reset navigation tab index to 0 (Home/Dashboard)
    if (Get.isRegistered<NavController>()) {
      Get.find<NavController>().go(0);
    }

    Get.offAllNamed(AppRoutes.main);
  }

  void updateProfile(String n, String m, String e) {
    name.value = n;
    mobile.value = m;
    email.value = e;
  }

  /// Dummy: verify password
  bool changePassword(String oldPass, String newPass) => oldPass == '1234' || oldPass == 'alpha123' || oldPass.length >= 3;

  Future<void> logout() async {
    final ok = await AppDialogs.confirm(
      title: 'Logout?',
      message: 'Kya aap sach me logout karna chahte ho?',
      confirmText: 'Logout',
      icon: Icons.logout,
      color: AppColors.danger,
    );
    if (!ok) return;
    password.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    empId.dispose();
    password.dispose();
    super.onClose();
  }
}
