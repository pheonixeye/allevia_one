import 'package:flutter/material.dart';

import 'package:allevia_one/core/api/wa_api.dart';

class PxWhatsapp extends ChangeNotifier {
  final WaApi api;

  PxWhatsapp({
    required this.api,
  }) {
    reconnect();
  }

  String? _qrLink;
  String? get qrLink => _qrLink;

  List<dynamic>? _connectedDevices;
  List<dynamic>? get connectedDevices => _connectedDevices;

  Future<void> login() async {
    _qrLink = await api.login();
    notifyListeners();
  }

  Future<void> fetchConnectedDevices() async {
    _connectedDevices = await api.fetchDevices();
    notifyListeners();
  }

  Future<void> reconnect() async {
    await api.reconnect();
  }
}
