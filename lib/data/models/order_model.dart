import '../../domain/entities/entities.dart';

class OrderModel extends Order {
  const OrderModel({super.id='', super.customerId='', super.customerName='', super.itemCount=0, super.total=0, super.createdAt='', super.status=''});
  factory OrderModel.fromEntity(Order e) => OrderModel(id: e.id, customerId: e.customerId, customerName: e.customerName, itemCount: e.itemCount, total: e.total, createdAt: e.createdAt, status: e.status);
  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(id: (j['id']??'').toString(), customerId: (j['customerId']??'').toString(), customerName: (j['customerName']??'').toString(), itemCount: ((j['itemCount']??0) as num).toInt(), total: ((j['total']??0) as num).toDouble(), createdAt: (j['createdAt']??'').toString(), status: (j['status']??'').toString());
  Map<String, dynamic> toJson() => {'id': id, 'customerId': customerId, 'customerName': customerName, 'itemCount': itemCount, 'total': total, 'createdAt': createdAt, 'status': status};
}
