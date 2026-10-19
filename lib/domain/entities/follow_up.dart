class FollowUp {
  final String id;
  final String visitId;
  final String customerName;
  final String action;
  final String dueDate;
  final bool done;
  const FollowUp({this.id='', this.visitId='', this.customerName='', this.action='', this.dueDate='', this.done=false});
  FollowUp copyWith({String? id, String? visitId, String? customerName, String? action, String? dueDate, bool? done}) => FollowUp(id: id ?? this.id, visitId: visitId ?? this.visitId, customerName: customerName ?? this.customerName, action: action ?? this.action, dueDate: dueDate ?? this.dueDate, done: done ?? this.done);
}
