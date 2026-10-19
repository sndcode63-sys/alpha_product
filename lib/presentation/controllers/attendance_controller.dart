import 'package:alpha_field_app/imports.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository repo;
  final CheckIn _in;
  final CheckOut _out;
  final GetAttendanceHistory _hist;
  AttendanceController(this.repo, this._in, this._out, this._hist);

  final today = Rxn<AttendanceRecord>();
  final history = <AttendanceRecord>[].obs;
  final selfie = ''.obs;
  final busy = false.obs;

  bool get checkedIn => today.value != null && today.value!.checkOut.isEmpty;

  @override
  void onInit() {
    reload();
    super.onInit();
  }

  void reload() {
    today.value = repo.today();
    history.assignAll(_hist());
  }

  Future<void> takeSelfie() async {
    final p = await Get.toNamed(Routes.camera, arguments: 'Attendance selfie');
    if (p is String && p.isNotEmpty) {
      selfie.value = p;
      AppToast.show('Photo saved ✓');
    }
  }

  Future<void> checkIn() async {
    if (selfie.value.isEmpty) {
      AppToast.show('Take your selfie first');
      return takeSelfie();
    }
    final fix = await captureGps();
    if (fix == null) return;
    today.value = await _in(fix.lat, fix.lng, selfie.value);
    reload();
    AppToast.show('Checked in ${hhmm()} · ${fix.label}');
    Get.offAllNamed(Get.find<AuthController>().homeRoute);
  }

  Future<void> checkOut() async {
    if (!await AppDialogs.confirm(title: 'Check out for today?', text: 'Working hours will be calculated.', yes: 'Check out')) return;
    if (await captureGps() == null) return;
    await _out();
    selfie.value = '';
    reload();
    AppToast.show('Checked out ${hhmm()}');
    Get.offNamed(Routes.attHistory);
  }

  Future<void> requestCorrection() async {
    final why = await AppDialogs.input(title: 'Attendance correction', text: 'Forgot to check in? Your manager will approve or reject.', hint: 'Reason');
    if (why != null && why.isNotEmpty) AppToast.show('Request sent to manager');
  }

  String get monthSummary {
    final done = history.where((h) => h.checkOut.isNotEmpty).toList();
    final mins = done.fold<int>(0, (a, h) => a + minutesBetween(h.checkIn, h.checkOut));
    return '${history.length} days present · ${(mins / 60).round()} h worked';
  }
}
