import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/responsive.dart';
import '../../app/theme/bz_colors.dart';
import '../../core/platform.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_alert.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_misc.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

enum _Section { profile, rules, reminders, google, sheets, app, about }

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});
  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  _Section _section = _Section.profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <(_Section, String, IconData, String)>[
      (_Section.profile, 'Profile', BootstrapIcons.person_badge, 'Name, studio, signature'),
      (_Section.rules, 'Follow-up rules', BootstrapIcons.sliders, 'Days per status'),
      (_Section.reminders, 'Reminders', BootstrapIcons.bell, 'Daily time, meeting alerts'),
      (_Section.google, 'Google account', BootstrapIcons.google, 'Calendar, Meet, Gmail'),
      (_Section.sheets, 'Google Sheets import', BootstrapIcons.file_earmark_spreadsheet, 'Migrate & sync the form'),
      (_Section.app, 'Appearance & behaviour', BootstrapIcons.display, 'Theme, tray, startup'),
      (_Section.about, 'About', BootstrapIcons.info_circle, 'Version, data location'),
    ];
    Widget sectionWidget(_Section s) => switch (s) {
          _Section.profile => const _ProfileSection(),
          _Section.rules => const _RulesSection(),
          _Section.reminders => const _RemindersSection(),
          _Section.google => const _GoogleSection(),
          _Section.sheets => const _SheetsSection(),
          _Section.app => const _AppSection(),
          _Section.about => const _AboutSection(),
        };

    if (context.isPhone) {
      // Phone: a settings list; each section opens as a full-height sheet.
      return BzPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BzPageHeader(title: 'Settings', subtitle: 'Everything saves automatically.'),
            BzCard(
              padding: const EdgeInsets.all(6),
              child: Column(children: [
                for (var i = 0; i < items.length; i++) ...[
                  BzHoverRow(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                    onTap: () => showBzModal(
                      context: context,
                      title: items[i].$2,
                      subtitle: items[i].$4,
                      icon: items[i].$3,
                      fullscreenOnPhone: true,
                      bodyPadding: const EdgeInsets.all(12),
                      child: sectionWidget(items[i].$1),
                    ),
                    child: Row(children: [
                      Container(width: 38, height: 38, decoration: BoxDecoration(color: BzColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(11)), alignment: Alignment.center, child: Icon(items[i].$3, size: 16, color: BzColors.primary)),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(items[i].$2, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15)),
                        Text(items[i].$4, style: theme.textTheme.bodySmall),
                      ])),
                      Icon(BootstrapIcons.chevron_right, size: 13, color: theme.colorScheme.onSurfaceVariant),
                    ]),
                  ),
                  if (i < items.length - 1) const Divider(),
                ],
              ]),
            ),
          ],
        ),
      );
    }

    return BzPage(
      scroll: false,
      maxWidth: 1400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BzPageHeader(title: 'Settings', subtitle: 'Everything saves automatically.', icon: BootstrapIcons.gear),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.isTablet ? 220 : 280,
                  child: BzCard(
                    padding: const EdgeInsets.all(8),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      for (final it in items)
                        BzHoverRow(
                          selected: _section == it.$1,
                          onTap: () => setState(() => _section = it.$1),
                          child: Row(children: [
                            Icon(it.$3, size: 15, color: _section == it.$1 ? BzColors.primary : theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(it.$2, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                              Text(it.$4, style: theme.textTheme.bodySmall),
                            ])),
                          ]),
                        ),
                    ]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: KeyedSubtree(
                      key: ValueKey(_section),
                      child: sectionWidget(_section).animate().fadeIn(duration: 200.ms).slideY(begin: 0.02, end: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Text setting that persists on blur / submit.
class _SettingText extends ConsumerStatefulWidget {
  const _SettingText({required this.settingKey, required this.label, this.hint, this.obscure = false, this.icon, this.maxLines = 1, this.help});
  final String settingKey;
  final String label;
  final String? hint;
  final bool obscure;
  final IconData? icon;
  final int maxLines;
  final String? help;


  @override
  ConsumerState<_SettingText> createState() => _SettingTextState();
}

class _SettingTextState extends ConsumerState<_SettingText> {
  late final TextEditingController _c;
  final _focus = FocusNode();
  String _initial = '';

  @override
  void initState() {
    super.initState();
    _initial = ref.read(settingsSnapshotProvider).raw(widget.settingKey) ?? '';
    _c = TextEditingController(text: _initial);
    _focus.addListener(() {
      if (!_focus.hasFocus) _save();
    });
  }

  @override
  void dispose() {
    _save();
    _focus.dispose();
    _c.dispose();
    super.dispose();
  }

  void _save() {
    final v = _c.text.trim();
    if (v == _initial) return;
    _initial = v;
    ref.read(databaseProvider).setSetting(widget.settingKey, v);
  }

  @override
  Widget build(BuildContext context) {
    return BzField(
      label: widget.label,
      help: widget.help,
      child: BzTextField(controller: _c, focusNode: _focus, hint: widget.hint, obscure: widget.obscure, prefixIcon: widget.icon, maxLines: widget.maxLines, minLines: widget.maxLines > 1 ? 3 : null, onSubmitted: (_) => _save()),
    );
  }
}

// ----------------------------------------------------------------- profile
class _ProfileSection extends ConsumerWidget {
  const _ProfileSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'Your profile',
        subtitle: 'Used in email templates as {{my_name}}, {{my_business}}, {{my_phone}}, {{signature}}…',
        child: Column(children: [
          const BzRow([
            _SettingText(settingKey: Keys.profileName, label: 'Your name', hint: 'Lokesh Kumar', icon: BootstrapIcons.person),
            _SettingText(settingKey: Keys.profileBusiness, label: 'Studio / business name', hint: 'Lokesh Films', icon: BootstrapIcons.building),
          ]),
          const SizedBox(height: 14),
          const BzRow([
            _SettingText(settingKey: Keys.profilePhone, label: 'Phone', hint: '+91 98765 43210', icon: BootstrapIcons.telephone),
            _SettingText(settingKey: Keys.profileEmail, label: 'Email (reply-to)', hint: 'Defaults to the connected Gmail', icon: BootstrapIcons.at),
          ]),
          const SizedBox(height: 14),
          const BzRow([
            _SettingText(settingKey: Keys.profileWebsite, label: 'Website', hint: 'https://', icon: BootstrapIcons.globe),
            _SettingText(settingKey: Keys.profileInstagram, label: 'Instagram', hint: '@handle', icon: BootstrapIcons.instagram),
          ]),
          const SizedBox(height: 14),
          const _SettingText(settingKey: Keys.profileSignature, label: 'Email signature', hint: 'Leave empty to auto-generate from the fields above', maxLines: 4, help: 'Plain text. Each line becomes a line in the email.'),
        ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------------- rules
class _RulesSection extends ConsumerWidget {
  const _RulesSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = ref.watch(settingsSnapshotProvider);
    final rules = s.followUpRules;
    Future<void> set(LeadStatus st, int? days) async {
      final next = Map<LeadStatus, int?>.from(rules)..[st] = days;
      await ref.setSetting(Keys.followUpRules, AppSettingsState.encodeRules(next));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'Follow-up rules',
        subtitle: 'When a lead moves to a status, the next follow-up is scheduled this many days later. "Call Scheduled" uses the meeting date instead.',
        child: Column(children: [
          for (final st in LeadStatus.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                SizedBox(width: context.isPhone ? 130 : 170, child: LeadStatusBadge(st, withIcon: true)),
                if (!context.isPhone) Expanded(child: Text(_ruleHint(st), style: theme.textTheme.bodySmall)) else const Spacer(),
                SizedBox(
                  width: context.isPhone ? 150 : 190,
                  child: st == LeadStatus.callScheduled
                      ? Text('Meeting date & time', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic))
                      : BzDropdown<int?>(
                          value: rules[st],
                          items: const [null, 0, 1, 2, 3, 4, 5, 7, 10, 14, 21, 30, 45, 60, 90],
                          labelOf: (d) => d == null ? 'No follow-up' : (d == 0 ? 'Same day' : (d == 1 ? 'Next day' : 'In $d days')),
                          onChanged: (d) => set(st, d),
                        ),
                ),
              ]),
            ),
          const Divider(height: 24),
          Row(children: [
            Expanded(child: Text('Reminder time for all-day follow-ups (also used for the Google Calendar block)', style: theme.textTheme.bodyMedium)),
            SizedBox(
              width: 190,
              child: BzDropdown<int>(value: s.followUpHour, items: List.generate(14, (i) => i + 7), labelOf: (h) => Fmt.time(DateTime(2000, 1, 1, h)), onChanged: (h) => ref.setSetting(Keys.followUpHour, '${h ?? 10}')),
            ),
          ]),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: BzButton(label: 'Reset to recommended', icon: BootstrapIcons.arrow_counterclockwise, variant: BzVariant.light, size: BzSize.sm, onPressed: () => ref.setSetting(Keys.followUpRules, AppSettingsState.encodeRules(AppSettingsState.defaultFollowUpRules)))),
        ]),
      ),
    ]);
  }

  static String _ruleHint(LeadStatus s) => switch (s) {
        LeadStatus.newLead => 'A new enquiry arrives (form or manual)',
        LeadStatus.contacted => 'You reached out, waiting for a reply',
        LeadStatus.replied => 'They replied — keep the momentum',
        LeadStatus.callScheduled => 'A discovery call is booked',
        LeadStatus.proposalSent => 'Proposal is with them',
        LeadStatus.negotiation => 'Discussing scope / price',
        LeadStatus.nurture => 'Not now — stay warm',
        LeadStatus.won => 'Converted to client',
        LeadStatus.lost => 'Closed, keep the door open',
      };
}

