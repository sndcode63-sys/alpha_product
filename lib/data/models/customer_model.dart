import '../../domain/entities/entities.dart';

class CustomerModel extends Customer {
  const CustomerModel({super.id='', super.name='', super.category='', super.contactPerson='', super.phone='', super.address='', super.gst='', super.outstanding=0, super.lastVisit='', super.lat=0, super.lng=0, super.territory=''});
  factory CustomerModel.fromEntity(Customer e) => CustomerModel(id: e.id, name: e.name, category: e.category, contactPerson: e.contactPerson, phone: e.phone, address: e.address, gst: e.gst, outstanding: e.outstanding, lastVisit: e.lastVisit, lat: e.lat, lng: e.lng, territory: e.territory);
  factory CustomerModel.fromJson(Map<String, dynamic> j) => CustomerModel(id: (j['id']??'').toString(), name: (j['name']??'').toString(), category: (j['category']??'').toString(), contactPerson: (j['contactPerson']??'').toString(), phone: (j['phone']??'').toString(), address: (j['address']??'').toString(), gst: (j['gst']??'').toString(), outstanding: ((j['outstanding']??0) as num).toDouble(), lastVisit: (j['lastVisit']??'').toString(), lat: ((j['lat']??0) as num).toDouble(), lng: ((j['lng']??0) as num).toDouble(), territory: (j['territory']??'').toString());
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'category': category, 'contactPerson': contactPerson, 'phone': phone, 'address': address, 'gst': gst, 'outstanding': outstanding, 'lastVisit': lastVisit, 'lat': lat, 'lng': lng, 'territory': territory};
}
