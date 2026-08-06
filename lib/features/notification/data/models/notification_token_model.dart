class NotificationTokenModel {
  final String id;
  final String deviceToken;
  final String deviceType;

  const NotificationTokenModel({
    required this.id,
    required this.deviceToken,
    required this.deviceType,
  });

  factory NotificationTokenModel.fromJson(Map<String, dynamic> json) {
    return NotificationTokenModel(
      id: json['id']?.toString() ?? '',
      deviceToken: json['deviceToken']?.toString() ?? '',
      deviceType: json['deviceType']?.toString() ?? '',
    );
  }
}