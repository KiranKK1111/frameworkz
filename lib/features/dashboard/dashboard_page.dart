import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/responsive.dart';
import '../../app/router.dart';
import '../../app/theme/bz_colors.dart';
import '../../core/email/template_engine.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_misc.dart';
import '../email/compose_email_dialog.dart';
import '../followups/followup_actions.dart';
import '../followups/followup_form_dialog.dart';
import '../leads/lead_form_dialog.dart';
import '../leads/leads_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsSnapshotProvider);
    final stats = ref.watch(dashboardStatsProvider);
    final counts = ref.watch(agendaCountsProvider);
    final pending = ref.watch(pendingFollowUpsProvider).value ?? const <FollowUp>[];
    final leads = ref.watch(leadsProvider).value ?? const <Lead>[];
    final google = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();

    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : (hour < 17 ? 'Good afternoon' : 'Good evening');
    final name = settings.myName.isNotEmpty ? ', ${settings.myName.split(' ').first}' : '';

    final agenda = pending.where((f) => !f.dueAt.isAfter(DateUtilsX.endOfDay(DateTime.now()))).toList()
      ..sort((a, b) {
        final ao = DateUtilsX.isPastDay(a.dueAt), bo = DateUtilsX.isPastDay(b.dueAt);
        if (ao != bo) return ao ? -1 : 1;
        if (a.hasTime != b.hasTime) return a.hasTime ? -1 : 1;
        return a.dueAt.compareTo(b.dueAt);
      });

    final showOnboarding = !settings.onboardingDone;
    final hasImported = leads.any((l) => l.externalKey != null);

    final phone = context.isPhone;
    final subtitle = '${Fmt.weekday(DateTime.now())} · ${counts.attention == 0 ? 'Nothing waiting on you' : '${Fmt.plural(counts.today, 'follow-up')} today${counts.overdue > 0 ? ', ${counts.overdue} overdue' : ''}${counts.meetingsToday > 0 ? ', ${Fmt.plural(counts.meetingsToday, 'meeting')}' : ''}'}';
    final tiles = [
      BzStatTile(label: 'Open leads', value: '${stats.openLeads}', numericValue: stats.openLeads, icon: BootstrapIcons.funnel, variant: BzVariant.primary, hint: '+${stats.newThisWeek} this week', onTap: () => context.go(Routes.leads)),
      BzStatTile(label: 'Pipeline value', value: Fmt.moneyCompact(stats.pipelineValue), numericValue: stats.pipelineValue, formatter: Fmt.moneyCompact, icon: BootstrapIcons.graph_up_arrow, variant: BzVariant.buzz, hint: '${stats.wonThisMonth} won this month', delay: 50.ms, onTap: () => context.go(Routes.leads)),
      BzStatTile(label: 'Follow-ups today', value: '${counts.today}', numericValue: counts.today, icon: BootstrapIcons.bell, variant: counts.overdue > 0 ? BzVariant.danger : BzVariant.warning, hint: counts.overdue > 0 ? '${counts.overdue} overdue' : 'Nothing overdue', delay: 100.ms, onTap: () => context.go(Routes.followUps)),
      BzStatTile(label: 'Active clients', value: '${stats.activeClients}', numericValue: stats.activeClients, icon: BootstrapIcons.people, variant: BzVariant.success, hint: '${stats.openProjects} open projects', delay: 150.ms, onTap: () => context.go(Routes.clients)),
      BzStatTile(label: 'Outstanding', value: Fmt.moneyCompact(stats.outstanding), numericValue: stats.outstanding, formatter: Fmt.moneyCompact, icon: BootstrapIcons.receipt, variant: stats.overdueInvoices > 0 ? BzVariant.danger : BzVariant.info, hint: stats.overdueInvoices > 0 ? '${stats.overdueInvoices} overdue invoices' : 'Collected ${Fmt.moneyCompact(stats.collectedThisMonth)} this month', delay: 200.ms, onTap: () => context.go(Routes.finance)),
    ];

    return BzPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (phone)
            _MobileHero(greeting: '$greeting$name', subtitle: subtitle, counts: counts)
          else
            BzPageHeader(
              title: '$greeting$name 👋',
              subtitle: subtitle,
              actions: [
                BzButton(label: 'Schedule', icon: BootstrapIcons.calendar_plus, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref)),
                BzButton(label: 'New lead', icon: BootstrapIcons.person_plus, onPressed: () => showLeadFormDialog(context, ref)),
              ],
            ),
          if (showOnboarding) ...[
            _OnboardingCard(settings: settings, googleConnected: google.connected, imported: hasImported),
            const SizedBox(height: 14),
          ],
          // KPI grid: 5 → 3 → 2 columns depending on width, uniform tile height.
          BzResponsiveGrid(minItemWidth: phone ? 150 : 200, maxColumns: 5, gap: phone ? 10 : 14, itemHeight: phone ? 100 : 122, children: tiles),
          const SizedBox(height: 14),
          BzTwoColumn(
            ratio: 3,
            rightFlex: 2,
            gap: 14,
            left: BzCard(
              fill: true,
                  title: "Today's agenda",
                  subtitle: agenda.isEmpty ? 'All clear' : '${agenda.length} items · meetings first, then overdue',
                  leading: Container(width: 34, height: 34, decoration: BoxDecoration(color: BzColors.buzz.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const Icon(BootstrapIcons.list_check, size: 16, color: Color(0xFF664D03))),
                  actions: [BzButton(label: 'All follow-ups', size: BzSize.sm, variant: BzVariant.light, trailingIcon: BootstrapIcons.arrow_right, onPressed: () => context.go(Routes.followUps))],
                  padding: const EdgeInsets.all(8),
                  child: agenda.isEmpty
                      ? const BzEmptyState(icon: BootstrapIcons.cup_hot, title: 'Nothing due today', message: 'Move a lead forward or schedule a follow-up to fill your day.', compact: true)
                      : Column(children: [for (var i = 0; i < agenda.length && i < 8; i++) _AgendaRow(fu: agenda[i], index: i), if (agenda.length > 8) Padding(padding: const EdgeInsets.all(8), child: Text('+${agenda.length - 8} more', style: theme.textTheme.bodySmall))]),
            ),
            right: BzFillColumn(
              children: [
                _PipelineCard(stats: stats),
                _UpcomingCard(pending: pending),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _RecentActivityCard(),
        ],
      ),
    );
  }
}

