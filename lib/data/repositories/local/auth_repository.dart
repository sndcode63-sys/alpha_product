import '../../../data/models/user.dart';
import '../../../data/database/database_helper.dart';

class AuthRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Login user
  Future<User?> login(String email, String password) async {
    final results = await _db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // Register user
  Future<int> register(User user) async {
    return await _db.insert('users', user.toMap());
  }

  // Get user by ID
  Future<User?> getUserById(int id) async {
    final results = await _db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }
}
