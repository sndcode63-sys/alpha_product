class DeliveryStop {
  final String id;
  final String tripId;
  final int seq;
  final String customer;
  final String address;
  final String phone;
  final int items;
  final int delivered;
  final String status;
  final double lat;
  final double lng;
  final String instructions;
  final String reason;
  final String photoPath;
  final String signature;
  final String arrivedAt;
  const DeliveryStop({this.id='', this.tripId='', this.seq=0, this.customer='', this.address='', this.phone='', this.items=0, this.delivered=0, this.status='', this.lat=0, this.lng=0, this.instructions='', this.reason='', this.photoPath='', this.signature='', this.arrivedAt=''});
  DeliveryStop copyWith({String? id, String? tripId, int? seq, String? customer, String? address, String? phone, int? items, int? delivered, String? status, double? lat, double? lng, String? instructions, String? reason, String? photoPath, String? signature, String? arrivedAt}) => DeliveryStop(id: id ?? this.id, tripId: tripId ?? this.tripId, seq: seq ?? this.seq, customer: customer ?? this.customer, address: address ?? this.address, phone: phone ?? this.phone, items: items ?? this.items, delivered: delivered ?? this.delivered, status: status ?? this.status, lat: lat ?? this.lat, lng: lng ?? this.lng, instructions: instructions ?? this.instructions, reason: reason ?? this.reason, photoPath: photoPath ?? this.photoPath, signature: signature ?? this.signature, arrivedAt: arrivedAt ?? this.arrivedAt);
}
