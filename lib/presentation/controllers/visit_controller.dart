import 'package:alpha_field_app/imports.dart';
import 'package:geolocator/geolocator.dart';

class VisitController extends GetxController {
  final VisitRepository repo;
  final SaveVisit _save;
  final SaveFollowUp _saveFollowUp;
  final LocationService loc;
  VisitController(this.repo, this._save, this._saveFollowUp, this.loc);

  static const purposes = ['Order collection', 'Product introduction', 'Payment follow-up', 'Complaint', 'Relationship visit'];
  static const outcomes = ['Order received', 'Follow-up needed', 'Not interested', 'Unavailable'];
  static const actions = ['Call', 'Quotation', 'Sample', 'Revisit', 'Resolve issue'];

  final visits = <Visit>[].obs;
  final followUps = <FollowUp>[].obs;
  final fieldActive = false.obs;
  final current = Rxn<Visit>();
  final fix = Rxn<GeoFix>();
  final search = ''.obs, filter = 'All'.obs, historyFilter = 'All'.obs, fuTab = 'Overdue'.obs;

  final contact = TextEditingController(), summary = TextEditingController(), products = TextEditingController(),
      potential = TextEditingController(text: '25000'), reason = TextEditingController();
  final purpose = purposes.first.obs, outcome = ''.obs, nextAction = 'Quotation'.obs, followDate = ''.obs, selfie = ''.obs;

  @override
  void onInit() {
    reload();
    super.onInit();
  }

  void reload() {
    visits.assignAll(repo.all());
    followUps.assignAll(repo.followUps());
    fieldActive.value = repo.fieldActive();
  }

  // ---- lists / stats ----
  List<Visit> get todayVisits => visits.where((v) => v.date == todayIso()).toList();
  int get plannedCount => todayVisits.where((v) => v.status == 'planned').length;
  int get doneCount => todayVisits.where((v) => v.status == 'closed' || v.status == 'followup').length;
  int get pendingCount => visits.where((v) => v.status == 'pending_sync').length;
  int get unsuccessfulCount => todayVisits.where((v) => v.status == 'unsuccessful').length;
  int get openCount => visits.where((v) => v.status == 'in_progress').length;

  bool _matches(Visit v, String f) => switch (f) {
        'Planned' => v.status == 'planned',
        'Done' => v.status == 'closed' || v.status == 'followup',
        'Pending sync' => v.status == 'pending_sync',
        'Unsuccessful' => v.status == 'unsuccessful',
        'Order' => v.outcome == 'Order received',
        'Follow-up' => v.outcome == 'Follow-up needed',
        _ => true,
      };

  List<Visit> get filteredToday => todayVisits.where((v) => _matches(v, filter.value) && v.customerName.toLowerCase().contains(search.value.toLowerCase())).toList();
  List<Visit> get history => visits.where((v) => ['closed', 'followup', 'unsuccessful'].contains(v.status) && _matches(v, historyFilter.value)).toList()..sort((a, b) => b.date.compareTo(a.date));

  List<FollowUp> get filteredFollowUps {
    final t = todayIso();
    return followUps.where((f) => !f.done && switch (fuTab.value) { 'Overdue' => f.dueDate.compareTo(t) < 0, 'Today' => f.dueDate == t, _ => f.dueDate.compareTo(t) > 0 }).toList();
  }
  int followCount(String tab) {
    final t = todayIso();
    return followUps.where((f) => !f.done && switch (tab) { 'Overdue' => f.dueDate.compareTo(t) < 0, 'Today' => f.dueDate == t, _ => f.dueDate.compareTo(t) > 0 }).length;
  }

  double? get distance {
    final f = fix.value, v = current.value;
    return (f == null || v == null) ? null : Geolocator.distanceBetween(f.lat, f.lng, v.lat, v.lng);
  }

  // ---- field session ----
  void beginFieldWork() {
    if (!Get.find<AttendanceController>().checkedIn) {
      AppToast.show('Check in first');
      Get.toNamed(Routes.attendance);
      return;
    }
    Get.toNamed(Routes.startFw);
  }

  Future<void> startField() async {
    if (!Get.find<AttendanceController>().checkedIn) return beginFieldWork();
    if (await captureGps() == null) return;
    await repo.setFieldActive(true);
    fieldActive.value = true;
    AppToast.show('Field session started ${hhmm()}');
    Get.toNamed(Routes.visitList);
  }

  Future<void> endField() async {
    final n = openCount;
    if (!await AppDialogs.confirm(title: 'End field work?', text: n > 0 ? '$n visit is still open and will be flagged.' : 'All visits are closed.', yes: 'End')) return;
    await repo.setFieldActive(false);
    fieldActive.value = false;
    AppToast.show('Field session ended');
    Get.offAllNamed(Routes.attendance);
  }

