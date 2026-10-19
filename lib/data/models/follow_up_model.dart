import '../../domain/entities/entities.dart';

class FollowUpModel extends FollowUp {
  const FollowUpModel({super.id='', super.visitId='', super.customerName='', super.action='', super.dueDate='', super.done=false});
  factory FollowUpModel.fromEntity(FollowUp e) => FollowUpModel(id: e.id, visitId: e.visitId, customerName: e.customerName, action: e.action, dueDate: e.dueDate, done: e.done);
  factory FollowUpModel.fromJson(Map<String, dynamic> j) => FollowUpModel(id: (j['id']??'').toString(), visitId: (j['visitId']??'').toString(), customerName: (j['customerName']??'').toString(), action: (j['action']??'').toString(), dueDate: (j['dueDate']??'').toString(), done: (j['done']??false) as bool);
  Map<String, dynamic> toJson() => {'id': id, 'visitId': visitId, 'customerName': customerName, 'action': action, 'dueDate': dueDate, 'done': done};
}
