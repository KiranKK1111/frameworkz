#!/usr/bin/env bash
# Builds FrameWorkz.app and wraps it in a drag-to-Applications DMG.
#
# Usage (on a Mac with Flutter + Xcode installed, or on the GitHub macOS runner):
#   chmod +x installer/macos/make_dmg.sh
#   ./installer/macos/make_dmg.sh [version]
#
# Unsigned by default (Gatekeeper warns on first launch). For a signed and
# notarized app that opens everywhere, set:
#   MACOS_P12_BASE64      base64 of the "Developer ID Application" certificate (.p12)
#   MACOS_P12_PASSWORD    its password
#   MACOS_SIGN_IDENTITY   "Developer ID Application: Your Name (TEAMID)"
#   APPLE_ID              Apple Account email
#   APPLE_TEAM_ID         10-character team id
#   APPLE_APP_PASSWORD    app-specific password (appleid.apple.com → App-Specific Passwords)
set -euo pipefail

VERSION="${1:-$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')}"
APP_NAME="FrameWorkz"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
DIST="installer/dist"
DMG="$DIST/$APP_NAME-$VERSION.dmg"
mkdir -p "$DIST"
rm -f "$DMG"

# ---- Import the signing certificate into a temporary keychain (CI) --------
if [[ -n "${MACOS_P12_BASE64:-}" ]]; then
  echo "▶ Importing Developer ID certificate"
  TMP="${RUNNER_TEMP:-$(mktemp -d)}"
  KEYCHAIN="$TMP/frameworkz-macos.keychain-db"
  KEYCHAIN_PW="$(openssl rand -hex 16)"
  echo "$MACOS_P12_BASE64" | base64 --decode > "$TMP/macos.p12"
  security create-keychain -p "$KEYCHAIN_PW" "$KEYCHAIN"
  security set-keychain-settings -lut 21600 "$KEYCHAIN"
  security unlock-keychain -p "$KEYCHAIN_PW" "$KEYCHAIN"
  # Apple's intermediate CA so the chain validates on a fresh runner.
  curl -sSL -o "$TMP/DeveloperIDG2CA.cer" https://www.apple.com/certificateauthority/DeveloperIDG2CA.cer
  security import "$TMP/DeveloperIDG2CA.cer" -k "$KEYCHAIN" -T /usr/bin/codesign >/dev/null 2>&1 || true
  security import "$TMP/macos.p12" -P "${MACOS_P12_PASSWORD:-}" -A -t cert -f pkcs12 -k "$KEYCHAIN"
  security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PW" "$KEYCHAIN" >/dev/null
  security list-keychain -d user -s "$KEYCHAIN" $(security list-keychains -d user | tr -d '"')
  security find-identity -v -p codesigning "$KEYCHAIN" | head -3
fi

echo "▶ Building $APP_NAME $VERSION for macOS…"
flutter build macos --release --build-name="$VERSION"
APP_PATH="build/macos/Build/Products/Release/$APP_NAME.app"

if [[ -n "${MACOS_SIGN_IDENTITY:-}" ]]; then
  echo "▶ Code-signing with $MACOS_SIGN_IDENTITY"
  codesign --deep --force --options runtime --timestamp \
    --entitlements macos/Runner/Release.entitlements \
    --sign "$MACOS_SIGN_IDENTITY" "$APP_PATH"
  codesign --verify --deep --strict "$APP_PATH"
fi

echo "▶ Creating DMG…"
if command -v create-dmg >/dev/null 2>&1; then
  create-dmg "$APP_PATH" "$DIST" --overwrite || true
  mv "$DIST"/*.dmg "$DMG" 2>/dev/null || true
fi
if [[ ! -f "$DMG" ]]; then
  STAGING="$(mktemp -d)"
  cp -R "$APP_PATH" "$STAGING/"
  ln -s /Applications "$STAGING/Applications"
  hdiutil create -volname "$APP_NAME" -srcfolder "$STAGING" -ov -format UDZO "$DMG"
  rm -rf "$STAGING"
fi

if [[ -n "${MACOS_SIGN_IDENTITY:-}" && -n "${APPLE_ID:-}" && -n "${APPLE_TEAM_ID:-}" && -n "${APPLE_APP_PASSWORD:-}" ]]; then
  echo "▶ Notarizing…"
  codesign --force --sign "$MACOS_SIGN_IDENTITY" "$DMG"
  xcrun notarytool submit "$DMG" --apple-id "$APPLE_ID" --team-id "$APPLE_TEAM_ID" --password "$APPLE_APP_PASSWORD" --wait
  xcrun stapler staple "$DMG"
  echo "▶ Notarized and stapled"
fi

echo "✅ Done: $DMG"
