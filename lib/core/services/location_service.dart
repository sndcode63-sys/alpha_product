import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GeoFix {
  final double lat, lng, accuracy;
  final bool live;
  const GeoFix(this.lat, this.lng, this.accuracy, this.live);
  String get label => '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)} ±${accuracy.round()} m';
}

class LocationService extends GetxService {
  /// Used when permission is denied or GPS is off (Patna).
  static const demo = GeoFix(25.5941, 85.1376, 12, false);

  Future<GeoFix> currentFix() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return demo;
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return demo;
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 8)),
      );
      return GeoFix(pos.latitude, pos.longitude, pos.accuracy, true);
    } catch (_) {
      return demo;
    }
  }
}
