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
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';
import '../email/compose_email_dialog.dart';
import '../finance/finance_page.dart';
import '../finance/invoice_form_dialog.dart';
import '../followups/followup_actions.dart';
import '../followups/followup_form_dialog.dart';
import '../leads/leads_page.dart';
import '../projects/project_form_dialog.dart';
import '../projects/projects_page.dart';
import 'client_form_dialog.dart';

class ClientDetailPage extends ConsumerWidget {
  const ClientDetailPage({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(clientProvider(clientId));
    final client = async.value;
    if (async.isLoading) return const BzLoading();
    if (client == null) {
      return BzEmptyState(icon: BootstrapIcons.question_circle, title: 'Client not found', message: 'It may have been deleted.', actionLabel: 'Back to clients', onAction: () => context.go(Routes.clients));
    }
    final theme = Theme.of(context);
    final settings = ref.watch(settingsSnapshotProvider);
    final projects = ref.watch(clientProjectsProvider(clientId)).value ?? const <Project>[];
    final invoices = ref.watch(clientInvoicesProvider(clientId)).value ?? const <Invoice>[];
    final followUps = ref.watch(clientFollowUpsProvider(clientId)).value ?? const <FollowUp>[];
    final activities = ref.watch(activitiesProvider((EntityType.client, clientId))).value ?? const <Activity>[];
    final billed = invoices.where((i) => i.status != InvoiceStatus.cancelled && i.status != InvoiceStatus.draft).fold<double>(0, (s, i) => s + i.amount);
    final received = invoices.fold<double>(0, (s, i) => s + i.amountReceived);
    final outstanding = invoices.where((i) => i.status.isOutstanding).fold<double>(0, (s, i) => s + i.amount - i.amountReceived);

    void compose() => showComposeEmailDialog(context, to: client.email, vars: TemplateEngine.clientVars(client, settings), entityType: EntityType.client, entityId: client.id, category: 'client');
    final phone = context.isPhone;
    final headerActions = <Widget>[
      BzButton(label: 'Project', icon: BootstrapIcons.camera_reels, onPressed: () => showProjectFormDialog(context, ref, client: client)),
      BzButton(label: 'Invoice', icon: BootstrapIcons.receipt, variant: BzVariant.light, onPressed: () => showInvoiceFormDialog(context, ref, client: client)),
      BzButton(label: 'Follow-up', icon: BootstrapIcons.bell, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref, client: client)),
      BzButton(label: 'Email', icon: BootstrapIcons.envelope, variant: BzVariant.light, onPressed: client.email.isEmpty ? null : compose),
      BzMoreMenu(entries: [
        BzMenuEntry('Edit details', BootstrapIcons.pencil, () => showClientFormDialog(context, ref, existing: client)),
        BzMenuEntry('Delete client', BootstrapIcons.trash3, () async {
          final ok = await showBzConfirm(context, title: 'Delete client?', message: 'Projects and invoices stay but lose their client link.', confirmLabel: 'Delete');
          if (ok) {
            await ref.read(clientsRepoProvider).delete(client.id);
            BzToasts.info('Client deleted');
            if (context.mounted) context.go(Routes.clients);
          }
        }, danger: true),
      ]),
    ];

    return BzPage(
      maxWidth: 1500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BzAvatar(client.name, size: phone ? 44 : 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    InkWell(onTap: () => context.go(Routes.clients), child: Text('Clients', style: theme.textTheme.bodySmall?.copyWith(color: BzColors.primary))),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Icon(BootstrapIcons.chevron_right, size: 10, color: theme.colorScheme.onSurfaceVariant)),
                    Text(client.id, style: theme.textTheme.bodySmall),
                  ]),
                  const SizedBox(height: 4),
                  Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 10, runSpacing: 6, children: [
                    Text(client.name, style: theme.textTheme.headlineSmall?.copyWith(fontSize: phone ? 20 : 22)),
                    ClientStatusBadge(client.status),
                    if (client.leadId != null) InkWell(onTap: () => context.go(Routes.lead(client.leadId!)), child: BzBadge('From lead ${client.leadId}', variant: BzVariant.secondary, icon: BootstrapIcons.funnel)),
                  ]),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    if (client.contactPerson.isNotEmpty) BzMetaChip(icon: BootstrapIcons.person, text: client.contactPerson),
                    if (client.phone.isNotEmpty) BzMetaChip(icon: BootstrapIcons.telephone, text: client.phone, onTap: () => launchUrl(Uri.parse('tel:${client.phone}'))),
                    if (client.phone.isNotEmpty) BzMetaChip(icon: BootstrapIcons.whatsapp, text: 'WhatsApp', color: BzColors.success, onTap: () => openWhatsApp(client.phone)),
                    if (client.email.isNotEmpty) BzMetaChip(icon: BootstrapIcons.envelope, text: client.email, onTap: compose),
                    if (client.instagram.isNotEmpty) BzMetaChip(icon: BootstrapIcons.instagram, text: client.instagram, color: BzColors.pink, onTap: () => openInstagram(client.instagram)),
                    BzMetaChip(icon: StatusStyle.service(client.service), text: client.service.label),
                    BzMetaChip(icon: BootstrapIcons.calendar_check, text: 'Since ${Fmt.date(client.startDate)}'),
                    if (client.driveFolder.isNotEmpty) BzMetaChip(icon: BootstrapIcons.folder, text: 'Drive folder', onTap: () => launchUrl(Uri.parse(client.driveFolder))),
                  ]),
                ]),
              ),
              if (!context.isCompact) ...[
                const SizedBox(width: 12),
                Wrap(spacing: 8, runSpacing: 8, children: headerActions),
              ],
            ],
          ).animate().fadeIn(duration: 250.ms),
          if (context.isCompact) ...[const SizedBox(height: 14), BzResponsiveGrid(minItemWidth: 104, maxColumns: 3, gap: 8, children: headerActions)],
          const SizedBox(height: 20),
          BzResponsiveGrid(minItemWidth: 150, maxColumns: 4, gap: phone ? 10 : 14, itemHeight: phone ? 96 : 116, children: [
            BzStatTile(label: 'Monthly value', value: Fmt.money(client.monthlyValue), numericValue: client.monthlyValue, formatter: Fmt.money, icon: BootstrapIcons.arrow_repeat, variant: BzVariant.primary),
            BzStatTile(label: 'Billed', value: Fmt.money(billed), numericValue: billed, formatter: Fmt.money, icon: BootstrapIcons.receipt, variant: BzVariant.info, hint: '${invoices.length} invoices', delay: 60.ms),
            BzStatTile(label: 'Received', value: Fmt.money(received), numericValue: received, formatter: Fmt.money, icon: BootstrapIcons.cash_coin, variant: BzVariant.success, delay: 120.ms),
            BzStatTile(label: 'Outstanding', value: Fmt.money(outstanding), numericValue: outstanding, formatter: Fmt.money, icon: BootstrapIcons.hourglass_split, variant: outstanding > 0 ? BzVariant.danger : BzVariant.secondary, delay: 180.ms),
          ]),
          const SizedBox(height: 18),
          BzTwoColumn(
            ratio: 3,
            rightFlex: 2,
            left: BzFillColumn(children: [
                  BzCard(
                    title: 'Projects',
                    subtitle: projects.isEmpty ? 'No projects yet' : '${projects.where((p) => p.status.isOpen).length} open · ${projects.length} total',
                    actions: [BzButton(label: 'New project', icon: BootstrapIcons.plus_lg, size: BzSize.sm, variant: BzVariant.light, onPressed: () => showProjectFormDialog(context, ref, client: client))],
                    padding: const EdgeInsets.all(8),
                    child: projects.isEmpty
                        ? const BzEmptyState(icon: BootstrapIcons.camera_reels, title: 'No projects', message: 'Track shoots, edits and deliverables per project.', compact: true)
                        : Column(children: [for (final p in projects) ProjectRow(project: p, showClient: false)]),
                  ),
                  BzCard(
                    title: 'Invoices',
                    subtitle: invoices.isEmpty ? 'Nothing billed yet' : '${invoices.where((i) => i.status.isOutstanding).length} outstanding',
                    actions: [BzButton(label: 'New invoice', icon: BootstrapIcons.plus_lg, size: BzSize.sm, variant: BzVariant.light, onPressed: () => showInvoiceFormDialog(context, ref, client: client))],
                    padding: const EdgeInsets.all(8),
                    child: invoices.isEmpty
                        ? const BzEmptyState(icon: BootstrapIcons.receipt, title: 'No invoices', message: 'Create an invoice and send it with one click.', compact: true)
                        : Column(children: [for (final i in invoices) InvoiceRow(invoice: i, showClient: false)]),
                  ),
                  BzCard(
                    fill: true,
                    title: 'Follow-ups',
                    actions: [BzButton(label: 'Schedule', icon: BootstrapIcons.plus_lg, size: BzSize.sm, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref, client: client))],
                    padding: const EdgeInsets.all(8),
                    child: followUps.isEmpty
                        ? const BzEmptyState(icon: BootstrapIcons.bell, title: 'No follow-ups', message: 'Schedule check-ins, review calls or renewal reminders.', compact: true)
                        : Column(children: [
                            for (final f in followUps.take(8))
                              BzHoverRow(
                                child: Row(children: [
                                  Icon(StatusStyle.followUpType(f.type), size: 15, color: theme.colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 10),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(f.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    Text(f.hasTime ? Fmt.dateTime(f.dueAt) : Fmt.weekday(f.dueAt), style: theme.textTheme.bodySmall),
                                    if (phone) ...[
                                      const SizedBox(height: 6),
                                      Row(children: [
                                        Expanded(child: Align(alignment: Alignment.centerLeft, child: f.status == FollowUpStatus.pending ? DueBadge(f.dueAt, hasTime: f.hasTime) : FollowUpStatusBadge(f.status))),
                                        FollowUpQuickActions(fu: f, compact: true, onEmail: client.email.isEmpty ? null : compose),
                                      ]),
                                    ],
                                  ])),
                                  if (!phone) ...[
                                    const SizedBox(width: 8),
                                    if (f.status == FollowUpStatus.pending) DueBadge(f.dueAt, hasTime: f.hasTime) else FollowUpStatusBadge(f.status),
                                    const SizedBox(width: 6),
                                    FollowUpQuickActions(fu: f, compact: true, onEmail: client.email.isEmpty ? null : compose),
                                  ],
                                ]),
                              ),
                          ]),
                  ),
                ]),
            right: BzFillColumn(children: [
                  BzCard(
                    title: 'Details',
                    actions: [BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showClientFormDialog(context, ref, existing: client))],
                    child: Column(children: [
                      BzKeyValue('Contact', client.contactPerson, icon: BootstrapIcons.person),
                      BzKeyValue('Phone', client.phone, icon: BootstrapIcons.telephone),
                      BzKeyValue('Email', client.email, icon: BootstrapIcons.envelope),
                      BzKeyValue('Instagram', client.instagram, icon: BootstrapIcons.instagram),
                      BzKeyValue('Project value', client.projectValue > 0 ? Fmt.money(client.projectValue) : '—', icon: BootstrapIcons.currency_rupee),
                      BzKeyValue('Drive folder', client.driveFolder, icon: BootstrapIcons.folder, onTap: () => launchUrl(Uri.parse(client.driveFolder))),
                      if (client.notes.isNotEmpty) ...[const Divider(height: 20), Align(alignment: Alignment.centerLeft, child: SelectableText(client.notes, style: theme.textTheme.bodyMedium))],
                    ]),
                  ),
                  BzCard(
                    fill: true,
                    title: 'Timeline',
                    child: activities.isEmpty
                        ? Text('No activity yet.', style: theme.textTheme.bodySmall)
                        : Column(children: [
                            for (var i = 0; i < activities.length; i++)
                              BzTimelineItem(icon: BootstrapIcons.dot, title: activities[i].title, detail: activities[i].detail, time: activities[i].createdAt, isLast: i == activities.length - 1, color: BzColors.primary),
                          ]),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
