import '../../domain/entities/entities.dart';

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({super.id='', super.date='', super.checkIn='', super.checkOut='', super.lat=0, super.lng=0, super.selfiePath=''});
  factory AttendanceRecordModel.fromEntity(AttendanceRecord e) => AttendanceRecordModel(id: e.id, date: e.date, checkIn: e.checkIn, checkOut: e.checkOut, lat: e.lat, lng: e.lng, selfiePath: e.selfiePath);
  factory AttendanceRecordModel.fromJson(Map<String, dynamic> j) => AttendanceRecordModel(id: (j['id']??'').toString(), date: (j['date']??'').toString(), checkIn: (j['checkIn']??'').toString(), checkOut: (j['checkOut']??'').toString(), lat: ((j['lat']??0) as num).toDouble(), lng: ((j['lng']??0) as num).toDouble(), selfiePath: (j['selfiePath']??'').toString());
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'checkIn': checkIn, 'checkOut': checkOut, 'lat': lat, 'lng': lng, 'selfiePath': selfiePath};
}