// --------------------------------------------------------------- reminders
class _RemindersSection extends ConsumerWidget {
  const _RemindersSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsSnapshotProvider);
    final parts = s.dailyReminderTime.split(':');
    final tod = TimeOfDay(hour: int.tryParse(parts.first) ?? 9, minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 30 : 30);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'Reminders & notifications',
        subtitle: 'FrameWorkz keeps running in the system tray, so reminders fire even when the window is closed.',
        child: Column(children: [
          BzRow([
            BzField(
              label: 'Daily follow-up reminder at',
              help: 'All follow-ups due today (and overdue ones) are announced once a day at this time.',
              child: BzTimeField(value: tod, onChanged: (t) => ref.setSetting(Keys.dailyReminderTime, '${t!.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')),
            ),
            BzField(
              label: 'Meeting alert',
              help: 'How long before a meeting you get notified (also the Google Calendar popup).',
              child: BzDropdown<int>(value: s.meetingLeadMinutes, items: const [5, 10, 15, 30, 60], labelOf: (m) => '$m minutes before', onChanged: (m) => ref.setSetting(Keys.meetingLeadMinutes, '${m ?? 15}')),
            ),
          ]),
          const SizedBox(height: 10),
          BzSwitchTile(title: 'Desktop notifications', subtitle: 'Windows Action Center / macOS Notification Center. In-app toasts always show.', icon: BootstrapIcons.bell, value: s.osNotifications, onChanged: (v) => ref.setSetting(Keys.osNotifications, '$v')),
          BzSwitchTile(title: 'Morning digest', subtitle: 'One summary notification with meetings, follow-ups and overdue items for the day.', icon: BootstrapIcons.sun, value: s.overdueDigest, onChanged: (v) => ref.setSetting(Keys.overdueDigest, '$v')),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: BzButton(
              label: 'Send a test notification',
              icon: BootstrapIcons.send,
              variant: BzVariant.light,
              size: BzSize.sm,
              onPressed: () {
                ref.read(notificationServiceProvider).show(title: 'FrameWorkz test 🔔', body: 'This is how reminders will look.');
                BzToasts.reminder('Test reminder', message: 'In-app toasts look like this.');
              },
            ),
          ),
        ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------------ google
class _GoogleSection extends ConsumerStatefulWidget {
  const _GoogleSection();
  @override
  ConsumerState<_GoogleSection> createState() => _GoogleSectionState();
}

class _GoogleSectionState extends ConsumerState<_GoogleSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = ref.watch(settingsSnapshotProvider);
    final g = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    final auth = ref.read(googleAuthProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'Google account',
        subtitle: 'One sign-in powers Calendar events, Meet links, Gmail sending and Sheets import.',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (g.connected ? BzColors.success : BzColors.warning).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: (g.connected ? BzColors.success : BzColors.warning).withValues(alpha: 0.35)),
            ),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const Icon(BootstrapIcons.google, size: 18, color: BzColors.primary)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(g.connected ? 'Connected${g.email != null ? ' as ${g.email}' : ''}' : (s.googleConfigured ? 'Not connected' : 'Set up required'), style: theme.textTheme.titleSmall),
                  Text(g.connected ? 'Calendar · Gmail · Sheets · Drive access granted' : (s.googleConfigured ? 'Click Connect to sign in with your Google account' : 'Paste your OAuth client details below, then connect'), style: theme.textTheme.bodySmall),
                  if (g.error != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(g.error!, style: theme.textTheme.bodySmall?.copyWith(color: BzColors.danger))),
                ]),
              ),
              if (g.connected)
                BzButton(
                  label: 'Disconnect',
                  icon: BootstrapIcons.box_arrow_right,
                  variant: BzVariant.danger,
                  outline: true,
                  onPressed: () async {
                    await auth.disconnect();
                    await ref.setSetting(Keys.googleEmail, '');
                    BzToasts.info('Google account disconnected');
                  },
                )
              else
                BzButton(
                  label: g.busy ? 'Waiting for browser…' : 'Connect Google',
                  icon: BootstrapIcons.google,
                  loading: g.busy,
                  onPressed: g.busy || !s.googleConfigured
                      ? null
                      : () async {
                          final ok = await auth.connect();
                          if (ok) BzToasts.success('Google connected', message: 'Calendar reminders and Gmail sending are now active.');
                        },
                ),
            ]),
          ),
          const SizedBox(height: 16),
          if (AppPlatform.isDesktop)
            const BzRow([
              _SettingText(settingKey: Keys.googleClientId, label: 'OAuth Client ID (Desktop app)', hint: '1234567890-abc.apps.googleusercontent.com', icon: BootstrapIcons.key),
              _SettingText(settingKey: Keys.googleClientSecret, label: 'OAuth Client Secret', hint: 'GOCSPX-…', icon: BootstrapIcons.shield_lock, obscure: true),
            ])
          else
            const BzRow([
              _SettingText(settingKey: Keys.googleServerClientId, label: 'Web client ID (required on Android)', hint: '1234567890-web.apps.googleusercontent.com', icon: BootstrapIcons.key, help: 'Create a "Web application" OAuth client and an "Android" client with your SHA-1 in the same project.'),
              _SettingText(settingKey: Keys.googleMobileClientId, label: 'iOS client ID', hint: '1234567890-ios.apps.googleusercontent.com', icon: BootstrapIcons.apple),
            ]),
          const SizedBox(height: 12),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text('How to get these (one-time, ~5 minutes)', style: theme.textTheme.titleSmall),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            children: [
              _step(theme, 1, 'Open Google Cloud Console → create a project (e.g. "FrameWorkz").', 'https://console.cloud.google.com/projectcreate'),
              _step(theme, 2, 'APIs & Services → Library: enable Google Calendar API, Gmail API, Google Sheets API and Google Drive API.', 'https://console.cloud.google.com/apis/library'),
              _step(theme, 3, 'OAuth consent screen: External, add your Gmail address as a test user, add the scopes for Calendar events, Gmail send, Sheets read-only, Drive file.', 'https://console.cloud.google.com/apis/credentials/consent'),
              _step(theme, 4, 'Credentials → Create credentials → OAuth client ID → Application type "Desktop app". Copy the Client ID and Client Secret here.', 'https://console.cloud.google.com/apis/credentials'),
              _step(theme, 5, 'Click "Connect Google". A browser opens, you approve, and FrameWorkz receives the token on localhost. Tokens are stored in your OS keychain.', null),
            ],
          ),
        ]),
      ),
      const SizedBox(height: 16),
      BzCard(
        title: 'Calendar & Gmail options',
        child: Column(children: [
          BzSwitchTile(title: 'Mirror follow-ups and meetings to Google Calendar', subtitle: 'Events carry a popup reminder; rescheduling or completing updates/removes them.', icon: BootstrapIcons.calendar_check, value: s.calendarSync, onChanged: (v) => ref.setSetting(Keys.calendarSync, '$v')),
          BzSwitchTile(title: 'Create a Google Meet link for meetings', subtitle: 'The link is stored on the follow-up and available as {{meet_link}} in emails.', icon: BootstrapIcons.camera_video, value: s.calendarCreateMeet, onChanged: (v) => ref.setSetting(Keys.calendarCreateMeet, '$v')),
          BzSwitchTile(title: 'Invite the contact to meetings', subtitle: 'Google sends a calendar invitation to the lead\'s email address.', icon: BootstrapIcons.person_plus, value: s.calendarInviteContacts, onChanged: (v) => ref.setSetting(Keys.calendarInviteContacts, '$v')),
          BzSwitchTile(title: 'Send emails through Gmail', subtitle: 'Templated emails go out from your connected Gmail account.', icon: BootstrapIcons.envelope, value: s.gmailEnabled, onChanged: (v) => ref.setSetting(Keys.gmailEnabled, '$v')),
          const SizedBox(height: 10),
          const BzRow([
            _SettingText(settingKey: Keys.calendarId, label: 'Calendar ID', hint: 'primary', icon: BootstrapIcons.calendar3, help: 'Leave as "primary" or paste a secondary calendar\'s ID.'),
            _SettingText(settingKey: Keys.timeZone, label: 'Time zone', hint: 'Asia/Kolkata', icon: BootstrapIcons.globe),
          ]),
        ]),
      ),
    ]);
  }

  Widget _step(ThemeData theme, int n, String text, String? url) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 22, height: 22, decoration: BoxDecoration(color: BzColors.primary.withValues(alpha: 0.12), shape: BoxShape.circle), alignment: Alignment.center, child: Text('$n', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: BzColors.primary))),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          if (url != null) BzButton(label: 'Open', size: BzSize.sm, link: true, trailingIcon: BootstrapIcons.box_arrow_up_right, onPressed: () => launchUrl(Uri.parse(url))),
        ]),
      );
}

