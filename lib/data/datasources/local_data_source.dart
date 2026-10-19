import '../../core/core.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';

class K {
  static const employees = 'employees', session = 'session', attendance = 'attendance', customers = 'customers',
      visits = 'visits', followUps = 'followUps', orders = 'orders', trips = 'trips', stops = 'stops',
      notifications = 'notifications', sync = 'sync', fieldActive = 'fieldActive', seeded = 'seeded';
}

/// All reads/writes go through here, so swapping to an API later only touches the data layer.
class LocalDataSource {
  final StorageService s;
  LocalDataSource(this.s);

  List<Map<String, dynamic>> list(String k) => s.readList(k);
  Future<void> put(String k, List<Map<String, dynamic>> v) => s.write(k, v);

  Future<void> upsert(String k, Map<String, dynamic> item) async {
    final l = list(k);
    final i = l.indexWhere((e) => e['id'] == item['id']);
    i >= 0 ? l[i] = item : l.add(item);
    await put(k, l);
  }

  Future<void> seed() async {
    if (s.read<bool>(K.seeded) == true) return;
    final now = DateTime.now();
    String d(int o) => isoDate(now.add(Duration(days: o)));
    String at(int o, int h, int m) => DateTime(now.year, now.month, now.day + o, h, m).toIso8601String();

    await put(K.employees, [
      const Employee(id: 'E1', name: 'Rahul Kumar', phone: '+91 98765 43210', empCode: 'EMP-0123', role: 'sales', manager: 'Anil Sinha', territory: 'Patna Central'),
      const Employee(id: 'E2', name: 'Sunil Yadav', phone: '+91 98765 11122', empCode: 'EMP-0456', role: 'driver', manager: 'Anil Sinha', territory: 'Patna Delivery'),
    ].map((e) => EmployeeModel.fromEntity(e).toJson()).toList());

    await put(K.customers, [
      const Customer(id: 'C1', name: 'Shree Ganesh Traders', category: 'Retailer', contactPerson: 'Mr. Sunil Gupta', phone: '+91 98765 00112', address: 'Boring Road, Patna 800001', gst: '10ABCDE1234F1Z5', outstanding: 12400, lastVisit: '12 Oct', lat: 25.6039, lng: 85.1180, territory: 'Patna Central'),
      const Customer(id: 'C2', name: 'Maurya Distributors', category: 'Distributor', contactPerson: 'Mr. Maurya', phone: '+91 98765 00113', address: 'Kankarbagh, Patna', gst: '10ABCDE2234F1Z5', outstanding: 0, lastVisit: '10 Oct', lat: 25.5870, lng: 85.1730, territory: 'Patna Central'),
      const Customer(id: 'C3', name: 'Kumar Packaging', category: 'Vendor', contactPerson: 'Mr. Kumar', phone: '+91 98765 00114', address: 'Digha, Patna', lat: 25.6330, lng: 85.0950, territory: 'Patna West'),
      const Customer(id: 'C4', name: 'Raj General Store', category: 'Retailer', contactPerson: 'Mr. Raj Verma', phone: '+91 99000 11223', address: 'Patliputra, Patna', gst: '10ABCDE3234F1Z5', outstanding: 3200, lastVisit: '11 Oct', lat: 25.6120, lng: 85.1050, territory: 'Patna West'),
      const Customer(id: 'C5', name: 'Bihar Agencies', category: 'Distributor', contactPerson: 'Mr. Singh', phone: '+91 98765 00115', address: 'Danapur, Patna', outstanding: 8900, lat: 25.6300, lng: 85.0420, territory: 'Patna West'),
    ].map((e) => CustomerModel.fromEntity(e).toJson()).toList());

    await put(K.visits, [
      Visit(id: 'V1', customerId: 'C1', customerName: 'Shree Ganesh Traders', category: 'Retailer', address: 'Boring Road, Patna', purpose: 'Order collection', status: 'planned', priority: 'High', date: d(0), lat: 25.6039, lng: 85.1180),
      Visit(id: 'V2', customerId: 'C2', customerName: 'Maurya Distributors', category: 'Distributor', address: 'Kankarbagh, Patna', purpose: 'Payment follow-up', status: 'planned', priority: 'Normal', date: d(0), lat: 25.5870, lng: 85.1730),
      Visit(id: 'V3', customerId: 'C3', customerName: 'Kumar Packaging', category: 'Vendor', address: 'Digha, Patna', purpose: 'Product introduction', status: 'pending_sync', priority: 'Normal', date: d(0), lat: 25.6330, lng: 85.0950),
      Visit(id: 'V4', customerId: 'C4', customerName: 'Raj General Store', category: 'Retailer', address: 'Patliputra, Patna', purpose: 'Order collection', status: 'closed', date: d(-1), arrivalAt: at(-1, 11, 10), endAt: at(-1, 11, 29), contactMet: 'Mr. Raj Verma', outcome: 'Order received', summary: 'Order for 20 cartons.', lat: 25.6120, lng: 85.1050),
      Visit(id: 'V5', customerId: 'C5', customerName: 'Bihar Agencies', category: 'Distributor', address: 'Danapur, Patna', purpose: 'Relationship visit', status: 'unsuccessful', date: d(-2), outcome: 'Unavailable', lat: 25.6300, lng: 85.0420),
    ].map((e) => VisitModel.fromEntity(e).toJson()).toList());

    await put(K.followUps, [
      FollowUp(id: 'F1', visitId: 'V4', customerName: 'Raj General Store', action: 'Send quotation', dueDate: d(-3)),
      FollowUp(id: 'F2', visitId: 'V5', customerName: 'Bihar Agencies', action: 'Call back', dueDate: d(-1)),
      FollowUp(id: 'F3', visitId: 'V1', customerName: 'Shree Ganesh Traders', action: 'Share samples', dueDate: d(0)),
      FollowUp(id: 'F4', visitId: 'V2', customerName: 'Maurya Distributors', action: 'Revisit', dueDate: d(4)),
    ].map((e) => FollowUpModel.fromEntity(e).toJson()).toList());

    await put(K.trips, [
      Trip(id: 'T-1042', vehicle: 'BR01 AB 2345', status: 'assigned', stopCount: 6, date: d(0)),
      Trip(id: 'T-1043', vehicle: 'BR01 AB 2345', status: 'assigned', stopCount: 2, date: d(1)),
      Trip(id: 'T-1039', vehicle: 'BR01 AB 2345', status: 'completed', stopCount: 2, doneCount: 2, date: d(-3), distanceKm: 61),
    ].map((e) => TripModel.fromEntity(e).toJson()).toList());

    DeliveryStop st(String id, String trip, int seq, String c, String a, int items, double la, double lo, {String status = 'pending'}) =>
        DeliveryStop(id: id, tripId: trip, seq: seq, customer: c, address: a, phone: '+91 99000 1122$seq', items: items, status: status, lat: la, lng: lo, instructions: 'Call before arrival. Deliver at the back gate.');
    await put(K.stops, [
      st('S1', 'T-1042', 1, 'Sharma Stores', 'Ashok Rajpath, Patna', 12, 25.6190, 85.1590),
      st('S2', 'T-1042', 2, 'Anand Mart', 'Kankarbagh, Patna', 8, 25.5870, 85.1730),
      st('S3', 'T-1042', 3, 'Raj General Store', 'Patliputra, Patna', 20, 25.6120, 85.1050),
      st('S4', 'T-1042', 4, 'Bihar Agencies', 'Danapur, Patna', 15, 25.6300, 85.0420),
      st('S5', 'T-1042', 5, 'Shree Ganesh Traders', 'Boring Road, Patna', 10, 25.6039, 85.1180),
      st('S6', 'T-1042', 6, 'Kumar Packaging', 'Digha, Patna', 6, 25.6330, 85.0950),
      st('S7', 'T-1043', 1, 'Maurya Distributors', 'Kankarbagh, Patna', 14, 25.5870, 85.1730),
      st('S8', 'T-1043', 2, 'Anand Mart', 'Kankarbagh, Patna', 9, 25.5880, 85.1700),
      st('S9', 'T-1039', 1, 'Sharma Stores', 'Ashok Rajpath, Patna', 10, 25.6190, 85.1590, status: 'delivered'),
      st('S10', 'T-1039', 2, 'Raj General Store', 'Patliputra, Patna', 11, 25.6120, 85.1050, status: 'delivered'),
    ].map((e) => DeliveryStopModel.fromEntity(e).toJson()).toList());

    await put(K.attendance, [
      for (var i = 1; i <= 5; i++)
        AttendanceRecord(id: 'A$i', date: d(-i), checkIn: at(-i, 9, 10 + i), checkOut: at(-i, 18, i), lat: 25.59, lng: 85.13),
    ].map((e) => AttendanceRecordModel.fromEntity(e).toJson()).toList());

    await put(K.notifications, [
      const AppNotification(id: 'N1', title: 'New visit assigned', body: 'Maurya Distributors · today', time: '09:02', route: '/visit-list'),
      const AppNotification(id: 'N2', title: 'Follow-up due today', body: 'Shree Ganesh Traders · Share samples', time: '08:30', route: '/follow-ups'),
      const AppNotification(id: 'N3', title: 'Trip T-1042 assigned', body: '6 stops · Vehicle BR01 AB 2345', time: 'Yesterday', route: '/trips'),
      const AppNotification(id: 'N4', title: 'Attendance reminder', body: 'Remember to check out', time: 'Yesterday', route: '/attendance'),
    ].map((e) => AppNotificationModel.fromEntity(e).toJson()).toList());

    await put(K.sync, [
      const SyncItem(id: 'Y1', label: 'Visit · Kumar Packaging', detail: 'Meeting report', status: 'pending'),
      const SyncItem(id: 'Y2', label: 'Selfie upload', detail: 'Shree Ganesh Traders', status: 'pending'),
      const SyncItem(id: 'Y3', label: 'Order draft', detail: 'Saved on phone', status: 'pending'),
    ].map((e) => SyncItemModel.fromEntity(e).toJson()).toList());

    await s.write(K.seeded, true);
  }
}
