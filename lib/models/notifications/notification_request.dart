import 'package:allevia_one/models/notifications/notification_topic.dart';
import 'package:equatable/equatable.dart';

class NotificationRequest extends Equatable {
  final NotificationTopic topic;
  final String? title;
  final String? message;
  final int priority;

  const NotificationRequest({
    required this.topic,
    this.title,
    this.message,
    this.priority = 5,
  });

  NotificationRequest copyWith({
    NotificationTopic? topic,
    String? title,
    String? message,
    int? priority,
  }) {
    return NotificationRequest(
      topic: topic ?? this.topic,
      title: title ?? this.title,
      message: message ?? this.message,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'topic': topic.toTopic(),
      'title': title,
      'message': message,
      'priority': priority,
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        topic,
        message,
        title,
        priority,
      ];
}
