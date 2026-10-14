import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../data/models.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 90, 24, 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: ClipOval(child: Image.asset('assets/images/logo_mark.png', fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Alpha Products',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Employee App', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text('Welcome back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text)),
                  const SizedBox(height: 4),
                  const Text('Apne role ke mutabiq login karo', style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 18),

                  // Role Selector
                  const Text('Select Role:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                  const SizedBox(height: 8),
                  Obx(() => Row(
                        children: UserRole.values.map((role) {
                          final isSelected = controller.selectedRole.value == role;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => controller.selectRole(role),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? role.color : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? role.color : AppColors.border,
                                    width: isSelected ? 1.5 : 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: role.color.withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      role.icon,
                                      size: 22,
                                      color: isSelected ? Colors.white : AppColors.text,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      role.shortCode,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 10),
                  Obx(() {
                    final role = controller.selectedRole.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: role.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: role.color.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 16, color: role.color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Selected: ${role.label}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: role.color),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.empId,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Employee ID',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => TextField(
                        controller: controller.password,
                        obscureText: controller.obscure.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(controller.obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => controller.obscure.toggle(),
                          ),
                        ),
                      )),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Row(
                            children: [
                              Checkbox(
                                value: controller.remember.value,
                                activeColor: AppColors.primary,
                                onChanged: (v) => controller.remember.value = v ?? false,
                              ),
                              const Text('Remember me'),
                            ],
                          )),
                      TextButton(onPressed: () => Get.toNamed(AppRoutes.forgotPassword), child: const Text('Forgot password?')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() => ElevatedButton(
                        onPressed: controller.loading.value ? null : controller.login,
                        child: controller.loading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              )
                            : const Text('Login'),
                      )),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.vpn_key_outlined, size: 16, color: AppColors.muted),
                            SizedBox(width: 6),
                            Text('Quick Demo Credentials (Pass: 1234)',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text('• Driver: EMP-0142 (Rakesh Kumar)\n• Sales: SALE-0088 (Vikram Singh)\n• Admin: ADMIN-001 (Amit Sharma)',
                            style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
