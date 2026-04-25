# Google Play Release Checklist

This checklist is tailored to the current Flutter Android app in this repository.

## 1. Lock the release identity

- App name: `Shanatani`
- Android package name: `com.shanatani.app`
- Current version source: `pubspec.yaml`
- Release artifact: Android App Bundle (`.aab`)

Update the app version before every upload:

```yaml
version: 1.0.1+2
```

- `1.0.1` is the user-facing version name.
- `2` is the Play Store `versionCode` and must increase on every upload.

## 2. Create the release keystore

Run this once on your machine:

```bash
keytool -genkeypair \
  -v \
  -keystore android/app/shanatani-upload.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias shanatani-upload
```

Create `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=shanatani-upload
storeFile=app/shanatani-upload.jks
```

Notes:

- `android/key.properties` and `android/app/*.jks` are ignored by git.
- Release builds now fail fast if `android/key.properties` is missing.

## 3. Verify release metadata

Check these files before building:

- `pubspec.yaml`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/build.gradle.kts`

Release-ready expectations:

- Real app name in the manifest
- Production package name unchanged after Play Console app creation
- Version bumped for the upload

## 4. Prepare Play Store assets

Required:

- App icon: `512 x 512` PNG
- Feature graphic: `1024 x 500` PNG or JPG
- At least 2 phone screenshots
- Short description
- Full description
- Privacy policy URL
- Support email

Recommended for this app:

- 4 portrait screenshots at `1080 x 1920`
- English store listing
- Hindi store listing
- Screens showing onboarding, daily prayer, mandir, festivals, and sharing

## 5. Complete product and policy review

Before upload, confirm:

- All devotional text and images are original, licensed, public-domain, or properly attributed
- No placeholder premium wording suggests real billing
- No claim of official temple or religious authority affiliation unless true
- Privacy policy explains local storage, reminders, and sharing behavior
- Data safety answers match the shipped app, not future plans

Current codebase notes:

- App state is stored locally
- Reminder permissions are requested locally on device
- Premium flow records waitlist intent only
- Analytics service is currently a local debug abstraction, not Firebase collection

## 6. Run local validation

Use these commands:

```bash
flutter clean
flutter pub get
flutter test
flutter analyze
flutter build appbundle --release
```

Expected release output:

```text
build/app/outputs/bundle/release/app-release.aab
```

Manual checks on a device:

- Fresh install onboarding
- Reminder permission flow on Android 13+
- Share flow with WhatsApp installed
- Share flow without WhatsApp installed
- Festival and prayer screens render correctly
- No obvious text overflow on small screens

## 7. Create the Play Console app

In Play Console:

1. Create app
2. Choose default language
3. Set app type to `App`
4. Set pricing to `Free`
5. Opt in to Play App Signing
6. Upload the `.aab`
7. Complete Data safety
8. Complete Content rating
9. Add contact details
10. Add store listing assets and copy
11. Choose countries/regions

Useful Google docs:

- [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152)
- [Use Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)
- [Data safety form](https://support.google.com/googleplay/android-developer/answer/10787469)
- [Testing tracks](https://support.google.com/googleplay/android-developer/answer/9845334)
- [Preview assets](https://support.google.com/googleplay/android-developer/answer/9866151)

## 8. Test before production

Recommended rollout path:

1. Internal app sharing for quick install checks
2. Internal testing track
3. Closed testing track
4. Production rollout

Important:

- Some personal Play developer accounts must complete closed-testing requirements before production.
- Check your Play Console account status before planning the launch date.

## 9. Production rollout

For the first release, use staged rollout:

1. Start at `10%`
2. Watch crashes, ANRs, and store feedback
3. Increase to `25%`
4. Increase to `50%`
5. Move to `100%` when stable

## 10. Post-launch routine

For every update:

- Increase `versionCode`
- Re-run tests and analysis
- Build a new `.aab`
- Review Data safety if data practices changed
- Review release notes and staged rollout

If you later add Firebase, ads, login, or Play Billing:

- Update the privacy policy
- Update the Data safety form
- Re-check Play policy declarations before shipping