// ------------------------------------------------------------------ sheets
class _SheetsSection extends ConsumerStatefulWidget {
  const _SheetsSection();
  @override
  ConsumerState<_SheetsSection> createState() => _SheetsSectionState();
}

class _SheetsSectionState extends ConsumerState<_SheetsSection> {
  bool _importing = false;

  Future<void> _import({required bool formOnly}) async {
    final s = ref.read(settingsSnapshotProvider);
    final g = ref.read(googleAuthProvider);
    if (!g.isConnected) {
      BzToasts.warning('Connect Google first', message: 'The import reads your sheet through the Google Sheets API.');
      return;
    }
    if (s.sheetsSpreadsheetId.isEmpty) {
      BzToasts.warning('Paste the spreadsheet link or ID first');
      return;
    }
    setState(() => _importing = true);
    try {
      final r = await ref.read(schedulerProvider).importNow(s.sheetsSpreadsheetId, formResponsesOnly: formOnly);
      if (!mounted) return;
      await showBzModal(
        context: context,
        title: 'Import complete',
        icon: BootstrapIcons.check_circle_fill,
        variant: BzVariant.success,
        width: 560,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          _count('Leads (LEADS sheet)', r.leads),
          _count('Leads (Form responses)', r.formLeads),
          _count('Clients', r.clients),
          _count('Projects', r.projects),
          _count('Follow-ups', r.followUps),
          _count('Invoices (FINANCE)', r.invoices),
          _count('Skipped (already imported)', r.skipped),
          if (r.errors.isNotEmpty) ...[
            const SizedBox(height: 12),
            BzAlert(variant: BzVariant.warning, title: '${r.errors.length} rows need attention', message: r.errors.take(6).join('\n')),
          ],
        ]),
        actions: [BzButton(label: 'Done', onPressed: () => Navigator.of(context).pop())],
      );
    } catch (e) {
      BzToasts.error('Import failed', message: e.toString());
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Widget _count(String label, int n) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [Expanded(child: Text(label)), BzBadge('$n', variant: n > 0 ? BzVariant.success : BzVariant.secondary)]),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = ref.watch(settingsSnapshotProvider);
    final g = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'Import from Google Sheets',
        subtitle: 'Reads LEADS, CLIENTS, PROJECTS, FOLLOW UPS, FINANCE and "Form responses 1". Safe to run again — existing rows are skipped.',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const _SettingText(settingKey: Keys.sheetsSpreadsheetId, label: 'Spreadsheet link or ID', hint: 'https://docs.google.com/spreadsheets/d/…', icon: BootstrapIcons.link_45deg),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
            BzButton(label: 'Import everything', icon: BootstrapIcons.cloud_download, loading: _importing, onPressed: _importing ? null : () => _import(formOnly: false)),
            BzButton(label: 'New form responses only', icon: BootstrapIcons.inbox, variant: BzVariant.light, onPressed: _importing ? null : () => _import(formOnly: true)),
            if (s.sheetsLastImportAt != null) Text('Last import ${Fmt.timeAgo(s.sheetsLastImportAt!)}', style: theme.textTheme.bodySmall),
          ]),
          if (!g.connected) ...[const SizedBox(height: 12), const BzAlert(variant: BzVariant.warning, message: 'Connect your Google account first (Google account section).', dense: true)],
        ]),
      ),
      const SizedBox(height: 16),
      BzCard(
        title: 'Keep the Google Form as your intake channel',
        subtitle: 'Your public form keeps working. FrameWorkz polls the "Form responses 1" tab and turns new rows into leads with the first follow-up scheduled.',
        child: Column(children: [
          BzSwitchTile(title: 'Auto-import new form responses', subtitle: 'Runs in the background while FrameWorkz is open or in the tray.', icon: BootstrapIcons.arrow_repeat, value: s.sheetsAutoImport, onChanged: (v) => ref.setSetting(Keys.sheetsAutoImport, '$v')),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Text('Check every', style: theme.textTheme.bodyMedium)),
            SizedBox(width: 190, child: BzDropdown<int>(value: s.sheetsIntervalMinutes, items: const [5, 10, 15, 30, 60], labelOf: (m) => '$m minutes', onChanged: (m) => ref.setSetting(Keys.sheetsIntervalMinutes, '${m ?? 10}'))),
          ]),
          const SizedBox(height: 12),
          BzAlert(
            variant: BzVariant.info,
            dense: true,
            message: 'Tip: once everything is imported you can stop maintaining the LEADS / CLIENTS tabs by hand — the app is now the source of truth. Only the form responses tab is read afterwards.',
          ),
        ]),
      ),
    ]);
  }
}

