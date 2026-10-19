import 'package:alpha_field_app/imports.dart';
import 'package:latlong2/latlong.dart';

class RouteMapScreen extends GetView<TripController> {
  const RouteMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stops = controller.stops;
      final next = controller.nextStop;
      final pts = [for (final s in stops) LatLng(s.lat, s.lng)];
      return AppScaffold(
        title: 'Route',
        chip: 'DRIVER ROLE',
        nav: true,
        children: [
          MapView(
            center: pts.isEmpty ? const LatLng(25.5941, 85.1376) : pts[pts.length ~/ 2],
            zoom: 12,
            height: 320,
            route: pts,
            markers: [for (final s in stops) pin(LatLng(s.lat, s.lng), label: '${s.seq}', color: s.id == next?.id ? AppColors.red : (s.status == 'pending' ? AppColors.ink : AppColors.teal))],
            onLocate: () => Get.find<LocationService>().currentFix().then((f) => AppToast.show('You · ${f.label}')),
            onOpen: next == null ? null : () => openMaps(next.lat, next.lng),
          ),
          if (next != null) RowCard('Next: ${next.customer}', sub: next.address, trailing: 'Stop ${next.seq}', onTap: () => controller.openStop(next)),
          if (next != null) PrimaryButton('Open navigation', () => openMaps(next.lat, next.lng)),
          if (next != null) PrimaryButton('Call customer', () => callNumber(next.phone), ghost: true),
        ],
      );
    });
  }
}
