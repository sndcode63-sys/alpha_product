import 'package:alpha_field_app/imports.dart';
import 'package:alpha_field_app/data/datasources/local_data_source.dart';
import 'package:alpha_field_app/data/repositories/repositories_impl.dart';

/// Dependency injection: services -> data sources -> repositories -> use cases -> controllers.
class InitialBinding extends Bindings {
  static Future<void> initServices() async {
    final storage = await Get.putAsync(() => StorageService().init(), permanent: true);
    Get.put(LocationService(), permanent: true);
    final ds = LocalDataSource(storage);
    await ds.seed();
    Get.put(ds, permanent: true);
  }

  @override
  void dependencies() {
    final ds = Get.find<LocalDataSource>();
    final auth = AuthRepositoryImpl(ds), att = AttendanceRepositoryImpl(ds), cust = CustomerRepositoryImpl(ds),
        visit = VisitRepositoryImpl(ds), order = OrderRepositoryImpl(ds), trip = TripRepositoryImpl(ds), support = SupportRepositoryImpl(ds);
    final loc = Get.find<LocationService>();

    Get.put(AuthController(auth, LoginUser(auth), LogoutUser(auth)), permanent: true);
    Get.put(AttendanceController(att, CheckIn(att), CheckOut(att), GetAttendanceHistory(att)), permanent: true);
    Get.lazyPut(() => CustomerController(GetCustomers(cust), order, visit, trip), fenix: true);
    Get.lazyPut(() => OrderController(CreateOrder(order), cust), fenix: true);
    Get.lazyPut(() => VisitController(visit, SaveVisit(visit), SaveFollowUp(visit), loc), fenix: true);
    Get.lazyPut(() => TripController(trip, SaveTrip(trip), SaveStop(trip), loc), fenix: true);
    Get.lazyPut(() => SupportController(support, SyncAll(support)), fenix: true);
    Get.lazyPut(() => PhotoController(), fenix: true);
  }
}
