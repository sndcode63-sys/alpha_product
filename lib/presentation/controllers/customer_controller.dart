import 'package:alpha_field_app/imports.dart';

class CustomerController extends GetxController {
  final GetCustomers _get;
  final OrderRepository orders;
  final VisitRepository visits;
  final TripRepository trips;
  CustomerController(this._get, this.orders, this.visits, this.trips);

  final all = <Customer>[].obs;
  final query = ''.obs;
  final category = 'All'.obs;
  final tab = 'Orders'.obs;
  final selected = Rxn<Customer>();

  @override
  void onInit() {
    all.assignAll(_get());
    super.onInit();
  }

  List<Customer> get filtered => all.where((c) {
        final q = query.value.toLowerCase();
        return (category.value == 'All' || c.category == category.value) &&
            (q.isEmpty || c.name.toLowerCase().contains(q) || c.address.toLowerCase().contains(q) || c.phone.contains(q));
      }).toList();

  void open(Customer c) {
    selected.value = c;
    tab.value = 'Orders';
    Get.toNamed(Routes.custDetail);
  }

  /// [title, subtitle, trailing] rows for the active detail tab.
  List<List<String>> get tabRows {
    final c = selected.value!;
    switch (tab.value) {
      case 'Visits':
        return visits.all().where((v) => v.customerId == c.id && v.status != 'planned').map((v) => ['Visit · ${v.outcome.isEmpty ? v.status : v.outcome}', dayOf(v.date), v.contactMet]).toList();
      case 'Deliveries':
        return trips.allStops().where((s) => s.customer == c.name).map((s) => ['Trip ${s.tripId}', '${s.items} items', s.status]).toList();
      default:
        return orders.byCustomer(c.id).map((o) => ['Order #${o.id}', '${o.itemCount} items · ${dayOf(o.createdAt)}', money(o.total)]).toList();
    }
  }
}
