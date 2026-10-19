class Order {
  final String id;
  final String customerId;
  final String customerName;
  final int itemCount;
  final double total;
  final String createdAt;
  final String status;
  const Order({this.id='', this.customerId='', this.customerName='', this.itemCount=0, this.total=0, this.createdAt='', this.status=''});
  Order copyWith({String? id, String? customerId, String? customerName, int? itemCount, double? total, String? createdAt, String? status}) => Order(id: id ?? this.id, customerId: customerId ?? this.customerId, customerName: customerName ?? this.customerName, itemCount: itemCount ?? this.itemCount, total: total ?? this.total, createdAt: createdAt ?? this.createdAt, status: status ?? this.status);
}
