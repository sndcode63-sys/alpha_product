class Attendance {
  final int? id;
  final int userId;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;
  final String? checkInAddress;
  final String? checkOutAddress;
  final String status;
  final double workingHours;
  final String? selfiePath;

  Attendance({
    this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.checkInAddress,
    this.checkOutAddress,
    required this.status,
    this.workingHours = 0,
    this.selfiePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_lat': checkInLat,
      'check_in_lng': checkInLng,
      'check_out_lat': checkOutLat,
      'check_out_lng': checkOutLng,
      'check_in_address': checkInAddress,
      'check_out_address': checkOutAddress,
      'status': status,
      'working_hours': workingHours,
      'selfie_path': selfiePath,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      userId: map['user_id'],
      date: map['date'],
      checkInTime: map['check_in_time'],
      checkOutTime: map['check_out_time'],
      checkInLat: map['check_in_lat'],
      checkInLng: map['check_in_lng'],
      checkOutLat: map['check_out_lat'],
      checkOutLng: map['check_out_lng'],
      checkInAddress: map['check_in_address'],
      checkOutAddress: map['check_out_address'],
      status: map['status'],
      workingHours: map['working_hours'] ?? 0,
      selfiePath: map['selfie_path'],
    );
  }
}
