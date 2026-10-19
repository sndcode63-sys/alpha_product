import 'package:alpha_field_app/imports.dart';
import 'package:latlong2/latlong.dart';

class ArrivalScreen extends GetView<VisitController> {
  const ArrivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final v = controller.current.value;
      if (v == null) return const AppScaffold(title: 'Arrival', children: [EmptyHint('No visit selected')]);
      final shop = LatLng(v.lat, v.lng);
      final me = controller.fix.value;
      final d = controller.distance;
      return AppScaffold(
        title: v.customerName,
        chip: 'SALES ROLE',
        footer: Column(mainAxisSize: MainAxisSize.min, children: [
          PrimaryButton('I have arrived · Start Meeting', controller.arrive),
          const SizedBox(height: 8),
          PrimaryButton('Outside the area? Add reason', controller.arriveOutside, ghost: true),
        ]),
        children: [
          Text('${v.category} · ${v.address}', style: const TextStyle(color: AppColors.muted)),
          MapView(
            center: shop,
            markers: [pin(shop), if (me != null) pin(LatLng(me.lat, me.lng), color: Colors.blue)],
            onLocate: () => Get.find<LocationService>().currentFix().then((f) => controller.fix.value = f),
            onOpen: () => openMaps(v.lat, v.lng),
          ),
          RowCard(me == null ? 'Getting your location…' : 'GPS accuracy ${me.accuracy.round()} m', sub: d == null ? '' : 'You are ${d.round()} m from the shop', trailing: d == null ? '' : (d < 150 ? 'Inside area' : 'Outside area')),
        ],
      );
    });
  }
}
