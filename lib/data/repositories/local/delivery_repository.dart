import '../../../data/models/delivery.dart';
import '../../../data/database/database_helper.dart';

class DeliveryRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Get all deliveries
  Future<List<Delivery>> getAllDeliveries() async {
    final results = await _db.query('deliveries', orderBy: 'id DESC');
    return results.map((map) => Delivery.fromMap(map)).toList();
  }

  // Get deliveries by user
  Future<List<Delivery>> getDeliveriesByUser(int userId) async {
    final results = await _db.query(
      'deliveries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return results.map((map) => Delivery.fromMap(map)).toList();
  }

  // Get delivery by ID
  Future<Delivery?> getDeliveryById(int id) async {
    final results = await _db.query(
      'deliveries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Delivery.fromMap(results.first);
    }
    return null;
  }

  // Create new delivery
  Future<int> createDelivery(Delivery delivery) async {
    return await _db.insert('deliveries', delivery.toMap());
  }

  // Update delivery status
  Future<int> updateDeliveryStatus(int id, String status) async {
    final data = {'status': status};
    if (status == 'delivered') {
      data['delivered_date'] = DateTime.now().toIso8601String();
    }

    return await _db.update(
      'deliveries',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update delivery with proof
  Future<int> updateDeliveryProof(
    int id,
    String? photoPath,
    String? signaturePath,
  ) async {
    return await _db.update(
      'deliveries',
      {
        'delivery_photo_path': photoPath,
        'signature_path': signaturePath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get pending deliveries
  Future<List<Delivery>> getPendingDeliveries(int userId) async {
    final results = await _db.query(
      'deliveries',
      where: 'user_id = ? AND status = ?',
      whereArgs: [userId, 'pending'],
      orderBy: 'id DESC',
    );

    return results.map((map) => Delivery.fromMap(map)).toList();
  }
}