class _OnboardingCard extends ConsumerWidget {
  const _OnboardingCard({required this.settings, required this.googleConnected, required this.imported});
  final AppSettingsState settings;
  final bool googleConnected;
  final bool imported;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final steps = <(bool, String, String, IconData)>[
      (settings.myName.isNotEmpty, 'Set up your profile', 'Your name, studio and signature power every email template.', BootstrapIcons.person_badge),
      (googleConnected, 'Connect Google', 'Calendar reminders, Meet links and Gmail sending — one sign-in.', BootstrapIcons.google),
      (imported, 'Import your Google Sheet', 'Bring in LEADS, CLIENTS, PROJECTS, FOLLOW UPS and FINANCE in one click.', BootstrapIcons.file_earmark_spreadsheet),
    ];
    final done = steps.where((s) => s.$1).length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: [BzColors.primary.withValues(alpha: theme.brightness == Brightness.dark ? 0.25 : 0.08), BzColors.buzz.withValues(alpha: theme.brightness == Brightness.dark ? 0.18 : 0.10)], begin: Alignment.centerLeft, end: Alignment.centerRight),
        border: Border.all(color: BzColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(BootstrapIcons.rocket_takeoff, size: 18, color: BzColors.primary),
            const SizedBox(width: 10),
            // The title wraps on narrow screens; the button stays on the same row.
            Expanded(child: Text(context.isPhone ? 'Welcome — $done of ${steps.length} setup steps done' : 'Welcome to FrameWorkz — $done of ${steps.length} setup steps done', style: theme.textTheme.titleMedium)),
            const SizedBox(width: 10),
            BzButton(label: done == steps.length ? 'Finish' : 'Dismiss', size: BzSize.sm, variant: BzVariant.light, onPressed: () => ref.setSetting(Keys.onboardingDone, 'true')),
          ]),
          const SizedBox(height: 14),
          BzResponsiveGrid(
            minItemWidth: 260,
            maxColumns: 3,
            gap: 12,
            children: [
              for (var i = 0; i < steps.length; i++)
                BzCard(
                    hoverLift: true,
                    onTap: () => context.go(Routes.settings),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: steps[i].$1 ? BzColors.success : BzColors.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Icon(steps[i].$1 ? BootstrapIcons.check2 : steps[i].$4, size: 14, color: steps[i].$1 ? Colors.white : BzColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(steps[i].$2, style: theme.textTheme.titleSmall?.copyWith(decoration: steps[i].$1 ? TextDecoration.lineThrough : null)),
                            const SizedBox(height: 2),
                            Text(steps[i].$3, style: theme.textTheme.bodySmall),
                          ]),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0);
  }
}

