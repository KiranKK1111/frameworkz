import 'package:drift/drift.dart';

import '../domain/enums.dart';

/// A sales lead captured from the intake form, Instagram, referral, etc.
class Leads extends Table {
  TextColumn get id => text()(); // LD-0001
  DateTimeColumn get dateAdded => dateTime()();
  TextColumn get business => text()();
  TextColumn get contactPerson => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get instagram => text().withDefault(const Constant(''))();
  TextColumn get source => textEnum<LeadSource>()();
  TextColumn get service => textEnum<ServiceType>()();
  RealColumn get potentialValue => real().withDefault(const Constant(0))();
  TextColumn get status => textEnum<LeadStatus>()();
  DateTimeColumn get lastContact => dateTime().nullable()();
  DateTimeColumn get nextFollowUp => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get proposalLink => text().withDefault(const Constant(''))();
  TextColumn get driveFolder => text().withDefault(const Constant(''))();
  TextColumn get lostReason => text().withDefault(const Constant(''))();
  TextColumn get clientId => text().nullable()();

  /// Stable key of the external source row (sheet row / form timestamp) used to
  /// de-duplicate imports.
  TextColumn get externalKey => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Clients extends Table {
  TextColumn get id => text()(); // CL-0001
  TextColumn get name => text()();
  TextColumn get contactPerson => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get instagram => text().withDefault(const Constant(''))();
  TextColumn get service => textEnum<ServiceType>()();
  RealColumn get monthlyValue => real().withDefault(const Constant(0))();
  RealColumn get projectValue => real().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime()();
  TextColumn get status => textEnum<ClientStatus>()();
  TextColumn get driveFolder => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get leadId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table {
  TextColumn get id => text()(); // PR-0001
  TextColumn get clientId => text()();
  TextColumn get name => text()();
  TextColumn get service => textEnum<ServiceType>()();
  DateTimeColumn get shootDate => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get status => textEnum<ProjectStatus>()();
  TextColumn get deliverables => text().withDefault(const Constant(''))();
  DateTimeColumn get clientReviewDate => dateTime().nullable()();
  DateTimeColumn get finalDeliveryDate => dateTime().nullable()();
  TextColumn get paymentStatus => textEnum<PaymentStatus>()();
  RealColumn get value => real().withDefault(const Constant(0))();
  TextColumn get driveFolder => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get calendarEventId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A follow-up or meeting. Meetings carry a time; plain follow-ups are "all day".
class FollowUps extends Table {
  TextColumn get id => text()(); // FU-0001
  TextColumn get leadId => text().nullable()();
  TextColumn get clientId => text().nullable()();
  TextColumn get title => text()();
  DateTimeColumn get dueAt => dateTime()();
  BoolColumn get hasTime => boolean().withDefault(const Constant(false))();
  IntColumn get durationMinutes => integer().withDefault(const Constant(30))();
  TextColumn get type => textEnum<FollowUpType>()();
  TextColumn get status => textEnum<FollowUpStatus>()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get outcome => text().withDefault(const Constant(''))();
  TextColumn get calendarEventId => text().nullable()();
  TextColumn get meetLink => text().withDefault(const Constant(''))();
  DateTimeColumn get notifiedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Invoices extends Table {
  TextColumn get id => text()(); // INV-0001
  TextColumn get clientId => text()();
  TextColumn get projectId => text().nullable()();
  DateTimeColumn get invoiceDate => dateTime()();
  RealColumn get amount => real()();
  RealColumn get amountReceived => real().withDefault(const Constant(0))();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => textEnum<InvoiceStatus>()();
  DateTimeColumn get paymentDate => dateTime().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get notifiedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Timeline entries shown on lead / client detail pages.
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => textEnum<EntityType>()();
  TextColumn get entityId => text()();
  TextColumn get kind => textEnum<ActivityKind>()();
  TextColumn get title => text()();
  TextColumn get detail => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
}

class EmailTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// Lead status that suggests this template (null = manual only).
  TextColumn get triggerStatus => textEnum<LeadStatus>().nullable()();

  /// Free-form category: lead, client, invoice, project.
  TextColumn get category => text().withDefault(const Constant('lead'))();
  TextColumn get subject => text()();
  TextColumn get body => text()();
  BoolColumn get autoSend => boolean().withDefault(const Constant(false))();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmailLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => textEnum<EntityType>()();
  TextColumn get entityId => text()();
  TextColumn get toAddress => text()();
  TextColumn get subject => text()();
  TextColumn get body => text()();
  TextColumn get templateId => text().nullable()();
  TextColumn get gmailMessageId => text().nullable()();
  TextColumn get error => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
}

/// Key/value settings. Secrets (Google tokens) live in secure storage, not here.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// In-app notification inbox (bell icon).
class AppNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<NotificationKind>()();
  TextColumn get title => text()();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn get entityType => textEnum<EntityType>().nullable()();
  TextColumn get entityId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();
}

/// Sequential ID counters (LD, CL, PR, FU, INV).
class Counters extends Table {
  TextColumn get name => text()();
  IntColumn get value => integer()();

  @override
  Set<Column> get primaryKey => {name};
}