  // ---- visit flow ----
  void _resetForm(Visit v) {
    contact.text = v.contactMet;
    summary.text = v.summary;
    products.text = v.products;
    outcome.value = v.outcome;
    selfie.value = v.selfiePath;
    followDate.value = '';
  }

  void openVisit(Visit v) {
    current.value = v;
    _resetForm(v);
    fix.value = null;
    loc.currentFix().then((f) => fix.value = f);
    switch (v.status) {
      case 'closed' || 'followup':
        Get.toNamed(Routes.receipt);
      case 'unsuccessful':
        AppToast.show('Marked unsuccessful: contact unavailable');
      case 'in_progress':
        Get.toNamed(Routes.meeting);
      default:
        Get.toNamed(Routes.arrival);
    }
  }

  Future<void> arrive({String why = ''}) async {
    final f = await captureGps();
    if (f == null) return;
    final v = current.value!.copyWith(status: 'in_progress', arrivalAt: DateTime.now().toIso8601String(), gpsNote: f.label + (why.isEmpty ? '' : ' · $why'));
    current.value = await _save(v);
    reload();
    AppToast.show('Arrival recorded ${hhmm()} · ${f.label}');
    Get.toNamed(Routes.meeting);
  }

  Future<void> arriveOutside() async {
    final why = await AppDialogs.input(title: 'Outside the permitted area', text: 'Tell your manager why you are starting here.', hint: 'Reason');
    if (why == null || why.isEmpty) return;
    await arrive(why: why);
    AppToast.show('Sent for manager approval');
  }

  Future<void> takeSelfie() async {
    final p = await Get.toNamed(Routes.camera, arguments: 'Selfie with contact person');
    if (p is String && p.isNotEmpty) selfie.value = p;
  }

  Future<void> closeMeeting() async {
    if (contact.text.trim().isEmpty) return AppToast.show('Enter contact person');
    if (summary.text.trim().isEmpty) return AppToast.show('Enter discussion summary');
    if (outcome.value.isEmpty) return AppToast.show('Select an outcome');
    if (selfie.value.isEmpty) return AppToast.show('Selfie required (or choose an exception reason)');
    if (outcome.value == 'Follow-up needed' && followDate.value.isEmpty) return AppToast.show('Pick a follow-up date');
    if (!await AppDialogs.confirm(title: 'Close this meeting?', text: 'Summary, outcome and selfie are complete.', yes: 'Close')) return;
    final status = outcome.value == 'Unavailable' ? 'unsuccessful' : (outcome.value == 'Follow-up needed' ? 'followup' : 'closed');
    final v = current.value!.copyWith(
      status: status, endAt: DateTime.now().toIso8601String(), contactMet: contact.text.trim(), summary: summary.text.trim(),
      products: products.text.trim(), orderPotential: double.tryParse(potential.text) ?? 0, outcome: outcome.value, purpose: purpose.value,
      nextAction: nextAction.value, followUpDate: followDate.value, selfiePath: selfie.value);
    current.value = await _save(v);
    if (status == 'followup') {
      await _saveFollowUp(FollowUp(id: 'F${DateTime.now().millisecondsSinceEpoch}', visitId: v.id, customerName: v.customerName, action: nextAction.value, dueDate: followDate.value));
    }
    reload();
    AppToast.show('Meeting closed · follow-up set');
    Get.offNamed(Routes.receipt);
  }

  Future<void> startAdHoc(Customer? c, String why) async {
    if (c == null || why.trim().isEmpty) return AppToast.show('Select a business and enter the reason');
    final v = Visit(id: 'V${DateTime.now().millisecondsSinceEpoch}', customerId: c.id, customerName: c.name, category: c.category, address: c.address, purpose: purpose.value, status: 'in_progress', date: todayIso(), arrivalAt: DateTime.now().toIso8601String(), lat: c.lat, lng: c.lng, adHoc: true, reason: why.trim());
    current.value = await _save(v);
    _resetForm(v);
    reload();
    AppToast.show('Ad-hoc visit logged · manager notified');
    Get.offNamed(Routes.meeting);
  }

  Future<void> completeFollowUp(FollowUp f) async {
    await _saveFollowUp(f.copyWith(done: true));
    reload();
    AppToast.show('Follow-up marked done ✓');
  }

  Future<void> pickFollowDate(BuildContext c) async {
    final d = await showDatePicker(context: c, initialDate: DateTime.now().add(const Duration(days: 3)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (d != null) followDate.value = isoDate(d);
  }
}
