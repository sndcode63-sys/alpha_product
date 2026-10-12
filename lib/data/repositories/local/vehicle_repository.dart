import '../../../data/models/vehicle.dart';
import '../../../data/database/database_helper.dart';

class VehicleRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Get all vehicles
  Future<List<Vehicle>> getAllVehicles() async {
    final results = await _db.query('vehicles', orderBy: 'id DESC');
    return results.map((map) => Vehicle.fromMap(map)).toList();
  }

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(int id) async {
    final results = await _db.query(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Vehicle.fromMap(results.first);
    }
    return null;
  }

  // Update vehicle location
  Future<int> updateVehicleLocation(int id, double lat, double lng) async {
    return await _db.update(
      'vehicles',
      {
        'current_lat': lat,
        'current_lng': lng,
        'last_updated': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update vehicle status
  Future<int> updateVehicleStatus(int id, String status) async {
    return await _db.update(
      'vehicles',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Add new vehicle
  Future<int> addVehicle(Vehicle vehicle) async {
    return await _db.insert('vehicles', vehicle.toMap());
  }
}
