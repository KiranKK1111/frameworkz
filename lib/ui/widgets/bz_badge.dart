import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/db/database.dart';
import '../../core/utils/format.dart';

/// Bootstrap badge. `soft` renders the subtle/emphasis pair (`text-bg-*-subtle`).
class BzBadge extends StatelessWidget {
  const BzBadge(
    this.text, {
    super.key,
    this.variant = BzVariant.secondary,
    this.soft = true,
    this.pill = true,
    this.icon,
    this.dot = false,
    this.fontSize = 11.5,
  });

  final String text;
  final BzVariant variant;
  final bool soft;
  final bool pill;
  final IconData? icon;
  final bool dot;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final bg = soft ? variant.subtle(b) : variant.color;
    final fg = soft ? variant.emphasis(b) : variant.onColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pill ? 9 : 7, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(pill ? 999 : 5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: soft ? variant.color : fg, shape: BoxShape.circle)),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: fg),
            const SizedBox(width: 5),
          ],
          Flexible(child: Text(text, style: TextStyle(color: fg, fontSize: fontSize, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: 0.1), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

/// Colour semantics for every status enum in the domain.
class StatusStyle {
  StatusStyle._();

  static BzVariant lead(LeadStatus s) => switch (s) {
        LeadStatus.newLead => BzVariant.primary,
        LeadStatus.contacted => BzVariant.info,
        LeadStatus.replied => BzVariant.buzz,
        LeadStatus.callScheduled => BzVariant.primary,
        LeadStatus.proposalSent => BzVariant.warning,
        LeadStatus.negotiation => BzVariant.warning,
        LeadStatus.nurture => BzVariant.secondary,
        LeadStatus.won => BzVariant.success,
        LeadStatus.lost => BzVariant.danger,
      };

  static IconData leadIcon(LeadStatus s) => switch (s) {
        LeadStatus.newLead => BootstrapIcons.stars,
        LeadStatus.contacted => BootstrapIcons.telephone_outbound,
        LeadStatus.replied => BootstrapIcons.reply,
        LeadStatus.callScheduled => BootstrapIcons.calendar_event,
        LeadStatus.proposalSent => BootstrapIcons.file_earmark_text,
        LeadStatus.negotiation => BootstrapIcons.chat_dots,
        LeadStatus.nurture => BootstrapIcons.hourglass_split,
        LeadStatus.won => BootstrapIcons.trophy,
        LeadStatus.lost => BootstrapIcons.emoji_frown,
      };

  static BzVariant client(ClientStatus s) => switch (s) {
        ClientStatus.active => BzVariant.success,
        ClientStatus.onboarding => BzVariant.primary,
        ClientStatus.paused => BzVariant.warning,
        ClientStatus.churned => BzVariant.secondary,
      };

  static BzVariant project(ProjectStatus s) => switch (s) {
        ProjectStatus.planned => BzVariant.secondary,
        ProjectStatus.preProduction => BzVariant.info,
        ProjectStatus.shooting => BzVariant.primary,
        ProjectStatus.editing => BzVariant.buzz,
        ProjectStatus.clientReview => BzVariant.warning,
        ProjectStatus.revisions => BzVariant.warning,
        ProjectStatus.delivered => BzVariant.success,
        ProjectStatus.closed => BzVariant.dark,
      };

  static BzVariant invoice(InvoiceStatus s) => switch (s) {
        InvoiceStatus.draft => BzVariant.secondary,
        InvoiceStatus.sent => BzVariant.primary,
        InvoiceStatus.partiallyPaid => BzVariant.warning,
        InvoiceStatus.paid => BzVariant.success,
        InvoiceStatus.overdue => BzVariant.danger,
        InvoiceStatus.cancelled => BzVariant.dark,
      };

  static BzVariant payment(PaymentStatus s) => switch (s) {
        PaymentStatus.unpaid => BzVariant.danger,
        PaymentStatus.advancePaid => BzVariant.info,
        PaymentStatus.partiallyPaid => BzVariant.warning,
        PaymentStatus.paid => BzVariant.success,
      };

  static BzVariant followUp(FollowUpStatus s) => switch (s) {
        FollowUpStatus.pending => BzVariant.primary,
        FollowUpStatus.done => BzVariant.success,
        FollowUpStatus.skipped => BzVariant.secondary,
        FollowUpStatus.superseded => BzVariant.dark,
      };

  static IconData followUpType(FollowUpType t) => switch (t) {
        FollowUpType.call => BootstrapIcons.telephone,
        FollowUpType.email => BootstrapIcons.envelope,
        FollowUpType.whatsapp => BootstrapIcons.whatsapp,
        FollowUpType.instagramDm => BootstrapIcons.instagram,
        FollowUpType.meeting => BootstrapIcons.camera_video,
        FollowUpType.task => BootstrapIcons.check2,
      };

  static IconData source(LeadSource s) => switch (s) {
        LeadSource.instagram => BootstrapIcons.instagram,
        LeadSource.referral => BootstrapIcons.people,
        LeadSource.website => BootstrapIcons.globe,
        LeadSource.whatsapp => BootstrapIcons.whatsapp,
        LeadSource.existingClient => BootstrapIcons.person_check,
        LeadSource.agency => BootstrapIcons.building,
        LeadSource.networking => BootstrapIcons.chat_dots,
        LeadSource.coldOutreach => BootstrapIcons.megaphone,
        LeadSource.other => BootstrapIcons.tag,
      };

  static IconData service(ServiceType s) => switch (s) {
        ServiceType.editing => BootstrapIcons.film,
        ServiceType.reels => BootstrapIcons.camera_reels,
        ServiceType.brandFilm => BootstrapIcons.camera_video,
        ServiceType.socialContent => BootstrapIcons.grid,
        ServiceType.cinematography => BootstrapIcons.camera,
        ServiceType.documentary => BootstrapIcons.play_circle,
        ServiceType.photography => BootstrapIcons.image,
        ServiceType.monthlyRetainer => BootstrapIcons.arrow_repeat,
        ServiceType.other => BootstrapIcons.tag,
      };
}

class LeadStatusBadge extends StatelessWidget {
  const LeadStatusBadge(this.status, {super.key, this.soft = true, this.withIcon = false});
  final LeadStatus status;
  final bool soft;
  final bool withIcon;
  @override
  Widget build(BuildContext context) => BzBadge(status.label, variant: StatusStyle.lead(status), soft: soft, dot: !withIcon, icon: withIcon ? StatusStyle.leadIcon(status) : null);
}

class ClientStatusBadge extends StatelessWidget {
  const ClientStatusBadge(this.status, {super.key});
  final ClientStatus status;
  @override
  Widget build(BuildContext context) => BzBadge(status.label, variant: StatusStyle.client(status), dot: true);
}

class ProjectStatusBadge extends StatelessWidget {
  const ProjectStatusBadge(this.status, {super.key});
  final ProjectStatus status;
  @override
  Widget build(BuildContext context) => BzBadge(status.label, variant: StatusStyle.project(status), dot: true);
}

class InvoiceStatusBadge extends StatelessWidget {
  const InvoiceStatusBadge(this.status, {super.key});
  final InvoiceStatus status;
  @override
  Widget build(BuildContext context) => BzBadge(status.label, variant: StatusStyle.invoice(status), dot: true);
}

class PaymentStatusBadge extends StatelessWidget {
  const PaymentStatusBadge(this.status, {super.key});
  final PaymentStatus status;
  @override
  Widget build(BuildContext context) => BzBadge(status.label, variant: StatusStyle.payment(status), dot: true);
}

class FollowUpStatusBadge extends StatelessWidget {
  const FollowUpStatusBadge(this.status, {super.key});
  final FollowUpStatus status;
  @override
  Widget build(BuildContext context) => BzBadge(status.label, variant: StatusStyle.followUp(status), dot: true);
}

/// Shows how urgent a date is: overdue (red), today (amber), tomorrow (blue),
/// later (green) or none.
class DueBadge extends StatelessWidget {
  const DueBadge(this.due, {super.key, this.hasTime = false, this.emptyLabel = 'No follow-up'});
  final DateTime? due;
  final bool hasTime;
  final String emptyLabel;

  static BzVariant variantFor(DateTime? due) {
    if (due == null) return BzVariant.secondary;
    final today = DateUtilsX.startOfDay(DateTime.now());
    final d = DateUtilsX.startOfDay(due);
    final diff = d.difference(today).inDays;
    if (diff < 0) return BzVariant.danger;
    if (diff == 0) return BzVariant.warning;
    if (diff == 1) return BzVariant.info;
    return BzVariant.success;
  }

  @override
  Widget build(BuildContext context) {
    if (due == null) return BzBadge(emptyLabel, variant: BzVariant.secondary, soft: true);
    final v = variantFor(due);
    final label = hasTime && DateUtilsX.isToday(due!) ? 'Today ${Fmt.time(due)}' : Fmt.relativeDay(due);
    return BzBadge(
      label,
      variant: v,
      icon: v == BzVariant.danger ? BootstrapIcons.exclamation_circle : (v == BzVariant.warning ? BootstrapIcons.alarm : BootstrapIcons.calendar3),
    );
  }
}
