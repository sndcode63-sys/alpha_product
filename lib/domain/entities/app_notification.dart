class AppNotification {
  final String id;
  final String title;
  final String body;
  final String time;
  final String route;
  const AppNotification({this.id='', this.title='', this.body='', this.time='', this.route=''});
  AppNotification copyWith({String? id, String? title, String? body, String? time, String? route}) => AppNotification(id: id ?? this.id, title: title ?? this.title, body: body ?? this.body, time: time ?? this.time, route: route ?? this.route);
}
