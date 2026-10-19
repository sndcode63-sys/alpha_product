class Customer {
  final String id;
  final String name;
  final String category;
  final String contactPerson;
  final String phone;
  final String address;
  final String gst;
  final double outstanding;
  final String lastVisit;
  final double lat;
  final double lng;
  final String territory;
  const Customer({this.id='', this.name='', this.category='', this.contactPerson='', this.phone='', this.address='', this.gst='', this.outstanding=0, this.lastVisit='', this.lat=0, this.lng=0, this.territory=''});
  Customer copyWith({String? id, String? name, String? category, String? contactPerson, String? phone, String? address, String? gst, double? outstanding, String? lastVisit, double? lat, double? lng, String? territory}) => Customer(id: id ?? this.id, name: name ?? this.name, category: category ?? this.category, contactPerson: contactPerson ?? this.contactPerson, phone: phone ?? this.phone, address: address ?? this.address, gst: gst ?? this.gst, outstanding: outstanding ?? this.outstanding, lastVisit: lastVisit ?? this.lastVisit, lat: lat ?? this.lat, lng: lng ?? this.lng, territory: territory ?? this.territory);
}
