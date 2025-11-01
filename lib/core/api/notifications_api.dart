import 'dart:async';
import 'dart:convert';

import 'package:allevia_one/models/notifications/in_app_notification.dart';
import 'package:allevia_one/models/notifications/notification_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart';

class NotificationsApi {
  const NotificationsApi();

  final _url = const String.fromEnvironment('NOTIFICATIONS_URL');

  final sendHeaders = const {
    'Content-Type': 'Application/Json',
  };
  final listenHeaders = const {
    'Content-Type': 'application/x-ndjson; charset=utf-8',
    'Transfer-Encoding': 'chunked',
  };

  Future<Map<String, dynamic>> sendNotification({
    required NotificationEndpoints endpoint,
    required InAppNotification inAppNotification,
  }) async {
    final uri = Uri.parse('$_url/${endpoint.toEndPoint()}');

    final _response = await http.post(
      uri,
      headers: sendHeaders,
      body: inAppNotification.toJson(),
    );

    if (_response.statusCode == HttpStatus.ok) {
      return {
        'status': 200,
        'message': 'ok',
      };
    } else {
      return {
        'status': _response.statusCode,
        'message': _response.body,
      };
    }
  }

  Future<Stream<InAppNotification>> listenToNotifications({
    required NotificationEndpoints endpoint,
  }) async {
    StreamController<InAppNotification> _notificationStreamController =
        StreamController.broadcast();

    final uri = Uri.parse('$_url/${endpoint.toEndPoint()}/json');

    final _request = http.Request("GET", uri);

    _request.headers.addAll(listenHeaders);

    _request.persistentConnection = true;

    final _response = await _request.send();

    // print('response stream : ${_response.stream}');

    _response.stream.listen((event) {
      if (event != null && event.isNotEmpty) {
        try {
          final _string = utf8.decode(event);
          final _json = jsonDecode(_string);
          if (_json != null) {
            print('json : $_json');
            final _notification = InAppNotification.fromJson(_json);
            _notificationStreamController.add(_notification);
          }
        } catch (e) {
          print(e);
        }
      }
    });

    return _notificationStreamController.stream;
  }
}
