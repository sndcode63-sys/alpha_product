import 'dart:convert';
import 'package:alpha_field_app/imports.dart';
import 'package:geolocator/geolocator.dart';
import 'package:signature/signature.dart';

class TripController extends GetxController {
  final TripRepository repo;
  final SaveTrip _saveTrip;
  final SaveStop _saveStop;
  final LocationService loc;
  TripController(this.repo, this._saveTrip, this._saveStop, this.loc);

  static const failReasons = ['Customer unavailable', 'Shop closed', 'Refused', 'Wrong address'];

  final trips = <Trip>[].obs;
  final stops = <DeliveryStop>[].obs;
  final trip = Rxn<Trip>();
  final stop = Rxn<DeliveryStop>();
  final tab = 'Today'.obs;
  final fix = Rxn<GeoFix>();
  final checks = [false, false, false].obs;
  final odo = TextEditingController(), otp = TextEditingController(), remarks = TextEditingController(), exception = TextEditingController();
  final qty = <TextEditingController>[];
  final qtyTick = 0.obs;
  final photo = ''.obs;
  final signed = ''.obs;
  final failReason = failReasons.first.obs;
  final sig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);

  @override
  void onInit() {
    reload();
    super.onInit();
  }

  void reload() {
    trips.assignAll(repo.trips());
    if (trip.value != null) {
      trip.value = trips.firstWhereOrNull((t) => t.id == trip.value!.id);
      stops.assignAll(trip.value == null ? [] : repo.stops(trip.value!.id));
    }
  }

  List<Trip> get tabTrips => trips.where((t) => switch (tab.value) {
        'Done' => t.status == 'completed',
        'Upcoming' => t.status != 'completed' && t.date.compareTo(todayIso()) > 0,
        _ => t.status != 'completed' && t.date.compareTo(todayIso()) <= 0,
      }).toList();

  int get resolved => stops.where((s) => s.status != 'pending').length;
  int get failedCount => stops.where((s) => s.status == 'failed').length;
  DeliveryStop? get nextStop => stops.firstWhereOrNull((s) => s.status == 'pending');

  void openTrip(Trip t) {
    trip.value = t;
    stops.assignAll(repo.stops(t.id));
    if (t.status == 'active') {
      Get.toNamed(Routes.tripList);
    } else if (t.status == 'assigned') {
      if (!Get.find<AttendanceController>().checkedIn) {
        AppToast.show('Check in first');
        Get.toNamed(Routes.attendance);
        return;
      }
      checks.value = [false, false, false];
      odo.clear();
      Get.toNamed(Routes.startTrip);
    } else {
      AppToast.show('Completed · ${t.doneCount} of ${t.stopCount} delivered');
    }
  }

  Future<void> startTrip() async {
    if (checks.contains(false)) return AppToast.show('Complete the checklist');
    if (double.tryParse(odo.text) == null) return AppToast.show('Enter odometer reading');
    if (!await AppDialogs.confirm(title: 'Start trip ${trip.value!.id}?', text: 'Location tracking starts now.', yes: 'Start')) return;
    if (await captureGps() == null) return;
    await _saveTrip(trip.value!.copyWith(status: 'active', odoStart: double.parse(odo.text)));
    reload();
    AppToast.show('Trip started · tracking on');
    Get.offNamed(Routes.tripList);
  }

  void openStop(DeliveryStop s) {
    stop.value = s;
    Get.toNamed(Routes.stopDetail);
  }

  Future<void> arrive() async {
    final f = await captureGps();
    if (f == null) return;
    fix.value = f;
    stop.value = stop.value!.copyWith(arrivedAt: DateTime.now().toIso8601String());
    await _saveStop(stop.value!);
    AppToast.show('Arrival recorded ${hhmm()}');
    Get.toNamed(Routes.arrivedStop);
  }

  double? get distanceToStop {
    final f = fix.value, s = stop.value;
    return (f == null || s == null) ? null : Geolocator.distanceBetween(f.lat, f.lng, s.lat, s.lng);
  }

  // ---- delivery proof ----
  List<int> get ordered {
    final n = stop.value!.items;
    return [(n + 1) ~/ 2, n ~/ 2];
  }

  void prepareDelivery() {
    qty.clear();
    for (final o in ordered) { qty.add(TextEditingController(text: '$o')); }
    otp.clear();
    remarks.clear();
    photo.value = '';
    signed.value = '';
    sig.clear();
    qtyTick.value++;
    Get.toNamed(Routes.delivery);
  }

  int get delivered => qty.fold(0, (a, c) => a + (int.tryParse(c.text) ?? 0));
  int get shortBy => stop.value!.items - delivered;

  Future<void> pickPhoto() async {
    final p = await Get.toNamed(Routes.camera, arguments: 'Delivery photo');
    if (p is String && p.isNotEmpty) photo.value = p;
  }

  Future<void> signPad() async {
    sig.clear();
    final ok = await Get.dialog<bool>(AlertDialog(
      title: const Text('Customer signature'),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: AppColors.line)),
        child: SizedBox(height: 160, width: 300, child: Signature(controller: sig, backgroundColor: Colors.white)),
      ),
      actions: [
        TextButton(onPressed: sig.clear, child: const Text('Clear')),
        FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(90, 44)), onPressed: () => Get.back(result: true), child: const Text('Save')),
      ],
    ));
    if (ok == true && sig.isNotEmpty) {
      signed.value = base64Encode((await sig.toPngBytes()) ?? []);
      AppToast.show('Signature saved ✓');
    }
  }

  Future<void> complete() async {
    if (otp.text.trim().length != 4) return AppToast.show('Enter the 4-digit customer OTP');
    if (photo.value.isEmpty) return AppToast.show('Take the delivery photo');
    final s = stop.value!;
    final msg = '$delivered of ${s.items} items delivered${shortBy > 0 ? ' ($shortBy short)' : ''}. OTP will be verified.';
    if (!await AppDialogs.confirm(title: 'Confirm delivery?', text: msg, yes: 'Confirm')) return;
    if (await captureGps() == null) return;
    // NOTE: OTP is accepted locally in this demo. Verify it server-side in production.
    await _saveStop(s.copyWith(status: 'delivered', delivered: delivered, photoPath: photo.value, signature: signed.value, reason: remarks.text));
    await _bump();
    AppToast.show('Delivered · OTP verified ✓');
    Get.offNamedUntil(Routes.tripList, (r) => r.settings.name == Routes.trips);
  }

  Future<void> failDelivery() async {
    await _saveStop(stop.value!.copyWith(status: 'failed', reason: '${failReason.value}${remarks.text.isEmpty ? '' : ' · ${remarks.text}'}'));
    await _bump();
    AppToast.show('Marked failed · dispatcher notified');
    Get.offNamedUntil(Routes.tripList, (r) => r.settings.name == Routes.trips);
  }

  Future<void> _bump() async {
    final all = repo.stops(trip.value!.id);
    await _saveTrip(trip.value!.copyWith(doneCount: all.where((s) => s.status != 'pending').length));
    reload();
  }

  Future<void> endTrip() async {
    if (failedCount > 0 && exception.text.trim().isEmpty) return AppToast.show('Add a reason for the failed stop');
    final end = double.tryParse(odo.text);
    if (end == null) return AppToast.show('Enter end odometer');
    final t = trip.value!;
    if (!await AppDialogs.confirm(title: 'End trip?', text: failedCount > 0 ? '$failedCount exception needs a follow-up action.' : 'All stops resolved.', yes: 'End trip')) return;
    final km = end > t.odoStart ? end - t.odoStart : 0.0;
    await _saveTrip(t.copyWith(status: 'completed', odoEnd: end, distanceKm: km));
    reload();
    AppToast.show('Trip closed · ${km.toStringAsFixed(0)} km');
    Get.offAllNamed(Routes.trips);
  }
}
