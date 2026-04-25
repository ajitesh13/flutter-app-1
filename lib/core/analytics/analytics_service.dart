import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return const AnalyticsService();
});

class AnalyticsService {
  const AnalyticsService();

  Future<void> logAppOpen() => _log('app_open');
  Future<void> logOnboardingCompleted() => _log('onboarding_completed');
  Future<void> logLanguageSelected(String language) =>
      _log('language_selected', {'language': language});
  Future<void> logDeitySelected(String deity) =>
      _log('deity_selected', {'deity': deity});
  Future<void> logPrayerScreenShown() => _log('prayer_screen_shown');
  Future<void> logPrayerStarted(String prayerId) =>
      _log('prayer_started', {'prayer_id': prayerId});
  Future<void> logPrayerCompleted(String prayerId) =>
      _log('prayer_completed', {'prayer_id': prayerId});
  Future<void> logSharePromptShown(String type) =>
      _log('share_prompt_shown', {'type': type});
  Future<void> logShareClicked(String type) =>
      _log('share_clicked', {'type': type});
  Future<void> logWhatsAppShareClicked(String type) =>
      _log('whatsapp_share_clicked', {'type': type});
  Future<void> logShareSkipped(String type) =>
      _log('share_skipped', {'type': type});
  Future<void> logStreakIncremented(String streakType, int streak) =>
      _log('streak_incremented', {'streak_type': streakType, 'value': streak});
  Future<void> logDiyaLit() => _log('diya_lit');
  Future<void> logFlowerOffered() => _log('flower_offered');
  Future<void> logBellRang() => _log('bell_rang');
  Future<void> logFestivalViewed(String festivalId) =>
      _log('festival_viewed', {'festival_id': festivalId});
  Future<void> logGreetingGenerated(String greetingType) =>
      _log('greeting_generated', {'type': greetingType});
  Future<void> logGreetingShared(String greetingType) =>
      _log('greeting_shared', {'type': greetingType});
  Future<void> logPremiumButtonClicked(String label) =>
      _log('premium_button_clicked', {'label': label});
  Future<void> logPremiumWaitlistJoined() => _log('premium_waitlist_joined');
  Future<void> logReminderEnabled(String reminderType, bool enabled) =>
      _log('reminder_enabled', {'type': reminderType, 'enabled': enabled});
  Future<void> logNotificationOpened(String notificationType) =>
      _log('notification_opened', {'type': notificationType});

  Future<void> _log(String event,
      [Map<String, Object?> params = const {}]) async {
    debugPrint('[Analytics] $event $params');
  }
}
