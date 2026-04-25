import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError(
      'NotificationService must be overridden at app start.');
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> syncPreferences(ReminderPreferences preferences) async {
    // Scheduling hooks live behind this abstraction so Firebase/remote config
    // can be added later without touching feature code.
    if (!preferences.morningPrayer &&
        !preferences.eveningAarti &&
        !preferences.festivalReminders) {
      await _notificationsPlugin.cancelAll();
    }
  }
}
