import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;

  final TextEditingController mobileOrEmailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();
  final TextEditingController currentPwdCtrl = TextEditingController();
  final TextEditingController newPwdCtrl = TextEditingController();
  final TextEditingController confirmPwdCtrl = TextEditingController();

  @override
  void onClose() {
    mobileOrEmailCtrl.dispose();
    passwordCtrl.dispose();
    otpCtrl.dispose();
    currentPwdCtrl.dispose();
    newPwdCtrl.dispose();
    confirmPwdCtrl.dispose();
    super.onClose();
  }

  // Login flow
  Future<void> login() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.dashboard);
    showToast(AppStrings.loginBtn + ' Successful', isError: false);
  }

  void goForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void goBack() {
    Get.back();
  }

  // Forgot password flow
  Future<void> sendOtp() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.toNamed(AppRoutes.otpVerify);
    showToast('OTP sent to your mobile', isError: false);
  }

  // OTP verify
  final RxInt otpCountdown = 30.obs;
  final RxBool resendEnabled = false.obs;

  void startOtpTimer() {
    otpCountdown.value = 30;
    resendEnabled.value = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (otpCountdown.value <= 1) {
        resendEnabled.value = true;
        return false;
      }
      otpCountdown.value--;
      return true;
    });
  }

  Future<void> verifyOtp() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.dashboard);
    showToast('OTP Verified', isError: false);
  }

  void resendOtp() {
    if (resendEnabled.value) {
      startOtpTimer();
      showToast('OTP Resent', isError: false);
    }
  }

  // Change password
  Future<void> changePassword() async {
    if (newPwdCtrl.text != confirmPwdCtrl.text) {
      showToast('Passwords do not match');
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.back();
    showToast('Password changed successfully', isError: false);
  }

  // Logout
  Future<void> logout() async {
    Get.offAllNamed(AppRoutes.login);
    showToast('Logged out', isError: false);
  }

  void showToast(String msg, {bool isError = true}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.shade50 : Colors.green.shade50,
      colorText: isError ? Colors.red.shade900 : Colors.green.shade900,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
