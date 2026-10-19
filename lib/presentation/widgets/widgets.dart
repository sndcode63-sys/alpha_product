import 'package:alpha_field_app/imports.dart';
import 'package:alpha_field_app/presentation/screens/common/in_app_map_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

// ───────────── layout ─────────────
class AppScaffold extends StatelessWidget {
  final String title, chip;
  final List<Widget> children;
  final Widget? footer;
  final bool nav, showBack;
  const AppScaffold({super.key, required this.title, required this.children, this.chip = 'ALL ROLES', this.footer, this.nav = false, this.showBack = true});

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: nav ? const RoleBottomNav() : null,
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 20), children: [
                Row(children: [
                  if (showBack && Navigator.of(context).canPop())
                    InkWell(onTap: Get.back, child: const Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.ink))),
                  RoleChip(chip),
                ]),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.ink, letterSpacing: -0.5)),
                const SizedBox(height: 16),
                for (final w in children) Padding(padding: const EdgeInsets.only(bottom: 12), child: w),
              ]),
            ),
            if (footer != null) Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 16), child: footer),
          ]),
        ),
      );
}

class RoleBottomNav extends StatelessWidget {
  const RoleBottomNav({super.key});
  @override
  Widget build(BuildContext context) {
    final sales = Get.find<AuthController>().isSales;
    final items = sales
        ? [('Home', Icons.home_outlined, Routes.salesHome), ('Visits', Icons.place_outlined, Routes.visitList), ('Follow-ups', Icons.event_note_outlined, Routes.followUps), ('Attendance', Icons.fingerprint, Routes.attendance), ('Profile', Icons.person_outline, Routes.profile)]
        : [('Trips', Icons.local_shipping_outlined, Routes.trips), ('Customers', Icons.store_outlined, Routes.custList), ('Orders', Icons.receipt_long_outlined, Routes.orderCreate), ('Attendance', Icons.fingerprint, Routes.attendance), ('Profile', Icons.person_outline, Routes.profile)];
    final i = items.indexWhere((e) => e.$3 == Get.currentRoute);
    final att = Get.find<AttendanceController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: i < 0 ? 0 : i,
        selectedItemColor: i < 0 ? AppColors.muted : AppColors.teal,
        unselectedItemColor: AppColors.muted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (k) {
          final targetRoute = items[k].$3;
          if (!att.checkedIn && targetRoute != Routes.attendance && targetRoute != Routes.profile) {
            AppToast.show('Pehle attendance check-in karein');
            if (Get.currentRoute != Routes.attendance) {
              Get.offNamed(Routes.attendance);
            }
            return;
          }
          if (targetRoute != Get.currentRoute) Get.offNamed(targetRoute);
        },
        items: [for (final e in items) BottomNavigationBarItem(icon: Icon(e.$2), label: e.$1)],
      ),
    );
  }
}

// ───────────── small pieces ─────────────
class RoleChip extends StatelessWidget {
  final String text;
  const RoleChip(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.mint,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.teal.withOpacity(0.18)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .8, color: AppColors.teal)),
      );
}

class InfoCard extends StatelessWidget {
  final String title, sub;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? child;
  const InfoCard(this.title, {super.key, this.sub = '', this.selected = false, this.onTap, this.child});
  @override
  Widget build(BuildContext context) => _Box(
        selected: selected,
        onTap: onTap,
        child: child ?? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.ink)),
          if (sub.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 3), child: Text(sub, style: const TextStyle(color: AppColors.muted, fontSize: 13))),
        ]),
      );
}

class RowCard extends StatelessWidget {
  final String title, sub, trailing;
  final bool selected;
  final VoidCallback? onTap;
  const RowCard(this.title, {super.key, this.sub = '', this.trailing = '', this.selected = false, this.onTap});
  @override
  Widget build(BuildContext context) => _Box(
        selected: selected,
        onTap: onTap,
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink)),
            if (sub.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 3), child: Text(sub, style: const TextStyle(color: AppColors.muted, fontSize: 12))),
          ])),
          if (trailing.isNotEmpty) Text(trailing, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
      );
}

class _Box extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback? onTap;
  const _Box({required this.child, required this.selected, this.onTap});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.teal : AppColors.line, width: selected ? 1.8 : 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      );
}

class StatBox extends StatelessWidget {
  final String value, label;
  final Color? color;
  const StatBox(this.value, this.label, {super.key, this.color});
  @override
  Widget build(BuildContext context) => _Box(
        selected: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color ?? AppColors.ink)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ]),
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool ghost;
  const PrimaryButton(this.label, this.onPressed, {super.key, this.ghost = false});
  @override
  Widget build(BuildContext context) => ghost
      ? OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: AppColors.teal, width: 1.5),
            foregroundColor: AppColors.teal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          child: Text(label))
      : FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.teal,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          child: Text(label),
        );
}

class FilterChips extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  const FilterChips(this.options, this.selected, this.onSelected, {super.key});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final o in options)
          ChoiceChip(
            label: Text(o),
            selected: o == selected,
            showCheckmark: false,
            selectedColor: AppColors.ink,
            backgroundColor: Colors.white,
            side: BorderSide(color: o == selected ? AppColors.ink : AppColors.line),
            labelStyle: TextStyle(color: o == selected ? Colors.white : AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600),
            onSelected: (_) => onSelected(o),
          ),
      ]);
}

class LabeledField extends StatelessWidget {
  final String label, hint;
  final TextEditingController? controller;
  final int lines;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  const LabeledField(this.label, {super.key, this.controller, this.hint = '', this.lines = 1, this.keyboard, this.onChanged, this.maxLength});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (label.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink))),
        TextField(controller: controller, maxLines: lines, keyboardType: keyboard, onChanged: onChanged, maxLength: maxLength, decoration: InputDecoration(hintText: hint, counterText: '')),
      ]);
}

