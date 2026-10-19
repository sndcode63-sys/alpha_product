class Visit {
  final String id;
  final String customerId;
  final String customerName;
  final String category;
  final String address;
  final String purpose;
  final String status;
  final String priority;
  final String date;
  final String arrivalAt;
  final String endAt;
  final String contactMet;
  final String summary;
  final String products;
  final double orderPotential;
  final String outcome;
  final String nextAction;
  final String followUpDate;
  final String selfiePath;
  final double lat;
  final double lng;
  final String gpsNote;
  final bool adHoc;
  final String reason;
  const Visit({this.id='', this.customerId='', this.customerName='', this.category='', this.address='', this.purpose='', this.status='', this.priority='', this.date='', this.arrivalAt='', this.endAt='', this.contactMet='', this.summary='', this.products='', this.orderPotential=0, this.outcome='', this.nextAction='', this.followUpDate='', this.selfiePath='', this.lat=0, this.lng=0, this.gpsNote='', this.adHoc=false, this.reason=''});
  Visit copyWith({String? id, String? customerId, String? customerName, String? category, String? address, String? purpose, String? status, String? priority, String? date, String? arrivalAt, String? endAt, String? contactMet, String? summary, String? products, double? orderPotential, String? outcome, String? nextAction, String? followUpDate, String? selfiePath, double? lat, double? lng, String? gpsNote, bool? adHoc, String? reason}) => Visit(id: id ?? this.id, customerId: customerId ?? this.customerId, customerName: customerName ?? this.customerName, category: category ?? this.category, address: address ?? this.address, purpose: purpose ?? this.purpose, status: status ?? this.status, priority: priority ?? this.priority, date: date ?? this.date, arrivalAt: arrivalAt ?? this.arrivalAt, endAt: endAt ?? this.endAt, contactMet: contactMet ?? this.contactMet, summary: summary ?? this.summary, products: products ?? this.products, orderPotential: orderPotential ?? this.orderPotential, outcome: outcome ?? this.outcome, nextAction: nextAction ?? this.nextAction, followUpDate: followUpDate ?? this.followUpDate, selfiePath: selfiePath ?? this.selfiePath, lat: lat ?? this.lat, lng: lng ?? this.lng, gpsNote: gpsNote ?? this.gpsNote, adHoc: adHoc ?? this.adHoc, reason: reason ?? this.reason);
}
