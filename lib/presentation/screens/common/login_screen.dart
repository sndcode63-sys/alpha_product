import 'package:alpha_field_app/imports.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = TextEditingController(text: '+91 98765 43210');
    return AppScaffold(
      title: 'Alpha Field App',
      showBack: false,
      children: [
        const Text('One app for sales visits and deliveries. Your menu depends on your role.', style: TextStyle(color: AppColors.muted)),
        Obx(() => Row(children: [
              for (final r in const [('sales', 'Salesperson'), ('driver', 'Driver')])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: SizedBox(width: double.infinity, child: Text(r.$2, textAlign: TextAlign.center)),
                      selected: controller.demoRole.value == r.$1,
                      selectedColor: AppColors.ink,
                      showCheckmark: false,
                      labelStyle: TextStyle(color: controller.demoRole.value == r.$1 ? Colors.white : AppColors.ink),
                      onSelected: (_) => controller.demoRole.value = r.$1,
                    ),
                  ),
                ),
            ])),
        LabeledField('Mobile number', controller: mobile, keyboard: TextInputType.phone),
        PrimaryButton('Send OTP', () async {
          final otp = await AppDialogs.input(title: 'Enter OTP', text: 'Code sent to ${mobile.text}', hint: '4-digit code', yes: 'Verify');
          if (otp != null && otp.length >= 4) {
            AppToast.show('OTP verified');
            controller.login();
          } else if (otp != null) {
            AppToast.show('Enter the 4-digit code');
          }
        }),
        const Center(child: Text('or use Employee ID', style: TextStyle(color: AppColors.muted))),
        const LabeledField('Employee ID', hint: 'EMP-0123'),
        const LabeledField('Password', hint: 'Password'),
        PrimaryButton('Login', controller.login, ghost: true),
      ],
    );
  }
}
