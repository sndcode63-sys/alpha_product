import 'package:get/get.dart';

class MainTabController extends GetxController with GetTickerProviderStateMixin {
  final RxInt currentIndex = 0.obs;

  // Tab names
  static const List<String> tabTitles = [
    'Attendance',
    'Delivery',
    'Vehicle',
    'Customer',
    'Product',
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
