import 'package:allevia_one/core/api/notifications_api.dart';
import 'package:allevia_one/models/notifications/in_app_notification.dart';
import 'package:allevia_one/models/notifications/notification_endpoints.dart';
import 'package:flutter/material.dart';

class PxNotifications extends ChangeNotifier {
  final NotificationsApi api;

  PxNotifications({required this.api}) {
    _init();
  }

  Future<void> sendNotification({
    required NotificationEndpoints endpoint,
    required InAppNotification inAppNotification,
  }) async {
    await api.sendNotification(
      endpoint: endpoint,
      inAppNotification: inAppNotification,
    );
  }

  final Map<String, Stream<InAppNotification>> _stream = {};
  Map<String, Stream<InAppNotification>> get stream => _stream;

  Future<void> _listenToNotifications({
    required NotificationEndpoints endpoint,
  }) async {
    _stream[endpoint.toEndPoint()] =
        await api.listenToNotifications(endpoint: endpoint);
    notifyListeners();
    print(_stream);
  }

  Future<void> _init() async {
    NotificationEndpoints.values.map((e) async {
      await _listenToNotifications(endpoint: e);
    }).toList();
  }
}
