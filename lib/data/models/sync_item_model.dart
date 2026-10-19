import '../../domain/entities/entities.dart';

class SyncItemModel extends SyncItem {
  const SyncItemModel({super.id='', super.label='', super.detail='', super.status=''});
  factory SyncItemModel.fromEntity(SyncItem e) => SyncItemModel(id: e.id, label: e.label, detail: e.detail, status: e.status);
  factory SyncItemModel.fromJson(Map<String, dynamic> j) => SyncItemModel(id: (j['id']??'').toString(), label: (j['label']??'').toString(), detail: (j['detail']??'').toString(), status: (j['status']??'').toString());
  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'detail': detail, 'status': status};
}
