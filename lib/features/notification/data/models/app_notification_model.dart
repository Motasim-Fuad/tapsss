import '../../../../core/utils/json_parsers.dart';

class NotificationInbox {
  final int total;
  final List<AppNotification> notifications;

  const NotificationInbox({
    required this.total,
    required this.notifications,
  });

  factory NotificationInbox.fromJson(dynamic json) {
    final map = asJsonMap(json);
    return NotificationInbox(
      total: asInt(map['total']),
      notifications: asJsonMapList(map['notifications'])
          .map(AppNotification.fromJson)
          .toList(),
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? chapterId;
  final bool isRead;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.chapterId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final payload = asJsonMap(json['notification']);
    final chapter = payload['chapter'];
    return AppNotification(
      id: asString(json['_id']),
      title: asString(payload['title']),
      body: asString(payload['body']),
      type: asString(payload['type']),
      chapterId: chapter == null || chapter.toString().isEmpty ? null : chapter.toString(),
      isRead: json['isRead'] == true,
      createdAt: DateTime.tryParse(asString(json['createdAt'])),
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      chapterId: chapterId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
