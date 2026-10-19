class AttendanceRecord {
  final String id;
  final String date;
  final String checkIn;
  final String checkOut;
  final double lat;
  final double lng;
  final String selfiePath;
  const AttendanceRecord({this.id='', this.date='', this.checkIn='', this.checkOut='', this.lat=0, this.lng=0, this.selfiePath=''});
  AttendanceRecord copyWith({String? id, String? date, String? checkIn, String? checkOut, double? lat, double? lng, String? selfiePath}) => AttendanceRecord(id: id ?? this.id, date: date ?? this.date, checkIn: checkIn ?? this.checkIn, checkOut: checkOut ?? this.checkOut, lat: lat ?? this.lat, lng: lng ?? this.lng, selfiePath: selfiePath ?? this.selfiePath);
}