/// Phone-only gradient hero (greeting + quick actions), in the spirit of
/// modern consumer apps.
class _MobileHero extends ConsumerWidget {
  const _MobileHero({required this.greeting, required this.subtitle, required this.counts});
  final String greeting;
  final String subtitle;
  final AgendaCounts counts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF0D6EFD), Color(0xFF6610F2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: BzColors.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting 👋', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _HeroButton(icon: BootstrapIcons.person_plus, label: 'New lead', onTap: () => showLeadFormDialog(context, ref))),
            const SizedBox(width: 10),
            Expanded(child: _HeroButton(icon: BootstrapIcons.calendar_plus, label: 'Schedule', onTap: () => showFollowUpFormDialog(context, ref))),
            const SizedBox(width: 10),
            Expanded(child: _HeroButton(icon: BootstrapIcons.bell, label: counts.attention == 0 ? 'All clear' : '${counts.attention} due', onTap: () => context.go(Routes.followUps))),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0);
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ),
    );
  }
}

class _AgendaRow extends ConsumerWidget {
  const _AgendaRow({required this.fu, required this.index});
  final FollowUp fu;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lead = fu.leadId != null ? ref.watch(leadsByIdProvider)[fu.leadId!] : null;
    final client = fu.clientId != null ? ref.watch(clientsByIdProvider)[fu.clientId!] : null;
    final who = lead?.business ?? client?.name ?? '';
    final contact = lead?.contactPerson ?? client?.contactPerson ?? '';
    final email = lead?.email ?? client?.email ?? '';
    final phone = lead?.phone ?? client?.phone ?? '';
    final overdue = DateUtilsX.isPastDay(fu.dueAt);
    final v = overdue ? BzVariant.danger : (fu.hasTime ? BzVariant.primary : BzVariant.warning);

    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      onTap: lead != null ? () => context.go(Routes.lead(lead.id)) : (client != null ? () => context.go(Routes.client(client.id)) : null),
      child: Row(
        children: [
          Container(width: 4, height: 38, decoration: BoxDecoration(color: v.color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          SizedBox(
            width: 64,
            child: Text(fu.hasTime ? Fmt.time(fu.dueAt) : (overdue ? Fmt.relativeDay(fu.dueAt).replaceAll(' overdue', 'd late').replaceAll(' days', 'd') : 'Today'), style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: v.emphasis(theme.brightness))),
          ),
          Icon(StatusStyle.followUpType(fu.type), size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fu.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text([who, if (contact.isNotEmpty) contact, if (lead != null) lead.status.label].join(' · '), style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp', variant: BzVariant.success, onPressed: () => openWhatsApp(phone)),
          if (fu.meetLink.isNotEmpty) BzIconButton(icon: BootstrapIcons.camera_video, tooltip: 'Join Meet', variant: BzVariant.primary, onPressed: () => launchUrl(Uri.parse(fu.meetLink))),
          FollowUpQuickActions(
            fu: fu,
            compact: true,
            onEmail: email.isEmpty
                ? null
                : () {
                    final s = ref.read(settingsSnapshotProvider);
                    showComposeEmailDialog(context, to: email, vars: lead != null ? TemplateEngine.leadVars(lead, s, meeting: fu.hasTime ? fu : null) : TemplateEngine.clientVars(client!, s), entityType: lead != null ? EntityType.lead : EntityType.client, entityId: lead?.id ?? client!.id);
                  },
          ),
        ],
      ),
    ).animate(delay: (index * 40).ms).fadeIn(duration: 220.ms).slideX(begin: 0.03, end: 0);
  }
}

/// Pipeline by stage: single-hue horizontal bars, direct labels, no legend.
class _PipelineCard extends StatelessWidget {
  const _PipelineCard({required this.stats});
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stages = LeadStatus.values.where((s) => s != LeadStatus.lost).toList();
    final max = stages.fold<int>(1, (m, s) => (stats.byStatus[s] ?? 0) > m ? stats.byStatus[s]! : m);
    return BzCard(
      title: 'Pipeline by stage',
      subtitle: '${stats.openLeads} open leads',
      actions: [BzIconButton(icon: BootstrapIcons.kanban, tooltip: 'Open pipeline board', onPressed: () => context.go(Routes.leads))],
      child: Column(
        children: [
          for (var i = 0; i < stages.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 108, child: Text(stages[i].label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface))),
                  Expanded(
                    child: Stack(children: [
                      Container(height: 14, decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(4))),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: (stats.byStatus[stages[i]] ?? 0) / max),
                        duration: Duration(milliseconds: 500 + i * 60),
                        curve: Curves.easeOutCubic,
                        builder: (context, v, _) => Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: v.clamp(0.0, 1.0),
                            child: Container(height: 14, constraints: const BoxConstraints(minWidth: 0), decoration: BoxDecoration(color: stages[i] == LeadStatus.won ? BzColors.success : BzColors.primary, borderRadius: BorderRadius.circular(4))),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(width: 24, child: Text('${stats.byStatus[stages[i]] ?? 0}', textAlign: TextAlign.right, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700))),
                ],
              ),
            ),
          if ((stats.byStatus[LeadStatus.lost] ?? 0) > 0) ...[
            const Divider(height: 18),
            Row(children: [
              Icon(BootstrapIcons.emoji_frown, size: 12, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text('${stats.byStatus[LeadStatus.lost]} lost', style: theme.textTheme.bodySmall),
            ]),
          ],
        ],
      ),
    );
  }
}

