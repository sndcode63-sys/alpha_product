import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/app_dialogs.dart';
import '../core/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final auth = Get.find<AuthController>();
  late final name = TextEditingController(text: auth.name.value);
  late final mobile = TextEditingController(text: auth.mobile.value);
  late final email = TextEditingController(text: auth.email.value);

  Future<void> _save() async {
    if (name.text.trim().isEmpty) {
      return AppDialogs.snack('Required', 'Naam khali nahi ho sakta', type: SnackType.warning);
    }
    if (mobile.text.replaceAll(RegExp(r'\D'), '').length < 10) {
      return AppDialogs.snack('Invalid mobile', 'Sahi mobile number daalo', type: SnackType.warning);
    }
    if (!GetUtils.isEmail(email.text.trim())) {
      return AppDialogs.snack('Invalid email', 'Sahi email daalo', type: SnackType.warning);
    }
    AppDialogs.loading('Profile save ho rahi hai...');
    await Future.delayed(const Duration(seconds: 1)); // API call yahan
    AppDialogs.hideLoading();
    auth.updateProfile(name.text.trim(), mobile.text.trim(), email.text.trim());
    Get.back();
    AppDialogs.success('Profile updated', 'Aapki profile save ho gayi.');
  }

  @override
  void dispose() {
    name.dispose();
    mobile.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, size: 48, color: AppColors.primary),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: AppDialogs.photoSource, // TODO: image_picker
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 14),
          TextField(
            controller: mobile,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Mobile', prefixIcon: Icon(Icons.phone_outlined)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(height: 14),
          TextField(
            enabled: false,
            controller: TextEditingController(text: auth.employeeCode.value),
            decoration: const InputDecoration(labelText: 'Employee ID (change nahi hoga)', prefixIcon: Icon(Icons.badge_outlined)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Save Changes')),
        ],
      ),
    );
  }
}
