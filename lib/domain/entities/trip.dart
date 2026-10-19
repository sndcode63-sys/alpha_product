class Trip {
  final String id;
  final String vehicle;
  final String status;
  final int stopCount;
  final int doneCount;
  final String date;
  final double distanceKm;
  final double odoStart;
  final double odoEnd;
  const Trip({this.id='', this.vehicle='', this.status='', this.stopCount=0, this.doneCount=0, this.date='', this.distanceKm=0, this.odoStart=0, this.odoEnd=0});
  Trip copyWith({String? id, String? vehicle, String? status, int? stopCount, int? doneCount, String? date, double? distanceKm, double? odoStart, double? odoEnd}) => Trip(id: id ?? this.id, vehicle: vehicle ?? this.vehicle, status: status ?? this.status, stopCount: stopCount ?? this.stopCount, doneCount: doneCount ?? this.doneCount, date: date ?? this.date, distanceKm: distanceKm ?? this.distanceKm, odoStart: odoStart ?? this.odoStart, odoEnd: odoEnd ?? this.odoEnd);
}
