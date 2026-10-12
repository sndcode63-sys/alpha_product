import '../../../data/models/attendance.dart';
import '../../../data/database/database_helper.dart';

class AttendanceRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Get attendance by user and date
  Future<Attendance?> getAttendanceByDate(int userId, String date) async {
    final results = await _db.query(
      'attendance',
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );

    if (results.isNotEmpty) {
      return Attendance.fromMap(results.first);
    }
    return null;
  }

  // Check in
  Future<int> checkIn(Attendance attendance) async {
    return await _db.insert('attendance', attendance.toMap());
  }

  // Check out
  Future<int> checkOut(Attendance attendance) async {
    return await _db.update(
      'attendance',
      attendance.toMap(),
      where: 'id = ?',
      whereArgs: [attendance.id],
    );
  }

  // Get attendance history
  Future<List<Attendance>> getAttendanceHistory(int userId) async {
    final results = await _db.query(
      'attendance',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return results.map((map) => Attendance.fromMap(map)).toList();
  }

  // Get today's attendance
  Future<Attendance?> getTodayAttendance(int userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await getAttendanceByDate(userId, today);
  }
}
