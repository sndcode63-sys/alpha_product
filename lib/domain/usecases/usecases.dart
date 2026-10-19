import '../entities/entities.dart';
import '../repositories/repositories.dart';

class LoginUser { final AuthRepository r; LoginUser(this.r); Future<Employee> call(String role) => r.login(role); }
class LogoutUser { final AuthRepository r; LogoutUser(this.r); Future<void> call() => r.logout(); }

class CheckIn {
  final AttendanceRepository r; CheckIn(this.r);
  Future<AttendanceRecord> call(double lat, double lng, String selfie) => r.checkIn(lat, lng, selfie);
}
class CheckOut { final AttendanceRepository r; CheckOut(this.r); Future<AttendanceRecord> call() => r.checkOut(); }
class GetAttendanceHistory { final AttendanceRepository r; GetAttendanceHistory(this.r); List<AttendanceRecord> call() => r.history(); }

class GetCustomers { final CustomerRepository r; GetCustomers(this.r); List<Customer> call() => r.all(); }

class SaveVisit { final VisitRepository r; SaveVisit(this.r); Future<Visit> call(Visit v) => r.save(v); }
class SaveFollowUp { final VisitRepository r; SaveFollowUp(this.r); Future<void> call(FollowUp f) => r.saveFollowUp(f); }

class CreateOrder { final OrderRepository r; CreateOrder(this.r); Future<Order> call(Order o) => r.create(o); }

class SaveTrip { final TripRepository r; SaveTrip(this.r); Future<void> call(Trip t) => r.saveTrip(t); }
class SaveStop { final TripRepository r; SaveStop(this.r); Future<void> call(DeliveryStop s) => r.saveStop(s); }

class SyncAll { final SupportRepository r; SyncAll(this.r); Future<void> call() => r.syncAll(); }
