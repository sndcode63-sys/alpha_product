import '../../domain/entities/entities.dart';

class TripModel extends Trip {
  const TripModel({super.id='', super.vehicle='', super.status='', super.stopCount=0, super.doneCount=0, super.date='', super.distanceKm=0, super.odoStart=0, super.odoEnd=0});
  factory TripModel.fromEntity(Trip e) => TripModel(id: e.id, vehicle: e.vehicle, status: e.status, stopCount: e.stopCount, doneCount: e.doneCount, date: e.date, distanceKm: e.distanceKm, odoStart: e.odoStart, odoEnd: e.odoEnd);
  factory TripModel.fromJson(Map<String, dynamic> j) => TripModel(id: (j['id']??'').toString(), vehicle: (j['vehicle']??'').toString(), status: (j['status']??'').toString(), stopCount: ((j['stopCount']??0) as num).toInt(), doneCount: ((j['doneCount']??0) as num).toInt(), date: (j['date']??'').toString(), distanceKm: ((j['distanceKm']??0) as num).toDouble(), odoStart: ((j['odoStart']??0) as num).toDouble(), odoEnd: ((j['odoEnd']??0) as num).toDouble());
  Map<String, dynamic> toJson() => {'id': id, 'vehicle': vehicle, 'status': status, 'stopCount': stopCount, 'doneCount': doneCount, 'date': date, 'distanceKm': distanceKm, 'odoStart': odoStart, 'odoEnd': odoEnd};
}
