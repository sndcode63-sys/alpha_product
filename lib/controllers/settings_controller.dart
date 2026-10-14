import 'package:get/get.dart';

class SettingsController extends GetxController {
  final deliveryAlerts = true.obs;
  final attendanceReminder = true.obs;
  final sound = true.obs;
  final language = 'Hinglish'.obs;
  final languages = const ['English', 'हिन्दी (Hindi)', 'Hinglish'];
}
