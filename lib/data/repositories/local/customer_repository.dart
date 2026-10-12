import '../../../data/models/customer.dart';
import '../../../data/database/database_helper.dart';

class CustomerRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Get all customers
  Future<List<Customer>> getAllCustomers() async {
    final results = await _db.query('customers', orderBy: 'id DESC');
    return results.map((map) => Customer.fromMap(map)).toList();
  }

  // Get customer by ID
  Future<Customer?> getCustomerById(int id) async {
    final results = await _db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Customer.fromMap(results.first);
    }
    return null;
  }

  // Search customers
  Future<List<Customer>> searchCustomers(String query) async {
    final results = await _db.query(
      'customers',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return results.map((map) => Customer.fromMap(map)).toList();
  }

  // Add new customer
  Future<int> addCustomer(Customer customer) async {
    return await _db.insert('customers', customer.toMap());
  }

  // Update customer
  Future<int> updateCustomer(Customer customer) async {
    return await _db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }
}
