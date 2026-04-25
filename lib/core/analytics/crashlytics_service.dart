import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crashlyticsServiceProvider = Provider<CrashlyticsService>((ref) {
  return const CrashlyticsService();
});

class CrashlyticsService {
  const CrashlyticsService();

  Future<void> recordError(Object error, StackTrace stackTrace) async {
    debugPrint('[Crashlytics] $error\n$stackTrace');
  }
}
