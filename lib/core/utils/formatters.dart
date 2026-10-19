import 'package:intl/intl.dart';

String hhmm([DateTime? d]) => DateFormat('hh:mm a').format(d ?? DateTime.now());
String isoDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
String todayIso() => isoDate(DateTime.now());
String money(num v) => '₹${NumberFormat.decimalPattern('en_IN').format(v.round())}';
/// ISO date-time -> "11:42 AM" ("—" when empty).
String timeOf(String iso) => iso.isEmpty ? '—' : hhmm(DateTime.parse(iso));
/// ISO date -> "12 Oct".
String dayOf(String iso) => iso.isEmpty ? '—' : DateFormat('dd MMM').format(DateTime.parse(iso));
int minutesBetween(String a, String b) =>
    (a.isEmpty || b.isEmpty) ? 0 : DateTime.parse(b).difference(DateTime.parse(a)).inMinutes;
