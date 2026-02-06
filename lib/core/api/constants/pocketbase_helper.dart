import 'dart:math';

import 'package:pocketbase/pocketbase.dart';

class PocketbaseHelper {
  static final _pb = PocketBase(const String.fromEnvironment('PB_URL'));

  static PocketBase get pb => _pb;

  static String generatePocketBaseId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    final buffer = StringBuffer();

    for (int i = 0; i < 15; i++) {
      buffer.write(chars[rand.nextInt(chars.length)]);
    }

    return buffer.toString();
  }
}
