import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermissions() async {
    log('notification request');
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true,
        provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permissions');
    } else {
      print('user rejected permissions');
    }
  }

  Future<String> getDeviceToken() async {
    String? deviceToken = await messaging.getToken();
    return deviceToken!;
  }
}
