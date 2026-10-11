/// Domain enumerations for FrameWorkz.
///
/// Every enum carries a human label so that the UI never has to switch on raw
/// values, and a tolerant `fromLabel` for importing spreadsheet data.
library;

enum LeadStatus {
  newLead('New'),
  contacted('Contacted'),
  replied('Replied'),
  callScheduled('Call Scheduled'),
  proposalSent('Proposal Sent'),
  negotiation('Negotiation'),
  nurture('Nurture'),
  won('Won'),
  lost('Lost');

  const LeadStatus(this.label);
  final String label;

  bool get isClosed => this == won || this == lost;
  bool get isOpen => !isClosed;

  static LeadStatus fromLabel(String? label) {
    final l = (label ?? '').trim().toLowerCase();
    for (final s in values) {
      if (s.label.toLowerCase() == l || s.name.toLowerCase() == l) return s;
    }
    return LeadStatus.newLead;
  }
}

enum LeadSource {
  instagram('Instagram'),
  referral('Referral'),
  website('Website'),
  whatsapp('WhatsApp'),
  existingClient('Existing Client'),
  agency('Agency'),
  networking('Networking'),
  coldOutreach('Cold Outreach'),
  other('Other');

  const LeadSource(this.label);
  final String label;

  static LeadSource fromLabel(String? label) {
    final l = (label ?? '').trim().toLowerCase();
    for (final s in values) {
      if (s.label.toLowerCase() == l || s.name.toLowerCase() == l) return s;
    }
    return LeadSource.other;
  }
}

enum ServiceType {
  editing('Editing'),
  reels('Reels'),
  brandFilm('Cinematic Brand Film'),
  socialContent('Social Media Content'),
  cinematography('Cinematography'),
  documentary('Documentary'),
  photography('Photography'),
  monthlyRetainer('Monthly Retainer'),
  other('Other');

  const ServiceType(this.label);
  final String label;

  static ServiceType fromLabel(String? label) {
    final l = (label ?? '').trim().toLowerCase();
    for (final s in values) {
      if (s.label.toLowerCase() == l || s.name.toLowerCase() == l) return s;
    }
    return ServiceType.other;
  }
}

enum FollowUpType {
  call('Call'),
  email('Email'),
  whatsapp('WhatsApp'),
  instagramDm('Instagram DM'),
  meeting('Meeting'),
  task('Task');

  const FollowUpType(this.label);
  final String label;

  static FollowUpType fromLabel(String? label) {
    final l = (label ?? '').trim().toLowerCase();
    for (final s in values) {
      if (s.label.toLowerCase() == l || s.name.toLowerCase() == l) return s;
    }
    return FollowUpType.task;
  }
}

enum FollowUpStatus {
  pending('Pending'),
  done('Done'),
  skipped('Skipped'),
  superseded('Superseded');

  const FollowUpStatus(this.label);
  final String label;
}

enum ClientStatus {
  active('Active'),
  onboarding('Onboarding'),
  paused('Paused'),
  churned('Churned');

  const ClientStatus(this.label);
  final String label;
}

enum ProjectStatus {
  planned('Planned'),
  preProduction('Pre-production'),
  shooting('Shooting'),
  editing('Editing'),
  clientReview('Client Review'),
  revisions('Revisions'),
  delivered('Delivered'),
  closed('Closed');

  const ProjectStatus(this.label);
  final String label;
  bool get isOpen => this != delivered && this != closed;
}

enum PaymentStatus {
  unpaid('Unpaid'),
  advancePaid('Advance Paid'),
  partiallyPaid('Partially Paid'),
  paid('Paid');

  const PaymentStatus(this.label);
  final String label;
}

enum InvoiceStatus {
  draft('Draft'),
  sent('Sent'),
  partiallyPaid('Partially Paid'),
  paid('Paid'),
  overdue('Overdue'),
  cancelled('Cancelled');

  const InvoiceStatus(this.label);
  final String label;
  bool get isOutstanding => this == sent || this == partiallyPaid || this == overdue;
}

enum ActivityKind {
  created,
  statusChanged,
  note,
  followUpDone,
  followUpSnoozed,
  emailSent,
  meetingScheduled,
  converted,
  calendarSynced,
  imported,
  invoice,
  project,
}

enum EntityType { lead, client, project, invoice, followUp }

enum NotificationKind { followUpDue, followUpOverdue, meeting, invoiceOverdue, info, success, warning, error }
