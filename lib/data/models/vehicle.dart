class Vehicle {
  final int? id;
  final String plateNumber;
  final String model;
  final String type;
  final String status;
  final double? currentLat;
  final double? currentLng;
  final int fuelLevel;
  final String? lastUpdated;

  Vehicle({
    this.id,
    required this.plateNumber,
    required this.model,
    required this.type,
    required this.status,
    this.currentLat,
    this.currentLng,
    this.fuelLevel = 100,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plate_number': plateNumber,
      'model': model,
      'type': type,
      'status': status,
      'current_lat': currentLat,
      'current_lng': currentLng,
      'fuel_level': fuelLevel,
      'last_updated': lastUpdated,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      plateNumber: map['plate_number'],
      model: map['model'],
      type: map['type'],
      status: map['status'],
      currentLat: map['current_lat'],
      currentLng: map['current_lng'],
      fuelLevel: map['fuel_level'] ?? 100,
      lastUpdated: map['last_updated'],
    );
  }
}