// --------------------------------------------------------------------- app
class _AppSection extends ConsumerWidget {
  const _AppSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsSnapshotProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'Appearance',
        child: Row(children: [
          Expanded(child: Text('Theme', style: Theme.of(context).textTheme.bodyMedium)),
          BzSegmented<String>(
            value: s.themeMode,
            options: const [('light', 'Light', BootstrapIcons.sun), ('dark', 'Dark', BootstrapIcons.moon_stars), ('system', 'System', BootstrapIcons.circle_half)],
            onChanged: (v) => ref.setSetting(Keys.themeMode, v),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      BzCard(
        title: 'Behaviour',
        child: Column(children: [
          BzSwitchTile(title: 'Keep running in the system tray when the window is closed', subtitle: 'Recommended — reminders and form polling continue. Quit from the tray menu.', icon: BootstrapIcons.layout_sidebar, value: s.minimizeToTray, onChanged: (v) => ref.setSetting(Keys.minimizeToTray, '$v')),
          BzSwitchTile(
            title: 'Launch FrameWorkz when you log in',
            subtitle: 'Starts minimised to the tray so you never miss a reminder.',
            icon: BootstrapIcons.power,
            value: s.launchAtStartup,
            onChanged: (v) async {
              try {
                if (v) {
                  await launchAtStartup.enable();
                } else {
                  await launchAtStartup.disable();
                }
                await ref.setSetting(Keys.launchAtStartup, '$v');
              } catch (e) {
                BzToasts.error('Could not change startup setting', message: e.toString());
              }
            },
          ),
        ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------------- about
class _AboutSection extends ConsumerWidget {
  const _AboutSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BzCard(
        title: 'FrameWorkz',
        subtitle: 'Business OS for creative studios — leads, follow-ups, clients, projects and finance in one place.',
        child: FutureBuilder(
          future: Future.wait([PackageInfo.fromPlatform(), getApplicationSupportDirectory()]),
          builder: (context, snap) {
            final info = snap.data?[0] as PackageInfo?;
            final dir = snap.data?[1] as Directory?;
            final dbPath = dir == null ? '…' : '${dir.path}${Platform.pathSeparator}FrameWorkz${Platform.pathSeparator}frameworkz.sqlite';
            return Column(children: [
              BzKeyValue('Version', info == null ? '…' : '${info.version} (build ${info.buildNumber})', icon: BootstrapIcons.tag),
              BzKeyValue('Platform', '${Platform.operatingSystem} ${Platform.operatingSystemVersion}', icon: BootstrapIcons.display),
              BzKeyValue('Data file', dbPath, icon: BootstrapIcons.database, copyable: true, onTap: () {
                Clipboard.setData(ClipboardData(text: dbPath));
                BzToasts.info('Path copied');
              }),
              const Divider(height: 24),
              Align(alignment: Alignment.centerLeft, child: Text('Everything is stored locally in a single SQLite file. Back it up by copying that file; Google tokens live in the OS keychain and are never written to disk in plain text.', style: theme.textTheme.bodySmall)),
            ]);
          },
        ),
      ),
    ]);
  }
}