class _UpcomingCard extends ConsumerWidget {
  const _UpcomingCard({required this.pending});
  final List<FollowUp> pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projects = ref.watch(projectsProvider).value ?? const <Project>[];
    final invoices = ref.watch(invoicesProvider).value ?? const <Invoice>[];
    final clients = ref.watch(clientsByIdProvider);
    final leads = ref.watch(leadsByIdProvider);
    final start = DateUtilsX.endOfDay(DateTime.now());
    final end = start.add(const Duration(days: 7));

    final items = <(DateTime, IconData, Color, String, String)>[];
    for (final f in pending.where((f) => f.dueAt.isAfter(start) && f.dueAt.isBefore(end))) {
      final who = leads[f.leadId]?.business ?? clients[f.clientId]?.name ?? '';
      items.add((f.dueAt, StatusStyle.followUpType(f.type), f.hasTime ? BzColors.primary : BzColors.warning, f.title, who));
    }
    for (final p in projects.where((p) => p.status.isOpen)) {
      if (p.shootDate != null && p.shootDate!.isAfter(start) && p.shootDate!.isBefore(end)) items.add((p.shootDate!, BootstrapIcons.camera_video, BzColors.info, 'Shoot: ${p.name}', clients[p.clientId]?.name ?? ''));
      if (p.deadline != null && p.deadline!.isAfter(start) && p.deadline!.isBefore(end)) items.add((p.deadline!, BootstrapIcons.hourglass_split, BzColors.danger, 'Deadline: ${p.name}', clients[p.clientId]?.name ?? ''));
    }
    for (final i in invoices.where((i) => i.status.isOutstanding && i.dueDate.isAfter(start) && i.dueDate.isBefore(end))) {
      items.add((i.dueDate, BootstrapIcons.receipt, BzColors.success, 'Invoice ${i.id} due · ${Fmt.money(i.amount - i.amountReceived)}', clients[i.clientId]?.name ?? ''));
    }
    items.sort((a, b) => a.$1.compareTo(b.$1));

    return BzCard(
      fill: true,
      title: 'Next 7 days',
      subtitle: items.isEmpty ? 'Nothing scheduled' : '${items.length} upcoming',
      actions: [BzIconButton(icon: BootstrapIcons.calendar3, tooltip: 'Open calendar', onPressed: () => context.go(Routes.calendar))],
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: items.isEmpty
          ? Padding(padding: const EdgeInsets.all(8), child: Text('Upcoming follow-ups, shoots, deadlines and invoice due dates will appear here.', style: theme.textTheme.bodySmall))
          : Column(children: [
              for (final it in items.take(7))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    SizedBox(width: 58, child: Text(Fmt.dateShort(it.$1), style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700))),
                    Icon(it.$2, size: 13, color: it.$3),
                    const SizedBox(width: 8),
                    Expanded(child: Text(it.$4, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface), overflow: TextOverflow.ellipsis)),
                    if (it.$5.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 110), child: Text(it.$5, style: theme.textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ]),
                ),
            ]),
    );
  }
}

class _RecentActivityCard extends ConsumerWidget {
  const _RecentActivityCard();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final acts = ref.watch(recentActivityProvider).value ?? const <Activity>[];
    final leads = ref.watch(leadsByIdProvider);
    final clients = ref.watch(clientsByIdProvider);
    return BzCard(
      title: 'Recent activity',
      subtitle: 'Status changes, emails, follow-ups and imports',
      padding: const EdgeInsets.all(8),
      child: acts.isEmpty
          ? const BzEmptyState(icon: BootstrapIcons.activity, title: 'No activity yet', message: 'Create a lead or import your sheet to get started.', compact: true)
          : Wrap(
              children: [
                for (final a in acts.take(12))
                  SizedBox(
                    width: 480,
                    child: BzHoverRow(
                      onTap: () {
                        if (a.entityType == EntityType.lead) {
                          context.go(Routes.lead(a.entityId));
                        } else if (a.entityType == EntityType.client) {
                          context.go(Routes.client(a.entityId));
                        }
                      },
                      child: Row(children: [
                        BzAvatar(leads[a.entityId]?.business ?? clients[a.entityId]?.name ?? a.entityId, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(a.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                            Text('${leads[a.entityId]?.business ?? clients[a.entityId]?.name ?? a.entityId} · ${Fmt.timeAgo(a.createdAt)}', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                          ]),
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
    );
  }
}
