# Packaging FrameWorkz

FrameWorkz is a single self-contained desktop app: the Flutter UI, the automation
engine, the SQLite database and the Google integrations all live in one
executable bundle. There is no server to deploy. Users install one file.

| Target | Output | How |
| --- | --- | --- |
| Windows installer | `installer/dist/FrameWorkz-Setup-<ver>.exe` | `.\installer\windows\build_installer.ps1` |
| Windows portable | zip of `build/windows/x64/runner/Release/` | `flutter build windows --release` then zip |
| Windows MSIX (Store / winget) | `build/windows/x64/runner/Release/frameworkz.msix` | `flutter build windows --release && dart run msix:create` |
| macOS DMG | `installer/dist/FrameWorkz-<ver>.dmg` | `./installer/macos/make_dmg.sh` (on a Mac) |
| Both, automatically | GitHub Release assets | push a tag `v1.0.0` (see `.github/workflows/release.yml`) |

## Windows (.exe installer)

1. Install [Inno Setup 6](https://jrsoftware.org/isinfo.php): `winget install JRSoftware.InnoSetup`
2. From the project root run `.\installer\windows\build_installer.ps1`
3. Ship `installer\dist\FrameWorkz-Setup-1.0.0.exe`

The installer bundles the Visual C++ runtime, creates Start-menu and optional
desktop shortcuts, offers "start at sign-in", and leaves the user's database
(`%APPDATA%\com.frameworkz\frameworkz\FrameWorkz\frameworkz.sqlite`) untouched on
uninstall.

## iOS (.ipa)

On a Mac: `./installer/ios/build_ipa.sh`. Unsigned by default; set `IOS_P12_BASE64`,
`IOS_P12_PASSWORD`, `IOS_PROVISIONING_PROFILE_BASE64` and `IOS_TEAM_ID` for a signed
App Store build (uses `installer/ios/ExportOptions.plist`). Before shipping, replace the
`YOUR_IOS_CLIENT_ID` placeholders in `ios/Runner/Info.plist` with your iOS OAuth client so
Google Sign-In works.

## macOS (.dmg)

macOS apps can only be built on macOS. On a Mac with Flutter and Xcode:

```bash
./installer/macos/make_dmg.sh
```

For distribution outside your own machines, sign and notarize so Gatekeeper
does not warn. Set `MACOS_SIGN_IDENTITY`, `APPLE_ID`, `APPLE_TEAM_ID` and
`APPLE_APP_PASSWORD` before running the script. Without a Developer ID the app
still works: right-click → Open the first time.

## One-time Google setup for the person installing

FrameWorkz talks to Google Calendar, Gmail, Sheets and Drive with the user's own
Google account via OAuth. The person who owns the installation creates one
free "Desktop app" OAuth client in Google Cloud Console (Settings → Google
account inside the app has the step-by-step guide with links) and pastes the
Client ID / Secret once. Tokens are stored in the OS keychain.

If you distribute FrameWorkz to several people, you can ship your own OAuth
client and pre-fill it by placing a `google_client.json` next to the
executable, or simply let each user paste theirs — both work.
