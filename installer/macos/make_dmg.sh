#!/usr/bin/env bash
# Builds FrameWorkz.app and wraps it in a drag-to-Applications DMG.
#
# Usage (on a Mac with Flutter + Xcode installed):
#   chmod +x installer/macos/make_dmg.sh
#   ./installer/macos/make_dmg.sh [version]
#
# Optional signing / notarization (recommended for distribution outside your own machines):
#   export MACOS_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"
#   export APPLE_ID="you@example.com" APPLE_TEAM_ID="TEAMID" APPLE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"
set -euo pipefail

VERSION="${1:-$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')}"
APP_NAME="FrameWorkz"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

echo "▶ Building $APP_NAME $VERSION for macOS…"
flutter build macos --release --build-name="$VERSION"

APP_PATH="build/macos/Build/Products/Release/$APP_NAME.app"
DIST="installer/dist"
DMG="$DIST/$APP_NAME-$VERSION.dmg"
mkdir -p "$DIST"
rm -f "$DMG"

if [[ -n "${MACOS_SIGN_IDENTITY:-}" ]]; then
  echo "▶ Code-signing with $MACOS_SIGN_IDENTITY"
  codesign --deep --force --options runtime --timestamp --sign "$MACOS_SIGN_IDENTITY" "$APP_PATH"
fi

echo "▶ Creating DMG…"
if command -v create-dmg >/dev/null 2>&1; then
  # npm i -g create-dmg  (sindresorhus/create-dmg) gives a polished layout automatically
  create-dmg "$APP_PATH" "$DIST" --overwrite || true
  mv "$DIST"/*.dmg "$DMG" 2>/dev/null || true
else
  STAGING="$(mktemp -d)"
  cp -R "$APP_PATH" "$STAGING/"
  ln -s /Applications "$STAGING/Applications"
  hdiutil create -volname "$APP_NAME" -srcfolder "$STAGING" -ov -format UDZO "$DMG"
  rm -rf "$STAGING"
fi

if [[ -n "${APPLE_ID:-}" && -n "${APPLE_TEAM_ID:-}" && -n "${APPLE_APP_PASSWORD:-}" ]]; then
  echo "▶ Notarizing…"
  xcrun notarytool submit "$DMG" --apple-id "$APPLE_ID" --team-id "$APPLE_TEAM_ID" --password "$APPLE_APP_PASSWORD" --wait
  xcrun stapler staple "$DMG"
fi

echo "✅ Done: $DMG"
