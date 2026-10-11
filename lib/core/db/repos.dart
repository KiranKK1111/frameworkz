import 'package:drift/drift.dart';

import '../utils/format.dart';
import 'database.dart';

/// Thin repositories over the Drift database. They own ID allocation,
/// `updatedAt` bookkeeping and activity logging so that feature code stays
/// declarative.
class LeadsRepo {
  LeadsRepo(this.db);
  final AppDatabase db;

  Stream<List<Lead>> watchAll() => (db.select(db.leads)..orderBy([(l) => OrderingTerm.desc(l.dateAdded)])).watch();

  Stream<List<Lead>> watchOpen() => (db.select(db.leads)
        ..where((l) => l.status.isNotIn([LeadStatus.won.name, LeadStatus.lost.name]))
        ..orderBy([(l) => OrderingTerm.desc(l.dateAdded)]))
      .watch();

  Stream<Lead?> watchById(String id) => (db.select(db.leads)..where((l) => l.id.equals(id))).watchSingleOrNull();
  Future<Lead?> byId(String id) => (db.select(db.leads)..where((l) => l.id.equals(id))).getSingleOrNull();
  Future<Lead?> byExternalKey(String key) => (db.select(db.leads)..where((l) => l.externalKey.equals(key))).getSingleOrNull();
  Future<List<Lead>> all() => db.select(db.leads).get();

  Future<Lead> create({
    required String business,
    String contactPerson = '',
    String phone = '',
    String email = '',
    String instagram = '',
    LeadSource source = LeadSource.other,
    ServiceType service = ServiceType.other,
    double potentialValue = 0,
    LeadStatus status = LeadStatus.newLead,
    String notes = '',
    DateTime? dateAdded,
    String? externalKey,
    String? id,
    DateTime? lastContact,
    DateTime? nextFollowUp,
    String proposalLink = '',
    String driveFolder = '',
    ActivityKind logKind = ActivityKind.created,
  }) async {
    final now = DateTime.now();
    final leadId = id ?? await db.nextId('LD');
    if (id != null) await db.bumpCounter('LD', id);
    final lead = Lead(
      id: leadId,
      dateAdded: dateAdded ?? now,
      business: business.trim(),
      contactPerson: contactPerson.trim(),
      phone: phone.trim(),
      email: email.trim(),
      instagram: instagram.trim(),
      source: source,
      service: service,
      potentialValue: potentialValue,
      status: status,
      lastContact: lastContact,
      nextFollowUp: nextFollowUp,
      notes: notes.trim(),
      proposalLink: proposalLink,
      driveFolder: driveFolder,
      lostReason: '',
      clientId: null,
      externalKey: externalKey,
      updatedAt: now,
    );
    await db.into(db.leads).insert(lead);
    await db.logActivity(
      entityType: EntityType.lead,
      entityId: leadId,
      kind: logKind,
      title: logKind == ActivityKind.imported ? 'Imported from Google Sheets' : 'Lead created',
      detail: 'Source: ${source.label} · Service: ${service.label}',
    );
    return lead;
  }

  Future<void> save(Lead lead) => db.update(db.leads).replace(lead.copyWith(updatedAt: DateTime.now()));

  Future<void> patch(String id, LeadsCompanion companion) =>
      (db.update(db.leads)..where((l) => l.id.equals(id))).write(companion.copyWith(updatedAt: Value(DateTime.now())));

  Future<void> delete(String id) async {
    await (db.delete(db.followUps)..where((f) => f.leadId.equals(id))).go();
    await (db.delete(db.activities)..where((a) => a.entityType.equalsValue(EntityType.lead) & a.entityId.equals(id))).go();
    await (db.delete(db.leads)..where((l) => l.id.equals(id))).go();
  }

  Future<void> addNote(String id, String note) => db.logActivity(entityType: EntityType.lead, entityId: id, kind: ActivityKind.note, title: 'Note', detail: note);
}

class ClientsRepo {
  ClientsRepo(this.db);
  final AppDatabase db;

