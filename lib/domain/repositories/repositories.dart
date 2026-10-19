import '../entities/entities.dart';

abstract class AuthRepository {
  Employee? current();
  Future<Employee> login(String role);
  Future<void> logout();
}

abstract class AttendanceRepository {
  AttendanceRecord? today();
  List<AttendanceRecord> history();
  Future<AttendanceRecord> checkIn(double lat, double lng, String selfiePath);
  Future<AttendanceRecord> checkOut();
}

abstract class CustomerRepository {
  List<Customer> all();
  Customer? byId(String id);
}

abstract class VisitRepository {
  List<Visit> all();
  Future<Visit> save(Visit v);
  List<FollowUp> followUps();
  Future<void> saveFollowUp(FollowUp f);
  bool fieldActive();
  Future<void> setFieldActive(bool v);
}

abstract class OrderRepository {
  List<Order> byCustomer(String customerId);
  Future<Order> create(Order o);
}

abstract class TripRepository {
  List<Trip> trips();
  Trip? active();
  Future<void> saveTrip(Trip t);
  List<DeliveryStop> stops(String tripId);
  List<DeliveryStop> allStops();
  Future<void> saveStop(DeliveryStop s);
}

abstract class SupportRepository {
  List<AppNotification> notifications();
  List<SyncItem> syncQueue();
  Future<void> syncAll();
}
