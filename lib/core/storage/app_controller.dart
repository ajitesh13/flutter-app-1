import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/seed/seed_repository.dart';
import '../analytics/analytics_service.dart';
import '../constants/app_constants.dart';
import '../models/app_models.dart';
import 'app_storage.dart';

final appControllerProvider =
    AsyncNotifierProvider<AppController, AppViewState>(AppController.new);

class AppController extends AsyncNotifier<AppViewState> {
  AppStorage get _storage => ref.read(appStorageProvider);
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  @override
  Future<AppViewState> build() async {
    final seedContent = await ref.read(seedRepositoryProvider).load();
    await _analytics.logAppOpen();
    return AppViewState(
      seedContent: seedContent,
      onboardingComplete: _storage.onboardingComplete,
      profile: _storage.profile,
      reminderPreferences: _storage.reminders,
      lastPrayerCompletionDate: _storage.lastPrayerCompletionDate,
      prayerStreak: _storage.prayerStreak,
      lastMandirDate: _storage.lastMandirDate,
      mandirStreak: _storage.mandirStreak,
      shareCount: _storage.shareCount,
      premiumWaitlistJoined: _storage.premiumWaitlistJoined,
    );
  }

  Future<void> completeOnboarding({
    required UserProfile profile,
    required ReminderPreferences reminders,
  }) async {
    final current = state.requireValue;
    await _storage.saveOnboarding(profile: profile, reminders: reminders);
    await _analytics.logLanguageSelected(profile.language);
    await _analytics.logDeitySelected(profile.favouriteDeityId);
    await _analytics.logOnboardingCompleted();
    state = AsyncData(
      current.copyWith(
        onboardingComplete: true,
        profile: profile,
        reminderPreferences: reminders,
      ),
    );
  }

  Future<void> completeTodayPrayer(String prayerId) async {
    final current = state.requireValue;
    final today = DateTime.now();
    final previous = current.lastPrayerCompletionDate;
    var streak = current.prayerStreak;
    if (previous == null) {
      streak = 1;
    } else {
      final difference = DateTime(today.year, today.month, today.day)
          .difference(DateTime(previous.year, previous.month, previous.day))
          .inDays;
      if (difference == 1) {
        streak += 1;
      } else if (difference > 1) {
        streak = 1;
      }
    }
    await _storage.savePrayerCompletion(today, streak);
    await _analytics.logPrayerCompleted(prayerId);
    await _analytics.logStreakIncremented('prayer', streak);
    state = AsyncData(
      current.copyWith(
        lastPrayerCompletionDate: today,
        prayerStreak: streak,
      ),
    );
  }

  Future<void> incrementShareCount() async {
    final current = state.requireValue;
    final updatedCount = current.shareCount + 1;
    await _storage.saveShareCount(updatedCount);
    state = AsyncData(current.copyWith(shareCount: updatedCount));
  }

  Future<void> joinPremiumWaitlist() async {
    final current = state.requireValue;
    if (!current.premiumWaitlistJoined) {
      await _storage.savePremiumWaitlistStatus(true);
      await _analytics.logPremiumWaitlistJoined();
    }
    state = AsyncData(current.copyWith(premiumWaitlistJoined: true));
  }

  Future<void> updateReminders(ReminderPreferences reminders) async {
    final current = state.requireValue;
    await _storage.saveReminders(reminders);
    state = AsyncData(current.copyWith(reminderPreferences: reminders));
  }

  Future<void> recordMandirVisit() async {
    final current = state.requireValue;
    final today = DateTime.now();
    final previous = current.lastMandirDate;
    var streak = current.mandirStreak;
    final isTodayAlready = isSameDate(previous, today);
    if (isTodayAlready) {
      return;
    }
    if (previous == null) {
      streak = 1;
    } else {
      final difference = DateTime(today.year, today.month, today.day)
          .difference(DateTime(previous.year, previous.month, previous.day))
          .inDays;
      if (difference == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
    }
    await _storage.saveMandirProgress(today, streak);
    await _analytics.logStreakIncremented('mandir', streak);
    state = AsyncData(
      current.copyWith(
        lastMandirDate: today,
        mandirStreak: streak,
      ),
    );
  }

  Deity deityById(String deityId) {
    return state.requireValue.seedContent.deities.firstWhere(
      (deity) => deity.id == deityId,
      orElse: () => state.requireValue.seedContent.deities.first,
    );
  }

  PrayerContent prayerById(String prayerId) {
    return state.requireValue.seedContent.prayers.firstWhere(
      (prayer) => prayer.id == prayerId,
      orElse: () => state.requireValue.seedContent.prayers.first,
    );
  }

  Festival festivalById(String festivalId) {
    return state.requireValue.seedContent.festivals.firstWhere(
      (festival) => festival.id == festivalId,
      orElse: () => state.requireValue.seedContent.festivals.first,
    );
  }

  ShareTemplate shareTemplate(String templateId) {
    return state.requireValue.seedContent.shareTemplates.firstWhere(
      (template) => template.id == templateId,
      orElse: () => const ShareTemplate(
        id: 'fallback',
        title: AppConstants.appName,
        subtitle: 'Made with Shanatani',
        watermark: 'Made with Shanatani 🙏',
      ),
    );
  }
}