  Stream<List<Client>> watchAll() => (db.select(db.clients)..orderBy([(c) => OrderingTerm.asc(c.name)])).watch();
  Stream<Client?> watchById(String id) => (db.select(db.clients)..where((c) => c.id.equals(id))).watchSingleOrNull();
  Future<Client?> byId(String id) => (db.select(db.clients)..where((c) => c.id.equals(id))).getSingleOrNull();
  Future<List<Client>> all() => db.select(db.clients).get();

  Future<Client> create({
    required String name,
    String contactPerson = '',
    String phone = '',
    String email = '',
    String instagram = '',
    ServiceType service = ServiceType.other,
    double monthlyValue = 0,
    double projectValue = 0,
    DateTime? startDate,
    ClientStatus status = ClientStatus.onboarding,
    String driveFolder = '',
    String notes = '',
    String? leadId,
    String? id,
    ActivityKind logKind = ActivityKind.created,
  }) async {
    final now = DateTime.now();
    final clientId = id ?? await db.nextId('CL');
    if (id != null) await db.bumpCounter('CL', id);
    final client = Client(
      id: clientId,
      name: name.trim(),
      contactPerson: contactPerson.trim(),
      phone: phone.trim(),
      email: email.trim(),
      instagram: instagram.trim(),
      service: service,
      monthlyValue: monthlyValue,
      projectValue: projectValue,
      startDate: startDate ?? now,
      status: status,
      driveFolder: driveFolder,
      notes: notes.trim(),
      leadId: leadId,
      updatedAt: now,
    );
    await db.into(db.clients).insert(client);
    await db.logActivity(entityType: EntityType.client, entityId: clientId, kind: logKind, title: logKind == ActivityKind.imported ? 'Imported from Google Sheets' : 'Client created');
    return client;
  }

  Future<void> save(Client c) => db.update(db.clients).replace(c.copyWith(updatedAt: DateTime.now()));

  Future<void> delete(String id) async {
    await (db.delete(db.clients)..where((c) => c.id.equals(id))).go();
  }
}

class ProjectsRepo {
  ProjectsRepo(this.db);
  final AppDatabase db;

  Stream<List<Project>> watchAll() => (db.select(db.projects)..orderBy([(p) => OrderingTerm.desc(p.updatedAt)])).watch();
  Stream<List<Project>> watchForClient(String clientId) => (db.select(db.projects)..where((p) => p.clientId.equals(clientId))).watch();
  Future<Project?> byId(String id) => (db.select(db.projects)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<Project> create({
    required String clientId,
    required String name,
    ServiceType service = ServiceType.other,
    DateTime? shootDate,
    DateTime? deadline,
    ProjectStatus status = ProjectStatus.planned,
    String deliverables = '',
    PaymentStatus paymentStatus = PaymentStatus.unpaid,
    double value = 0,
    String driveFolder = '',
    String notes = '',
    String? id,
    ActivityKind logKind = ActivityKind.created,
  }) async {
    final now = DateTime.now();
    final pid = id ?? await db.nextId('PR');
    if (id != null) await db.bumpCounter('PR', id);
    final project = Project(
      id: pid,
      clientId: clientId,
      name: name.trim(),
      service: service,
      shootDate: shootDate,
      deadline: deadline,
      status: status,
      deliverables: deliverables,
      clientReviewDate: null,
      finalDeliveryDate: null,
      paymentStatus: paymentStatus,
      value: value,
      driveFolder: driveFolder,
      notes: notes,
      calendarEventId: null,
      updatedAt: now,
    );
    await db.into(db.projects).insert(project);
    await db.logActivity(entityType: EntityType.client, entityId: clientId, kind: ActivityKind.project, title: 'Project created: ${project.name}', detail: 'Status: ${status.label}');
    return project;
  }

  Future<void> save(Project p) => db.update(db.projects).replace(p.copyWith(updatedAt: DateTime.now()));
  Future<void> delete(String id) => (db.delete(db.projects)..where((p) => p.id.equals(id))).go();
}

class FollowUpsRepo {
  FollowUpsRepo(this.db);
  final AppDatabase db;

