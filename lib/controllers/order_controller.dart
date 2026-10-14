import 'package:get/get.dart';

import '../data/models.dart';

class OrderController extends GetxController {
  final orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    orders.assignAll(MockData.orders());
  }

  Order add(String customer, List<OrderLine> lines) {
    final o = Order('ORD-${5013 + orders.length - 3}', customer, DateTime.now(), 'Placed', lines);
    orders.insert(0, o);
    return o;
  }
}