class PhotoTile extends StatelessWidget {
  final String title, path;
  final VoidCallback onTap;
  const PhotoTile(this.title, this.path, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) {
    final has = path.isNotEmpty;
    final isFile = has && !path.startsWith('exception:');
    return InfoCard('', onTap: onTap, child: Row(children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(10), image: isFile ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover) : null),
        child: isFile ? null : const Icon(Icons.photo_camera_outlined, color: AppColors.teal),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(has ? '$title ✓' : title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(!has ? 'Tap to open camera' : (path.startsWith('exception:') ? 'Exception: ${path.substring(10)}' : 'Tap to retake'), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      ])),
    ]));
  }
}

class EmptyHint extends StatelessWidget {
  final String text;
  const EmptyHint(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 14))));
}

// ───────────── toast + dialogs ─────────────
class AppToast {
  static void show(String m) => Get.rawSnackbar(
        message: m, backgroundColor: AppColors.ink, snackPosition: SnackPosition.BOTTOM, borderRadius: 12,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 80), duration: const Duration(milliseconds: 2400));
}

class AppDialogs {
  static Future<bool> confirm({required String title, String text = '', String yes = 'Confirm', String no = 'Cancel'}) async =>
      (await Get.dialog<bool>(AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.ink)),
        content: text.isNotEmpty ? Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 14)) : null,
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(90, 42), side: const BorderSide(color: AppColors.line)),
            onPressed: () => Get.back(result: false),
            child: Text(no, style: const TextStyle(color: AppColors.ink)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 42), backgroundColor: AppColors.teal),
            onPressed: () => Get.back(result: true),
            child: Text(yes, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ))) == true;

  static Future<String?> input({required String title, String text = '', String hint = '', String yes = 'Send'}) {
    final c = TextEditingController();
    return Get.dialog<String>(AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.ink)),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (text.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 14))),
        TextField(controller: c, autofocus: true, decoration: InputDecoration(hintText: hint)),
      ]),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(90, 42), side: const BorderSide(color: AppColors.line)),
          onPressed: () => Get.back(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.ink)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(100, 42), backgroundColor: AppColors.teal),
          onPressed: () => Get.back(result: c.text.trim()),
          child: Text(yes, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ));
  }
}

// ───────────── GPS + maps ─────────────
Future<void> openMaps(double lat, double lng, {String title = 'Destination', String address = 'Location', String phone = ''}) async =>
    Get.to(() => InAppMapScreen(lat: lat, lng: lng, title: title, address: address, phone: phone));

Future<void> callNumber(String phone) => launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}'));

/// Asks for permission, reads GPS, shows the result dialog. Returns null if the user cancels.
Future<GeoFix?> captureGps() async {
  Get.dialog(const AlertDialog(
    backgroundColor: Colors.white,
    title: Text('Getting GPS fix…', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    content: Center(heightFactor: 1, child: CircularProgressIndicator(color: AppColors.teal)),
  ), barrierDismissible: false);

  final fix = await Get.find<LocationService>().currentFix();
  if (Get.isDialogOpen == true) Get.back();

  final ok = await Get.dialog<bool>(AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    title: const Text('Location captured', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.ink)),
    content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(fix.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
      const SizedBox(height: 6),
      Text(fix.live ? 'Live GPS from this device.' : 'GPS unavailable, using demo location (Patna).', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
    ]),
    actions: [
      OutlinedButton(
        style: OutlinedButton.styleFrom(minimumSize: const Size(110, 42), side: const BorderSide(color: AppColors.line)),
        onPressed: () => openMaps(fix.lat, fix.lng),
        child: const Text('Open in Maps', style: TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
      FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size(100, 42), backgroundColor: AppColors.teal),
        onPressed: () => Get.back(result: true),
        child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    ],
  ));
  return ok == true ? fix : null;
}

class MapView extends StatelessWidget {
  final LatLng center;
  final List<Marker> markers;
  final List<LatLng> route;
  final double zoom, height;
  final VoidCallback? onLocate, onOpen;
  const MapView({super.key, required this.center, this.markers = const [], this.route = const [], this.zoom = 13, this.height = 240, this.onLocate, this.onOpen});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: height,
          child: Stack(children: [
            FlutterMap(
              options: MapOptions(initialCenter: center, initialZoom: zoom),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.alpha.fieldapp'),
                if (route.length > 1) PolylineLayer(polylines: [Polyline(points: route, strokeWidth: 5, color: AppColors.teal)]),
                MarkerLayer(markers: markers),
              ],
            ),
            if (onLocate != null) Positioned(right: 8, top: 8, child: FloatingActionButton.small(heroTag: null, backgroundColor: Colors.white, foregroundColor: AppColors.teal, onPressed: onLocate, child: const Icon(Icons.my_location))),
            if (onOpen != null) Positioned(left: 8, bottom: 8, child: FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(0, 36), backgroundColor: AppColors.teal, padding: const EdgeInsets.symmetric(horizontal: 12)), onPressed: onOpen, child: const Text('Open in Maps', style: TextStyle(fontSize: 12)))),
          ]),
        ),
      );
}

Marker pin(LatLng p, {String? label, Color color = AppColors.red}) => Marker(
      point: p, width: 36, height: 36,
      child: label == null
          ? Icon(Icons.location_on, color: color, size: 36)
          : CircleAvatar(backgroundColor: color, child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12))),
    );
