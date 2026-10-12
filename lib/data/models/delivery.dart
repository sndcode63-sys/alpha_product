class Delivery {
  final int? id;
  final String deliveryNumber;
  final int customerId;
  final int userId;
  final int? vehicleId;
  final String status;
  final String address;
  final double? lat;
  final double? lng;
  final String assignedDate;
  final String? deliveredDate;
  final String? deliveryPhotoPath;
  final String? signaturePath;
  final String? notes;

  Delivery({
    this.id,
    required this.deliveryNumber,
    required this.customerId,
    required this.userId,
    this.vehicleId,
    required this.status,
    required this.address,
    this.lat,
    this.lng,
    required this.assignedDate,
    this.deliveredDate,
    this.deliveryPhotoPath,
    this.signaturePath,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'delivery_number': deliveryNumber,
      'customer_id': customerId,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'status': status,
      'address': address,
      'lat': lat,
      'lng': lng,
      'assigned_date': assignedDate,
      'delivered_date': deliveredDate,
      'delivery_photo_path': deliveryPhotoPath,
      'signature_path': signaturePath,
      'notes': notes,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'],
      deliveryNumber: map['delivery_number'],
      customerId: map['customer_id'],
      userId: map['user_id'],
      vehicleId: map['vehicle_id'],
      status: map['status'],
      address: map['address'],
      lat: map['lat'],
      lng: map['lng'],
      assignedDate: map['assigned_date'],
      deliveredDate: map['delivered_date'],
      deliveryPhotoPath: map['delivery_photo_path'],
      signaturePath: map['signature_path'],
      notes: map['notes'],
    );
  }
}
