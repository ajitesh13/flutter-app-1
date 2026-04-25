import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_models.dart';

final appStorageProvider = Provider<AppStorage>((ref) {
  throw UnimplementedError('AppStorage must be overridden at app start.');
});

class AppStorage {
  static const _boxName = 'shanatani_box';

  late final Box<dynamic> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  bool get onboardingComplete =>
      _box.get('onboarding_complete', defaultValue: false) as bool;
  UserProfile? get profile {
    final raw = _box.get('profile');
    if (raw is Map) {
      return UserProfile.fromJson(raw);
    }
    return null;
  }

  ReminderPreferences get reminders => ReminderPreferences.fromJson(
      _box.get('reminders') as Map<dynamic, dynamic>?);

  DateTime? get lastPrayerCompletionDate {
    final value = _box.get('last_prayer_completion_date');
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  int get prayerStreak => _box.get('prayer_streak', defaultValue: 0) as int;

  DateTime? get lastMandirDate {
    final value = _box.get('last_mandir_date');
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  int get mandirStreak => _box.get('mandir_streak', defaultValue: 0) as int;
  int get shareCount => _box.get('share_count', defaultValue: 0) as int;
  bool get premiumWaitlistJoined =>
      _box.get('premium_waitlist_joined', defaultValue: false) as bool;

  Future<void> saveOnboarding({
    required UserProfile profile,
    required ReminderPreferences reminders,
  }) async {
    await _box.put('onboarding_complete', true);
    await _box.put('profile', profile.toJson());
    await _box.put('reminders', reminders.toJson());
  }

  Future<void> savePrayerCompletion(DateTime completionDate, int streak) async {
    await _box.put(
        'last_prayer_completion_date', completionDate.toIso8601String());
    await _box.put('prayer_streak', streak);
  }

  Future<void> saveMandirProgress(DateTime completionDate, int streak) async {
    await _box.put('last_mandir_date', completionDate.toIso8601String());
    await _box.put('mandir_streak', streak);
  }

  Future<void> saveShareCount(int count) async {
    await _box.put('share_count', count);
  }

  Future<void> savePremiumWaitlistStatus(bool joined) async {
    await _box.put('premium_waitlist_joined', joined);
  }

  Future<void> saveReminders(ReminderPreferences reminders) async {
    await _box.put('reminders', reminders.toJson());
  }
}
