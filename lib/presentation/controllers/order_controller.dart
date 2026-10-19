import 'package:alpha_field_app/imports.dart';

class Product {
  final String name, sku;
  final double price;
  const Product(this.name, this.sku, this.price);
}

class OrderController extends GetxController {
  final CreateOrder _create;
  final CustomerRepository customers;
  OrderController(this._create, this.customers);

  static const catalog = [
    Product('Biscuit carton', 'B-101', 420), Product('Namkeen pack', 'N-204', 180),
    Product('Cola 1L case', 'C-310', 560), Product('Juice 200ml case', 'J-120', 350),
    Product('Instant noodles carton', 'M-415', 480), Product('Tea 500g pack', 'T-077', 260),
  ];

  final cart = <String, int>{}.obs;
  final customer = Rxn<Customer>();
  final query = ''.obs;
  final notes = TextEditingController();

  List<Customer> get allCustomers => customers.all();
  List<Product> get visible => catalog.where((p) => p.name.toLowerCase().contains(query.value.toLowerCase()) || p.sku.toLowerCase().contains(query.value.toLowerCase())).toList();
  List<Product> get lines => catalog.where((p) => (cart[p.sku] ?? 0) > 0).toList();
  int get itemCount => lines.length;
  double get subtotal => lines.fold(0, (a, p) => a + p.price * cart[p.sku]!);
  double get gst => subtotal * 0.12;
  double get total => subtotal + gst;

  void forCustomer(Customer? c) => customer.value = c ?? customer.value ?? allCustomers.first;
  void change(String sku, int d) => cart[sku] = ((cart[sku] ?? 0) + d).clamp(0, 999);

  void review() {
    if (itemCount == 0) return AppToast.show('Add at least one product');
    Get.toNamed(Routes.orderReview);
  }

  Future<void> submit() async {
    if (!await AppDialogs.confirm(title: 'Submit order?', text: '${customer.value?.name ?? ''} · ${money(total)}', yes: 'Submit')) return;
    final c = customer.value ?? allCustomers.first;
    final o = await _create(Order(id: 'A-${2200 + DateTime.now().second}${DateTime.now().millisecond % 10}', customerId: c.id, customerName: c.name, itemCount: itemCount, total: total, createdAt: todayIso(), status: 'created'));
    cart.clear();
    notes.clear();
    AppToast.show('Order #${o.id} created ✓');
    Get.find<CustomerController>()..selected.value = c..tab.value = 'Orders';
    Get.offNamedUntil(Routes.custDetail, (r) => r.isFirst || r.settings.name == Routes.custList);
  }
}
