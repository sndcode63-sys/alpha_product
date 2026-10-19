import 'package:alpha_field_app/imports.dart';

class AttendanceHistoryScreen extends GetView<AttendanceController> {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          title: 'Attendance History',
          nav: true,
          children: [
            InfoCard('This month', sub: controller.monthSummary),
            for (final h in controller.history)
              RowCard(dayOf(h.date), sub: '${timeOf(h.checkIn)} – ${timeOf(h.checkOut)}', trailing: h.checkOut.isEmpty ? 'Open' : '${(minutesBetween(h.checkIn, h.checkOut) / 60).toStringAsFixed(1)} h'),
            PrimaryButton('Request attendance correction', controller.requestCorrection, ghost: true),
          ],
        ));
  }
}