  Stream<List<FollowUp>> watchPending() => (db.select(db.followUps)
        ..where((f) => f.status.equalsValue(FollowUpStatus.pending))
        ..orderBy([(f) => OrderingTerm.asc(f.dueAt)]))
      .watch();

  Stream<List<FollowUp>> watchAll() => (db.select(db.followUps)..orderBy([(f) => OrderingTerm.desc(f.dueAt)])).watch();

  Stream<List<FollowUp>> watchForLead(String leadId) =>
      (db.select(db.followUps)..where((f) => f.leadId.equals(leadId))..orderBy([(f) => OrderingTerm.desc(f.dueAt)])).watch();

  Stream<List<FollowUp>> watchForClient(String clientId) =>
      (db.select(db.followUps)..where((f) => f.clientId.equals(clientId))..orderBy([(f) => OrderingTerm.desc(f.dueAt)])).watch();

  Stream<List<FollowUp>> watchBetween(DateTime from, DateTime to) => (db.select(db.followUps)
        ..where((f) => f.dueAt.isBiggerOrEqualValue(from) & f.dueAt.isSmallerOrEqualValue(to))
        ..orderBy([(f) => OrderingTerm.asc(f.dueAt)]))
      .watch();

  Future<List<FollowUp>> pending() => (db.select(db.followUps)..where((f) => f.status.equalsValue(FollowUpStatus.pending))).get();
  Future<FollowUp?> byId(String id) => (db.select(db.followUps)..where((f) => f.id.equals(id))).getSingleOrNull();

  Future<FollowUp> create({
    String? leadId,
    String? clientId,
    required String title,
    required DateTime dueAt,
    bool hasTime = false,
    int durationMinutes = 30,
    FollowUpType type = FollowUpType.task,
    String notes = '',
    String? id,
    FollowUpStatus status = FollowUpStatus.pending,
  }) async {
    final fid = id ?? await db.nextId('FU');
    if (id != null) await db.bumpCounter('FU', id);
    final fu = FollowUp(
      id: fid,
      leadId: leadId,
      clientId: clientId,
      title: title,
      dueAt: dueAt,
      hasTime: hasTime,
      durationMinutes: durationMinutes,
      type: type,
      status: status,
      notes: notes,
      outcome: '',
      calendarEventId: null,
      meetLink: '',
      notifiedAt: null,
      completedAt: null,
      createdAt: DateTime.now(),
    );
    await db.into(db.followUps).insert(fu);
    return fu;
  }

  Future<void> save(FollowUp f) => db.update(db.followUps).replace(f);

  Future<void> patch(String id, FollowUpsCompanion c) => (db.update(db.followUps)..where((f) => f.id.equals(id))).write(c);

  /// Marks all pending follow-ups of a lead as superseded (a new status creates a fresh one).
  Future<List<FollowUp>> supersedePendingForLead(String leadId) async {
    final rows = await (db.select(db.followUps)..where((f) => f.leadId.equals(leadId) & f.status.equalsValue(FollowUpStatus.pending))).get();
    for (final r in rows) {
      await patch(r.id, const FollowUpsCompanion(status: Value(FollowUpStatus.superseded)));
    }
    return rows;
  }

  Future<void> delete(String id) => (db.delete(db.followUps)..where((f) => f.id.equals(id))).go();

  /// Follow-ups due today or earlier that are still pending.
  Stream<List<FollowUp>> watchDueAndOverdue() => (db.select(db.followUps)
        ..where((f) => f.status.equalsValue(FollowUpStatus.pending) & f.dueAt.isSmallerOrEqualValue(DateUtilsX.endOfDay(DateTime.now())))
        ..orderBy([(f) => OrderingTerm.asc(f.dueAt)]))
      .watch();
}

class InvoicesRepo {
  InvoicesRepo(this.db);
  final AppDatabase db;

  Stream<List<Invoice>> watchAll() => (db.select(db.invoices)..orderBy([(i) => OrderingTerm.desc(i.invoiceDate)])).watch();
  Stream<List<Invoice>> watchForClient(String clientId) => (db.select(db.invoices)..where((i) => i.clientId.equals(clientId))).watch();
  Future<Invoice?> byId(String id) => (db.select(db.invoices)..where((i) => i.id.equals(id))).getSingleOrNull();
  Future<List<Invoice>> all() => db.select(db.invoices).get();

