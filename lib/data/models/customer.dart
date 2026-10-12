class Customer {
  final int? id;
  final String name;
  final String? email;
  final String phone;
  final String address;
  final String? gstNumber;
  final String type;
  final String status;
  final String createdAt;

  Customer({
    this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.address,
    this.gstNumber,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'gst_number': gstNumber,
      'type': type,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      gstNumber: map['gst_number'],
      type: map['type'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }
}
