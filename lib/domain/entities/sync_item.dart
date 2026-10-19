class SyncItem {
  final String id;
  final String label;
  final String detail;
  final String status;
  const SyncItem({this.id='', this.label='', this.detail='', this.status=''});
  SyncItem copyWith({String? id, String? label, String? detail, String? status}) => SyncItem(id: id ?? this.id, label: label ?? this.label, detail: detail ?? this.detail, status: status ?? this.status);
}