  Future<Invoice> create({
    required String clientId,
    String? projectId,
    DateTime? invoiceDate,
    required double amount,
    double amountReceived = 0,
    required DateTime dueDate,
    InvoiceStatus status = InvoiceStatus.draft,
    String description = '',
    String notes = '',
    DateTime? paymentDate,
    String? id,
  }) async {
    final now = DateTime.now();
    final iid = id ?? await db.nextId('INV');
    if (id != null) await db.bumpCounter('INV', id);
    final inv = Invoice(
      id: iid,
      clientId: clientId,
      projectId: projectId,
      invoiceDate: invoiceDate ?? now,
      amount: amount,
      amountReceived: amountReceived,
      dueDate: dueDate,
      status: status,
      paymentDate: paymentDate,
      description: description,
      notes: notes,
      notifiedAt: null,
      updatedAt: now,
    );
    await db.into(db.invoices).insert(inv);
    await db.logActivity(entityType: EntityType.client, entityId: clientId, kind: ActivityKind.invoice, title: 'Invoice $iid created', detail: Fmt.money(amount));
    return inv;
  }

  Future<void> save(Invoice i) => db.update(db.invoices).replace(i.copyWith(updatedAt: DateTime.now()));
  Future<void> delete(String id) => (db.delete(db.invoices)..where((i) => i.id.equals(id))).go();

  /// Records a payment and derives the status.
  Future<Invoice> recordPayment(Invoice inv, double amount, DateTime when) async {
    final received = (inv.amountReceived + amount).clamp(0, inv.amount).toDouble();
    final status = received >= inv.amount ? InvoiceStatus.paid : (received > 0 ? InvoiceStatus.partiallyPaid : inv.status);
    final updated = inv.copyWith(amountReceived: received, status: status, paymentDate: Value(status == InvoiceStatus.paid ? when : inv.paymentDate), updatedAt: DateTime.now());
    await save(updated);
    await db.logActivity(entityType: EntityType.client, entityId: inv.clientId, kind: ActivityKind.invoice, title: 'Payment received for ${inv.id}', detail: Fmt.money(amount));
    return updated;
  }
}

class TemplatesRepo {
  TemplatesRepo(this.db);
  final AppDatabase db;

  Stream<List<EmailTemplate>> watchAll() => (db.select(db.emailTemplates)..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.name)])).watch();
  Future<List<EmailTemplate>> all() => (db.select(db.emailTemplates)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  Future<EmailTemplate?> byId(String id) => (db.select(db.emailTemplates)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<EmailTemplate?> forStatus(LeadStatus s) =>
      (db.select(db.emailTemplates)..where((t) => t.triggerStatus.equalsValue(s))..limit(1)).getSingleOrNull();

  Future<void> upsert(EmailTemplate t) => db.into(db.emailTemplates).insertOnConflictUpdate(t.copyWith(updatedAt: DateTime.now()));
  Future<void> delete(String id) => (db.delete(db.emailTemplates)..where((t) => t.id.equals(id))).go();
  Future<int> count() async => (await db.select(db.emailTemplates).get()).length;
}

class EmailLogsRepo {
  EmailLogsRepo(this.db);
  final AppDatabase db;

  Stream<List<EmailLog>> watchFor(EntityType type, String id) =>
      (db.select(db.emailLogs)..where((e) => e.entityType.equalsValue(type) & e.entityId.equals(id))..orderBy([(e) => OrderingTerm.desc(e.sentAt)])).watch();

  Future<void> log({
    required EntityType entityType,
    required String entityId,
    required String to,
    required String subject,
    required String body,
    String? templateId,
    String? gmailMessageId,
    String? error,
  }) =>
      db.into(db.emailLogs).insert(EmailLogsCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        toAddress: to,
        subject: subject,
        body: body,
        templateId: Value(templateId),
        gmailMessageId: Value(gmailMessageId),
        error: Value(error),
        sentAt: DateTime.now(),
      ));
}
