import 'dart:convert';

class ReminderPreferences {
  const ReminderPreferences({
    required this.morningPrayer,
    required this.eveningAarti,
    required this.festivalReminders,
  });

  final bool morningPrayer;
  final bool eveningAarti;
  final bool festivalReminders;

  ReminderPreferences copyWith({
    bool? morningPrayer,
    bool? eveningAarti,
    bool? festivalReminders,
  }) {
    return ReminderPreferences(
      morningPrayer: morningPrayer ?? this.morningPrayer,
      eveningAarti: eveningAarti ?? this.eveningAarti,
      festivalReminders: festivalReminders ?? this.festivalReminders,
    );
  }

  Map<String, dynamic> toJson() => {
        'morningPrayer': morningPrayer,
        'eveningAarti': eveningAarti,
        'festivalReminders': festivalReminders,
      };

  factory ReminderPreferences.fromJson(Map<dynamic, dynamic>? json) {
    return ReminderPreferences(
      morningPrayer: json?['morningPrayer'] == true,
      eveningAarti: json?['eveningAarti'] == true,
      festivalReminders: json?['festivalReminders'] == true,
    );
  }

  static const defaults = ReminderPreferences(
    morningPrayer: true,
    eveningAarti: true,
    festivalReminders: true,
  );
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.language,
    required this.favouriteDeityId,
  });

  final String name;
  final String language;
  final String favouriteDeityId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'language': language,
        'favouriteDeityId': favouriteDeityId,
      };

  factory UserProfile.fromJson(Map<dynamic, dynamic>? json) {
    return UserProfile(
      name: (json?['name'] ?? '') as String,
      language: (json?['language'] ?? 'Hindi') as String,
      favouriteDeityId: (json?['favouriteDeityId'] ?? 'ram') as String,
    );
  }
}

class Deity {
  const Deity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.blessing,
    required this.primaryColor,
    required this.secondaryColor,
    required this.defaultMantra,
  });

  final String id;
  final String name;
  final String emoji;
  final String blessing;
  final String primaryColor;
  final String secondaryColor;
  final String defaultMantra;

  factory Deity.fromJson(Map<String, dynamic> json) {
    return Deity(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      blessing: json['blessing'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      defaultMantra: json['defaultMantra'] as String,
    );
  }
}

class PrayerContent {
  const PrayerContent({
    required this.id,
    required this.title,
    required this.deityId,
    required this.hindiText,
    required this.transliteration,
    required this.meaning,
    required this.audioLabel,
    required this.videoLabel,
    required this.isPlaceholder,
  });

  final String id;
  final String title;
  final String deityId;
  final String hindiText;
  final String transliteration;
  final String meaning;
  final String audioLabel;
  final String videoLabel;
  final bool isPlaceholder;

  List<String> get verses => const LineSplitter().convert(hindiText);

  factory PrayerContent.fromJson(Map<String, dynamic> json) {
    return PrayerContent(
      id: json['id'] as String,
      title: json['title'] as String,
      deityId: json['deityId'] as String,
      hindiText: json['hindiText'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      audioLabel: json['audioLabel'] as String,
      videoLabel: json['videoLabel'] as String,
      isPlaceholder: json['isPlaceholder'] == true,
    );
  }
}

class Festival {
  const Festival({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.checklist,
    required this.recommendedPrayerId,
  });

  final String id;
  final String title;
  final DateTime date;
  final String description;
  final List<String> checklist;
  final String recommendedPrayerId;

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      checklist: (json['checklist'] as List<dynamic>).cast<String>(),
      recommendedPrayerId: json['recommendedPrayerId'] as String,
    );
  }
}

class ShareTemplate {
  const ShareTemplate({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.watermark,
  });

  final String id;
  final String title;
  final String subtitle;
  final String watermark;

  factory ShareTemplate.fromJson(Map<String, dynamic> json) {
    return ShareTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      watermark: json['watermark'] as String,
    );
  }
}

class SeedContent {
  const SeedContent({
    required this.deities,
    required this.prayers,
    required this.festivals,
    required this.shareTemplates,
  });

  final List<Deity> deities;
  final List<PrayerContent> prayers;
  final List<Festival> festivals;
  final List<ShareTemplate> shareTemplates;
}

class AppViewState {
  const AppViewState({
    required this.seedContent,
    required this.onboardingComplete,
    required this.profile,
    required this.reminderPreferences,
    required this.lastPrayerCompletionDate,
    required this.prayerStreak,
    required this.lastMandirDate,
    required this.mandirStreak,
    required this.shareCount,
    required this.premiumWaitlistJoined,
  });

  final SeedContent seedContent;
  final bool onboardingComplete;
  final UserProfile? profile;
  final ReminderPreferences reminderPreferences;
  final DateTime? lastPrayerCompletionDate;
  final int prayerStreak;
  final DateTime? lastMandirDate;
  final int mandirStreak;
  final int shareCount;
  final bool premiumWaitlistJoined;

  AppViewState copyWith({
    SeedContent? seedContent,
    bool? onboardingComplete,
    UserProfile? profile,
    ReminderPreferences? reminderPreferences,
    DateTime? lastPrayerCompletionDate,
    int? prayerStreak,
    DateTime? lastMandirDate,
    int? mandirStreak,
    int? shareCount,
    bool? premiumWaitlistJoined,
    bool resetPrayerDate = false,
    bool resetMandirDate = false,
  }) {
    return AppViewState(
      seedContent: seedContent ?? this.seedContent,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      profile: profile ?? this.profile,
      reminderPreferences: reminderPreferences ?? this.reminderPreferences,
      lastPrayerCompletionDate: resetPrayerDate
          ? null
          : lastPrayerCompletionDate ?? this.lastPrayerCompletionDate,
      prayerStreak: prayerStreak ?? this.prayerStreak,
      lastMandirDate:
          resetMandirDate ? null : lastMandirDate ?? this.lastMandirDate,
      mandirStreak: mandirStreak ?? this.mandirStreak,
      shareCount: shareCount ?? this.shareCount,
      premiumWaitlistJoined:
          premiumWaitlistJoined ?? this.premiumWaitlistJoined,
    );
  }

  bool get hasCompletedPrayerToday {
    final now = DateTime.now();
    return lastPrayerCompletionDate?.year == now.year &&
        lastPrayerCompletionDate?.month == now.month &&
        lastPrayerCompletionDate?.day == now.day;
  }
}
