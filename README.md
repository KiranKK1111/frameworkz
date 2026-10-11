# FrameWorkz

**Business OS for creative studios.** Leads → follow-ups → clients → projects → finance,
with Google Calendar reminders and Gmail templates. One Flutter codebase for Windows (`.exe`),
macOS (`.dmg`), Android and iOS. No server, no spreadsheet maintenance.

> Replaces the Google Form + "LOKESH BUSINESS OS" workbook. The form keeps working as the
> public intake channel; FrameWorkz imports it and everything else is managed in the app.

## Run from source

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates lib/core/db/database.g.dart
flutter run -d windows        # or: flutter run -d macos / android / ios
```

Mobile builds and Google Sign-In setup: [docs/MOBILE.md](docs/MOBILE.md).

Requirements: Flutter 3.47+ with desktop enabled, Visual Studio 2022 C++ workload (Windows)
or Xcode (macOS).

## Project layout

```
lib/
  main.dart                 bootstrap: window, tray, DB, Google session, scheduler
  app/                      router, shell (sidebar + top bar), Bootstrap-flavoured theme
  core/
    db/                     Drift schema (tables.dart), database, repositories, seed data
    domain/                 enums with labels (LeadStatus, ServiceType, …)
    automation/             LeadAutomation (status → follow-up → calendar → email) + Scheduler
    google/                 OAuth (loopback), Calendar, Gmail, Sheets import
    email/                  {{placeholder}} engine, HTML wrapper, default templates
    notifications/          native desktop notifications
    settings/               typed settings (keys + defaults)
    providers.dart          Riverpod wiring and derived state
  ui/widgets/               Bz* design kit: buttons, badges, cards, modals, alerts, toasts, forms
  features/                 dashboard, leads, followups, calendar, clients, projects, finance,
                            email (composer + templates), settings
installer/                  Inno Setup script, DMG script, build helpers
.github/workflows/          CI that builds both installers on a version tag
```

## How the automation works

```
Lead status changes
  ├─ Last contact = today
  ├─ Next follow-up = today + rule(status)      (Settings → Follow-up rules)
  ├─ Previous pending follow-ups superseded
  ├─ Follow-up / meeting row created
  ├─ Google Calendar event (+ Meet link for meetings)   best effort
  └─ Email template for that status suggested → composer opens prefilled
```

The scheduler (every minute, also while minimised to the tray):
meeting alerts N minutes before, a daily follow-up digest at the chosen time,
overdue invoice detection, and optional polling of the form responses sheet.

## Packaging

See [installer/README.md](installer/README.md).

## Google setup (one-time)

Settings → Google account inside the app walks through creating a free "Desktop app"
OAuth client in Google Cloud Console (Calendar, Gmail, Sheets, Drive APIs). Tokens live in
the OS keychain.
