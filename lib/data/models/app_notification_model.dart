import '../../domain/entities/entities.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({super.id='', super.title='', super.body='', super.time='', super.route=''});
  factory AppNotificationModel.fromEntity(AppNotification e) => AppNotificationModel(id: e.id, title: e.title, body: e.body, time: e.time, route: e.route);
  factory AppNotificationModel.fromJson(Map<String, dynamic> j) => AppNotificationModel(id: (j['id']??'').toString(), title: (j['title']??'').toString(), body: (j['body']??'').toString(), time: (j['time']??'').toString(), route: (j['route']??'').toString());
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body, 'time': time, 'route': route};
}
