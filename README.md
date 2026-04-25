# Shanatani – Daily Puja, Aarti & Mandir

Android-first Flutter MVP for a Hindi-first devotional habit app focused on daily prayer completion, streaks, WhatsApp-first sharing, festival engagement, and premium-intent capture.

## Setup Instructions

1. Install Flutter stable and Android Studio.
2. Clone this repository.
3. Create `android/local.properties` with your local Flutter SDK path:

```properties
flutter.sdk=/path/to/flutter
sdk.dir=/path/to/android/sdk
```

4. Run:

```bash
flutter pub get
flutter run
```

5. Recommended first target: Android emulator or physical Android device.

## Release Publishing

See the full Google Play release checklist in [docs/google-play-release-checklist.md](/Users/ajitesh/Documents/New%20project%202/docs/google-play-release-checklist.md).

For Android signing setup:

1. Copy `android/key.properties.example` to `android/key.properties`
2. Create your upload keystore in `android/app/`
3. Fill in the real passwords and alias locally

## Firebase Setup Placeholders

- Add `google-services.json` to `android/app/` when Firebase is ready.
- Replace the current `AnalyticsService` abstraction with Firebase Analytics wiring.
- Replace the current `CrashlyticsService` abstraction with Firebase Crashlytics wiring.
- Add environment-specific Firebase initialization in `main.dart`.

## Play Store Publishing Checklist

- Confirm package name: `com.shanatani.app`
- Confirm publisher/display name: `Shanatani Digital`
- Add final launcher icon and feature graphic
- Add production privacy policy URL
- Add support email and contact details
- Finalize age/content rating
- Confirm devotional content rights and attribution policy
- Replace placeholder audio/video labels with licensed or original assets
- Test notification permission flow on Android 13+
- Validate WhatsApp fallback share flow on multiple OEM devices

## Privacy Policy Checklist

- Explain local storage usage for onboarding, streaks, reminders, share counts, and waitlist interest
- Explain any future analytics collection and opt-out policy
- Explain notification permission usage
- State that the app does not process real payments in the MVP
- State that premium clicks only record interest
- Avoid claims of official temple affiliation

## Content Strategy

- Daily habit loop centered on the forced prayer-start hook after onboarding
- Lightweight but consistent local seed library for mantras and aartis
- Festival countdowns designed to create return visits before major Hindu events
- Share-card surfaces across prayer completion, mandir actions, and festivals
- Hindi-first devotional voice with English fallback in onboarding
- Placeholder audio/video slots reserved for original or licensed future content

## Analytics Event List

- `app_open`
- `onboarding_completed`
- `language_selected`
- `deity_selected`
- `prayer_screen_shown`
- `prayer_started`
- `prayer_completed`
- `share_prompt_shown`
- `share_clicked`
- `whatsapp_share_clicked`
- `share_skipped`
- `streak_incremented`
- `diya_lit`
- `flower_offered`
- `bell_rang`
- `festival_viewed`
- `greeting_generated`
- `greeting_shared`
- `premium_button_clicked`
- `premium_waitlist_joined`
- `reminder_enabled`
- `notification_opened`

## Google Ads Campaign Notes

- Campaign 1: App installs, Hindi belt, devotional keywords
- Campaign 2: Festival-specific creative
- Campaign 3: WhatsApp share-card creatives
- Optimize for:
  - `onboarding_completed`
  - `prayer_completed`
  - `share_clicked`
  - `premium_button_clicked`

## Future Premium / Payment Roadmap

- Premium Aarti Collection Coming Soon
- Festival Pack Coming Soon
- HD Mantra Videos Coming Soon
- Original audio library with downloads
- Personalized puja calendars and richer Panchang
- Premium-only festival share-card themes
- Later optional billing integration after clear compliance, product, and content readiness
