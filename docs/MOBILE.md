# FrameWorkz on Android and iOS

The same codebase builds the phone apps. Below 700 dp the UI switches to the
mobile shell (bottom navigation, floating **New** button, bottom sheets instead
of modals, card lists instead of tables); above that it is the desktop layout.
Platform services are swapped automatically:

| Concern | Desktop | Mobile |
| --- | --- | --- |
| Google sign-in | Loopback OAuth (Desktop app client) | Native Google Sign-In (`google_sign_in`) |
| Reminders | Live scheduler in the tray | Pre-scheduled local notifications (next 30 days), re-planned whenever follow-ups change |
| Window / tray / autostart | window_manager, tray_manager, launch_at_startup | not used |
| Refresh rate | OS default | Android: highest panel rate via `flutter_displaymode`; iOS: `CADisableMinimumFrameDurationOnPhone` (ProMotion 120 Hz) |
| Orientation | any | portrait |

## Build requirements

- Android: Android Studio (SDK 35, build-tools, NDK) and a JDK 17. `flutter doctor` must show the Android toolchain as OK.
- iOS: a Mac with Xcode 16+ and CocoaPods. Only macOS can build iOS apps.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run flutter_launcher_icons            # app icons (already generated)

flutter build apk --release                # android/…/app-release.apk
flutter build appbundle --release          # Play Store bundle
flutter build ipa --release                # on macOS, after signing setup
```

## Emulator on this PC (already set up)

The Android SDK lives in `C:\Android\sdk` (command-line tools, platform 36, build-tools 36,
NDK 28.2, emulator, `system-images;android-36;google_apis;x86_64`) and a Pixel 7 virtual
device named `frameworkz_pixel` exists. `ANDROID_HOME` is set and `flutter doctor` is green.

```powershell
# start the emulator (WHPX acceleration is enabled on this machine)
C:\Android\sdk\emulator\emulator.exe -avd frameworkz_pixel -no-snapshot-load -gpu auto
# in another terminal
flutter run -d emulator-5554
```

Two settings in `android/gradle.properties` matter on this 16 GB machine: Kotlin incremental
compilation is off (its cache files failed to close on Windows), and the Gradle heap is capped at
3 GB so the emulator, Gradle and the Flutter compiler fit together. If a build dies with
"Exhausted heap space", run `android\gradlew --stop` to kill stale daemons and retry.

## Google Sign-In setup (one-time)

Mobile cannot use the Desktop OAuth client. In the same Google Cloud project:

### Android
1. Get the signing fingerprint: `cd android && ./gradlew signingReport` (debug) or from your release keystore.
2. Credentials → Create OAuth client ID → **Android**, package `com.frameworkz.frameworkz`, paste the SHA-1.
3. Credentials → Create OAuth client ID → **Web application** (no redirect URIs needed). Copy its client id and paste it in
   Settings → Google account → "Web client ID" inside the app. Google Sign-In on Android requires this `serverClientId`.

### iOS
1. Credentials → Create OAuth client ID → **iOS**, bundle id `com.frameworkz.frameworkz`.
2. Put the client id in `ios/Runner/Info.plist` (`GIDClientID`) and the reversed id in `CFBundleURLSchemes` (both placeholders are marked `YOUR_IOS_CLIENT_ID`).
3. Alternatively paste the iOS client id in Settings → Google account → "iOS client id"; the app passes it to the SDK at runtime.

The scopes requested are the same as on desktop (Calendar events, Gmail send, Sheets read-only, Drive file).

## Notifications

- Android 13+ asks for the notification permission on first launch; exact-alarm permission is requested for precise meeting reminders.
- iOS asks for alert/badge/sound permission on first launch.
- Reminders are planned by `AutomationScheduler.planMobileNotifications()`; tapping one deep-links to the lead or the follow-ups list.

## Data on multiple devices

Each installation keeps its own data (SQLite under the hood, mirrored to the
user's `FrameWorkz.xlsx` workbook — Settings → Excel workbook). Desktop and
phone do **not** share data automatically yet. Today the workbook is the bridge:
share it from the phone (Settings → Excel workbook → Share) and use
"Read workbook" / "Open existing…" on the other device; rows are matched by
their ID column. Two options for true sync, to decide later:

1. **Drive-file sync (keeps the no-server design).** Upload the SQLite file to the
   user's Drive `appDataFolder` after changes, download on launch, last writer
   wins. Fine for one person who uses one device at a time.
2. **Hosted backend (Supabase / Firebase).** Real multi-device, multi-user,
   realtime. Adds an account system and a monthly cost once past the free tier.

The repositories in `lib/core/db/repos.dart` are the only code that touches
storage, so either option plugs in underneath without changing screens.
