// src/platformNotification_web.dart
import 'dart:convert';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:unifiedpush/unifiedpush.dart';
import 'package:web/web.dart' as html;
import 'dart:js_interop';

class IPush {
  static bool requestPermission() {
    html.Notification.requestPermission().toDart.then((permission) {
      if (permission.toDart == 'granted') {
        print('Notification permission granted.');
        return true;
      } else {
        print('Notification permission denied.');
      }
    });
    return false;
  }

  static void sendNotification(String title, String body) {
    if (html.Notification.permission.toJS.toDart == 'granted') {
      final _n = html.window.getProperty('Notification'.toJS);
      (_n as JSFunction).callAsConstructor(
        title.toJS,
        {'body': body}.jsify(),
      );
    } else {
      print('Notification permission not granted.');
    }
  }
}

abstract class UPNotificationUtils {
  static bool _permissionRequested = false;

  static Map<String, String> decodeMessageContentsUri(String message) {
    List<String> uri = Uri.decodeComponent(message).split("&");
    Map<String, String> decoded = {};
    for (var i in uri) {
      try {
        decoded[i.split("=")[0]] = i.split("=")[1];
      } on Exception {
        print("Couldn't decode $i");
      }
    }
    return decoded;
  }

  static Future<bool> basicOnNotification(
    PushMessage message,
    String instance,
  ) async {
    debugPrint("instance $instance");
    if (!_permissionRequested) {
      _permissionRequested = IPush.requestPermission();
    }
    if (!_permissionRequested) {
      return false;
    }
    String payload;
    try {
      payload = utf8.decode(message.content);
    } catch (e) {
      // We may have a FormatException while doing utf8.decode, if it was encrypted
      // but we couldn't decrypt it.
      debugPrint(
          "Couldn't decrypt content (decrypted=${message.decrypted}): $e");
      payload = "Couldn't decrypt";
    }

    String title = 'UP-Example'; // Default title
    String body = 'Could not get the content'; // Default body

    try {
      // Try to decode title and message (JSON)
      Map<String, String> decodedMessage = decodeMessageContentsUri(payload);
      title = decodedMessage['title'] ?? title;
      body = decodedMessage['message'] ?? body;
    } catch (e) {
      // If decoding fails, use plain payload as body
      body = payload.isNotEmpty ? payload : 'Empty message';
    }

    debugPrint(title);

    IPush.sendNotification(title, body);

    return true;
  }
}
