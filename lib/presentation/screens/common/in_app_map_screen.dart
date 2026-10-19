import 'package:alpha_field_app/imports.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InAppMapScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final String title;
  final String address;
  final String phone;

  const InAppMapScreen({
    super.key,
    required this.lat,
    required this.lng,
    this.title = 'Destination',
    this.address = 'Patna, Bihar',
    this.phone = '',
  });

  @override
  State<InAppMapScreen> createState() => _InAppMapScreenState();
}

class _InAppMapScreenState extends State<InAppMapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(25.5941, 85.1376); // Default Patna
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final fix = await Get.find<LocationService>().currentFix();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(fix.lat, fix.lng);
          _loadingLocation = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _centerOnMyLocation() {
    _mapController.move(_currentLocation, 14);
    AppToast.show('Centered on current location');
  }

  void _centerOnDestination() {
    _mapController.move(LatLng(widget.lat, widget.lng), 14);
  }

  @override
  Widget build(BuildContext context) {
    final dest = LatLng(widget.lat, widget.lng);
    final routePoints = [_currentLocation, dest];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Interactive FlutterMap
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: dest,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.alpha.fieldapp',
                      ),
                      // Route Polyline
                      if (routePoints.length > 1)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              strokeWidth: 4.5,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      // Markers
                      MarkerLayer(
                        markers: [
                          // Destination Pin
                          Marker(
                            point: dest,
                            width: 44,
                            height: 44,
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.red,
                              size: 44,
                            ),
                          ),
                          // Current GPS Pin
                          Marker(
                            point: _currentLocation,
                            width: 36,
                            height: 36,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Floating Map Action Buttons
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'locate_btn',
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 3,
                          onPressed: _centerOnMyLocation,
                          child: const Icon(Icons.my_location),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'dest_btn',
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.red,
                          elevation: 3,
                          onPressed: _centerOnDestination,
                          child: const Icon(Icons.place),
                        ),
                      ],
                    ),
                  ),

                  if (_loadingLocation)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            ),
                            SizedBox(width: 8),
                            Text('Fetching live GPS...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Navigation & Info Sheet Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.address,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.phone.isNotEmpty) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              side: const BorderSide(color: AppColors.line),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => callNumber(widget.phone),
                            icon: const Icon(Icons.phone, size: 18, color: AppColors.primary),
                            label: const Text('Call', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            AppToast.show('In-App Navigation Active');
                          },
                          child: const Text(
                            'In-App Route Active',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
