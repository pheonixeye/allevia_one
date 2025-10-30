import 'dart:async';

import 'package:allevia_one/utils/notifications/i_push.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:unifiedpush/unifiedpush.dart';

final controller = StreamController<String>.broadcast();

const localInstance = "myInstance";
// The Linux app name is used to register the application with DBus
// Because of this it needs to be a valid fully-qualified name
// const linuxAppName = "org.unifiedpush.Example";

var endpoint = PushEndpoint("https://ntfy-allevia.kareemzaher.com", null);
var registered = false;
var showNoDistribDialog = true;

class UPush {
  void _onUpdate() {
    controller.add("update");
  }

  void init(bool background) {
    UnifiedPush.initialize(
      onNewEndpoint: onNewEndpoint,
      // takes (String endpoint, String instance) in args
      onRegistrationFailed: onRegistrationFailed,
      // takes (String instance)
      onUnregistered: onUnregistered,
      // takes (String instance)
      onMessage: UPNotificationUtils.basicOnNotification,
    ).then((registered) {
      if (registered) {
        UnifiedPush.register(
          instance: localInstance,
        );
      }
    });
  }

  void onNewEndpoint(PushEndpoint nEndpoint, String instance) {
    if (instance != localInstance) {
      return;
    }
    registered = true;
    endpoint = nEndpoint;
    debugPrint("New endpoint on $hashCode");
    debugPrint("Endpoint (temp=${endpoint.temporary}): ${endpoint.url}");
    debugPrint("To test: $endpoint");
    _onUpdate();
  }

  void onUnregistered(String instance) {
    if (instance != localInstance) {
      return;
    }
    registered = false;
    debugPrint("unregistered");
    _onUpdate();
  }

  void onRegistrationFailed(FailedReason reason, String instance) {
    debugPrint("Registration failed: $reason");
    onUnregistered(instance);
  }
}

class UPFunctions {
  final List<String> features = [/*list of features*/];

  Future<String?> getDistributor() async {
    return await UnifiedPush.getDistributor();
  }

  Future<List<String>> getDistributors() async {
    return await UnifiedPush.getDistributors(features);
  }

  Future<void> registerApp(String instance) async {
    debugPrint("Calling registerApp");
    await UnifiedPush.register(
      instance: instance,
      features: features,
    );
  }

  Future<void> saveDistributor(String distributor) async {
    await UnifiedPush.saveDistributor(distributor);
  }
}
