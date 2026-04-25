import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'core/notifications/notification_service.dart';
import 'core/storage/app_controller.dart';
import 'core/storage/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = AppStorage();
  await storage.init();
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appStorageProvider.overrideWithValue(storage),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const ShanataniApp(),
    ),
  );
}
