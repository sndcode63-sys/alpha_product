import '../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/local_data_source.dart';
import '../models/models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource ds;
  AuthRepositoryImpl(this.ds);
  List<EmployeeModel> _all() => ds.list(K.employees).map(EmployeeModel.fromJson).toList();

  @override
  Employee? current() {
    final id = ds.s.read<String>(K.session);
    if (id == null) return null;
    final list = _all();
    for (final e in list) {
      if (e.id == id) return e;
    }
    return null;
  }

  @override
  Future<Employee> login(String role) async {
    final list = _all();
    final e = list.firstWhere((e) => e.role == role, orElse: () => const EmployeeModel());
    await ds.s.write(K.session, e.id);
    return e;
  }

  @override
  Future<void> logout() => ds.s.remove(K.session);
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final LocalDataSource ds;
  AttendanceRepositoryImpl(this.ds);
  List<AttendanceRecord> _all() => ds.list(K.attendance).map(AttendanceRecordModel.fromJson).toList();

  @override
  List<AttendanceRecord> history() => _all()..sort((a, b) => b.date.compareTo(a.date));

  @override
  AttendanceRecord? today() {
    final l = _all().where((a) => a.date == todayIso());
    return l.isEmpty ? null : l.last;
  }

  @override
  Future<AttendanceRecord> checkIn(double lat, double lng, String selfiePath) async {
    final r = AttendanceRecord(id: 'A${DateTime.now().millisecondsSinceEpoch}', date: todayIso(), checkIn: DateTime.now().toIso8601String(), lat: lat, lng: lng, selfiePath: selfiePath);
    await ds.upsert(K.attendance, AttendanceRecordModel.fromEntity(r).toJson());
    return r;
  }

  @override
  Future<AttendanceRecord> checkOut() async {
    final r = today()!.copyWith(checkOut: DateTime.now().toIso8601String());
    await ds.upsert(K.attendance, AttendanceRecordModel.fromEntity(r).toJson());
    return r;
  }
}

class CustomerRepositoryImpl implements CustomerRepository {
  final LocalDataSource ds;
  CustomerRepositoryImpl(this.ds);
  @override
  List<Customer> all() => ds.list(K.customers).map(CustomerModel.fromJson).toList();
  @override
  Customer? byId(String id) => all().where((c) => c.id == id).firstOrNull;
}

class VisitRepositoryImpl implements VisitRepository {
  final LocalDataSource ds;
  VisitRepositoryImpl(this.ds);
  @override
  List<Visit> all() => ds.list(K.visits).map(VisitModel.fromJson).toList();
  @override
  Future<Visit> save(Visit v) async {
    await ds.upsert(K.visits, VisitModel.fromEntity(v).toJson());
    return v;
  }
  @override
  List<FollowUp> followUps() => ds.list(K.followUps).map(FollowUpModel.fromJson).toList();
  @override
  Future<void> saveFollowUp(FollowUp f) => ds.upsert(K.followUps, FollowUpModel.fromEntity(f).toJson());
  @override
  bool fieldActive() => ds.s.read<bool>(K.fieldActive) ?? false;
  @override
  Future<void> setFieldActive(bool v) => ds.s.write(K.fieldActive, v);
}

class OrderRepositoryImpl implements OrderRepository {
  final LocalDataSource ds;
  OrderRepositoryImpl(this.ds);
  @override
  List<Order> byCustomer(String id) => ds.list(K.orders).map(OrderModel.fromJson).where((o) => o.customerId == id).toList();
  @override
  Future<Order> create(Order o) async {
    await ds.upsert(K.orders, OrderModel.fromEntity(o).toJson());
    return o;
  }
}

class TripRepositoryImpl implements TripRepository {
  final LocalDataSource ds;
  TripRepositoryImpl(this.ds);
  @override
  List<Trip> trips() => ds.list(K.trips).map(TripModel.fromJson).toList();
  @override
  Trip? active() => trips().where((t) => t.status == 'active').firstOrNull;
  @override
  Future<void> saveTrip(Trip t) => ds.upsert(K.trips, TripModel.fromEntity(t).toJson());
  @override
  List<DeliveryStop> allStops() => ds.list(K.stops).map(DeliveryStopModel.fromJson).toList();
  @override
  List<DeliveryStop> stops(String tripId) => (allStops().where((s) => s.tripId == tripId).toList()..sort((a, b) => a.seq.compareTo(b.seq)));
  @override
  Future<void> saveStop(DeliveryStop s) => ds.upsert(K.stops, DeliveryStopModel.fromEntity(s).toJson());
}

class SupportRepositoryImpl implements SupportRepository {
  final LocalDataSource ds;
  SupportRepositoryImpl(this.ds);
  @override
  List<AppNotification> notifications() => ds.list(K.notifications).map(AppNotificationModel.fromJson).toList();
  @override
  List<SyncItem> syncQueue() => ds.list(K.sync).map(SyncItemModel.fromJson).toList();
  /// Local-only demo: marks everything as synced. Replace with real API upload later.
  @override
  Future<void> syncAll() async {
    final l = syncQueue().map((e) => SyncItemModel.fromEntity(e.copyWith(status: 'synced')).toJson()).toList();
    await ds.put(K.sync, l);
  }
}
