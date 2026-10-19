import 'package:alpha_field_app/imports.dart';

class AuthController extends GetxController {
  final AuthRepository repo;
  final LoginUser _login;
  final LogoutUser _logout;
  AuthController(this.repo, this._login, this._logout);

  final user = Rxn<Employee>();
  /// Role picked on the login screen (one app, role-based menu).
  final demoRole = 'sales'.obs;

  bool get isSales => (user.value?.role ?? demoRole.value) == 'sales';
  String get homeRoute => isSales ? Routes.salesHome : Routes.trips;

  @override
  void onInit() {
    final u = repo.current();
    user.value = (u == null || u.id.isEmpty) ? null : u;
    super.onInit();
  }

  Future<void> login() async {
    user.value = await _login(demoRole.value);
    final att = Get.find<AttendanceController>();
    if (!att.checkedIn) {
      Get.offAllNamed(Routes.attendance);
      AppToast.show('Pehle attendance check-in karein');
    } else {
      Get.offAllNamed(homeRoute);
      AppToast.show('Welcome back, ${user.value!.name.split(' ').first}');
    }
  }

  Future<void> logout() async {
    if (!await AppDialogs.confirm(title: 'Log out?', text: 'Unsynced items stay saved on this phone.', yes: 'Log out')) return;
    await _logout();
    user.value = null;
    Get.offAllNamed(Routes.login);
    AppToast.show('Logged out');
  }
}
