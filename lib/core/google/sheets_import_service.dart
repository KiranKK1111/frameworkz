import 'package:flutter/foundation.dart';
import 'package:googleapis/sheets/v4.dart' as gs;

import '../db/database.dart';
import '../db/repos.dart';
import 'google_auth_service.dart';

/// Outcome of an import run.
class ImportResult {
  int leads = 0;
  int clients = 0;
  int projects = 0;
  int followUps = 0;
  int invoices = 0;
  int formLeads = 0;
  int skipped = 0;
  final List<String> errors = [];

  int get total => leads + clients + projects + followUps + invoices + formLeads;
  bool get isEmpty => total == 0 && errors.isEmpty;

  @override
  String toString() => 'Imported $leads leads, $formLeads form responses, $clients clients, $projects projects, $followUps follow-ups, $invoices invoices · $skipped skipped${errors.isEmpty ? '' : ' · ${errors.length} errors'}';
}

/// Imports the "LOKESH BUSINESS OS" style workbook (LEADS, CLIENTS, PROJECTS,
/// FOLLOW UPS, FINANCE, Form responses 1) into the local database.
///
/// The import is idempotent: rows are matched by their sheet id (LD-0001…)
/// or, for form responses, by the submission timestamp.
class SheetsImportService {
  SheetsImportService({
    required this.auth,
    required this.db,
    required this.leads,
    required this.clients,
    required this.projects,
    required this.followUps,
    required this.invoices,
    this.onNewLead,
  });

  final GoogleAuthService auth;
  final AppDatabase db;
  final LeadsRepo leads;
  final ClientsRepo clients;
  final ProjectsRepo projects;
  final FollowUpsRepo followUps;
  final InvoicesRepo invoices;

  /// Called for each lead created from a form response so automation can
  /// schedule the first follow-up.
  final Future<void> Function(Lead lead)? onNewLead;

  /// Extracts the spreadsheet id from a pasted URL or returns the id as-is.
  static String parseSpreadsheetId(String input) {
    final m = RegExp(r'/spreadsheets/d/([a-zA-Z0-9-_]+)').firstMatch(input);
    return m?.group(1) ?? input.trim();
  }

  Future<ImportResult> importAll(String spreadsheetIdOrUrl, {bool formResponsesOnly = false}) async {
    final id = parseSpreadsheetId(spreadsheetIdOrUrl);
    await auth.ensureFresh();
    final api = auth.sheets;
    final result = ImportResult();

    if (!formResponsesOnly) {
      await _importLeads(api, id, result);
      await _importClients(api, id, result);
      await _importProjects(api, id, result);
      await _importFollowUps(api, id, result);
      await _importFinance(api, id, result);
    }
    await _importFormResponses(api, id, result);
    return result;
  }

  Future<List<List<Object?>>> _rows(gs.SheetsApi api, String id, String range) async {
    try {
      final res = await api.spreadsheets.values.get(
        id,
        range,
        valueRenderOption: 'UNFORMATTED_VALUE',
        dateTimeRenderOption: 'SERIAL_NUMBER',
      );
      return res.values ?? const [];
    } catch (e) {
      debugPrint('Range $range unavailable: $e');
      return const [];
    }
  }

  // ------------------------------------------------------------------ parsing
  static String _s(List<Object?> row, int i) => i < row.length && row[i] != null ? row[i].toString().trim() : '';

  static double _n(List<Object?> row, int i) {
    if (i >= row.length || row[i] == null) return 0;
    final v = row[i];
    if (v is num) return v.toDouble();
    final cleaned = v.toString().replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  static DateTime? _d(List<Object?> row, int i) {
    if (i >= row.length || row[i] == null) return null;
    final v = row[i];
    if (v is num) {
      if (v <= 0) return null;
      // Google Sheets serial date: days since 1899-12-30.
      final whole = v.floor();
      final frac = v - whole;
      final base = DateTime(1899, 12, 30).add(Duration(days: whole));
      return base.add(Duration(milliseconds: (frac * 86400000).round()));
    }
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    final m = RegExp(r'^(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})(?:\s+(\d{1,2}):(\d{2})(?::(\d{2}))?)?').firstMatch(s);
    if (m != null) {
      var year = int.parse(m.group(3)!);
      if (year < 100) year += 2000;
      return DateTime(year, int.parse(m.group(2)!), int.parse(m.group(1)!), int.tryParse(m.group(4) ?? '') ?? 0, int.tryParse(m.group(5) ?? '') ?? 0);
    }
    return null;
  }

  static String _clean(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

  // ------------------------------------------------------------------- LEADS
  Future<void> _importLeads(gs.SheetsApi api, String id, ImportResult r) async {
    final rows = await _rows(api, id, 'LEADS!A2:Q');
    for (final row in rows) {
      try {
        final leadId = _s(row, 0);
        final business = _s(row, 2);
        if (business.isEmpty && leadId.isEmpty) continue;
        final key = leadId.isNotEmpty ? 'sheet:$leadId' : 'sheet:${business.toLowerCase()}';
        if (await leads.byExternalKey(key) != null || (leadId.isNotEmpty && await leads.byId(leadId) != null)) {
          r.skipped++;
          continue;
        }
        final status = LeadStatus.fromLabel(_s(row, 10));
        final nextFollowUp = _d(row, 12);
        final lead = await leads.create(
          id: RegExp(r'^LD-\d+$').hasMatch(leadId) ? leadId : null,
          dateAdded: _d(row, 1),
          business: business.isEmpty ? leadId : business,
          contactPerson: _s(row, 3),
          phone: _s(row, 4),
          email: _s(row, 5),
          instagram: _s(row, 6),
          source: LeadSource.fromLabel(_s(row, 7)),
          service: ServiceType.fromLabel(_s(row, 8)),
          potentialValue: _n(row, 9),
          status: status,
          lastContact: _d(row, 11),
          nextFollowUp: nextFollowUp,
          notes: _s(row, 13),
          proposalLink: _s(row, 14),
          driveFolder: _s(row, 16),
          externalKey: key,
          logKind: ActivityKind.imported,
        );
        if (status.isOpen && nextFollowUp != null) {
          await followUps.create(
            leadId: lead.id,
            title: 'Follow up with ${lead.contactPerson.isNotEmpty ? lead.contactPerson : lead.business}',
            dueAt: DateTime(nextFollowUp.year, nextFollowUp.month, nextFollowUp.day),
            type: FollowUpType.call,
            notes: 'Imported from Google Sheets (${status.label})',
          );
        }
        r.leads++;
      } catch (e) {
        r.errors.add('LEADS row: $e');
      }
    }
  }

  // ----------------------------------------------------------------- CLIENTS
  Future<void> _importClients(gs.SheetsApi api, String id, ImportResult r) async {
    final rows = await _rows(api, id, 'CLIENTS!A2:M');
    for (final row in rows) {
      try {
        final cid = _s(row, 0);
        final name = _s(row, 1);
        if (name.isEmpty) continue;
        if (cid.isNotEmpty && await clients.byId(cid) != null) {
          r.skipped++;
          continue;
        }
        await clients.create(
          id: RegExp(r'^CL-\d+$').hasMatch(cid) ? cid : null,
          name: name,
          contactPerson: _s(row, 2),
          phone: _s(row, 3),
          email: _s(row, 4),
          instagram: _s(row, 5),
          service: ServiceType.fromLabel(_s(row, 6)),
          monthlyValue: _n(row, 7),
          projectValue: _n(row, 8),
          startDate: _d(row, 9),
          status: _clientStatus(_s(row, 10)),
          driveFolder: _s(row, 11),
          notes: _s(row, 12),
          logKind: ActivityKind.imported,
        );
        r.clients++;
      } catch (e) {
        r.errors.add('CLIENTS row: $e');
      }
    }
  }

  static ClientStatus _clientStatus(String s) {
    final l = s.toLowerCase();
    if (l.contains('pause')) return ClientStatus.paused;
    if (l.contains('churn') || l.contains('inactive') || l.contains('lost')) return ClientStatus.churned;
    if (l.contains('onboard')) return ClientStatus.onboarding;
    return ClientStatus.active;
  }

  Future<Client?> _resolveClient(String ref) async {
    if (ref.isEmpty) return null;
    final byId = await clients.byId(ref);
    if (byId != null) return byId;
    final all = await clients.all();
    final l = _clean(ref).toLowerCase();
    for (final c in all) {
      if (c.name.toLowerCase() == l) return c;
    }
    return null;
  }

  // ---------------------------------------------------------------- PROJECTS
  Future<void> _importProjects(gs.SheetsApi api, String id, ImportResult r) async {
    final rows = await _rows(api, id, 'PROJECTS!A2:N');
    for (final row in rows) {
      try {
        final pid = _s(row, 0);
        final name = _s(row, 2);
        if (name.isEmpty) continue;
        if (pid.isNotEmpty && await projects.byId(pid) != null) {
          r.skipped++;
          continue;
        }
        final client = await _resolveClient(_s(row, 1));
        if (client == null) {
          r.errors.add('PROJECTS "$name": client "${_s(row, 1)}" not found');
          continue;
        }
        var shoot = _d(row, 4);
        final time = _d(row, 5);
        if (shoot != null && time != null) {
          shoot = DateTime(shoot.year, shoot.month, shoot.day, time.hour, time.minute);
        }
        await projects.create(
          id: RegExp(r'^PR-\d+$').hasMatch(pid) ? pid : null,
          clientId: client.id,
          name: name,
          service: ServiceType.fromLabel(_s(row, 3)),
          shootDate: shoot,
          deadline: _d(row, 6),
          status: _projectStatus(_s(row, 7)),
          deliverables: _s(row, 8),
          paymentStatus: _paymentStatus(_s(row, 11)),
          driveFolder: _s(row, 12),
          notes: _s(row, 13),
          logKind: ActivityKind.imported,
        );
        r.projects++;
      } catch (e) {
        r.errors.add('PROJECTS row: $e');
      }
    }
  }

  static ProjectStatus _projectStatus(String s) {
    final l = s.toLowerCase();
    for (final v in ProjectStatus.values) {
      if (v.label.toLowerCase() == l) return v;
    }
    if (l.contains('shoot')) return ProjectStatus.shooting;
    if (l.contains('edit')) return ProjectStatus.editing;
    if (l.contains('review')) return ProjectStatus.clientReview;
    if (l.contains('revis')) return ProjectStatus.revisions;
    if (l.contains('deliver') || l.contains('done') || l.contains('complete')) return ProjectStatus.delivered;
    if (l.contains('close')) return ProjectStatus.closed;
    return ProjectStatus.planned;
  }

  static PaymentStatus _paymentStatus(String s) {
    final l = s.toLowerCase();
    if (l.contains('paid') && !l.contains('un') && !l.contains('part') && !l.contains('adv')) return PaymentStatus.paid;
    if (l.contains('part')) return PaymentStatus.partiallyPaid;
    if (l.contains('adv')) return PaymentStatus.advancePaid;
    return PaymentStatus.unpaid;
  }

  // -------------------------------------------------------------- FOLLOW UPS
  Future<void> _importFollowUps(gs.SheetsApi api, String id, ImportResult r) async {
    final rows = await _rows(api, id, "'FOLLOW UPS'!A2:H");
    final allLeads = await leads.all();
    for (final row in rows) {
      try {
        final fid = _s(row, 0);
        final date = _d(row, 4);
        if (date == null) continue;
        if (fid.isNotEmpty && await followUps.byId(fid) != null) {
          r.skipped++;
          continue;
        }
        final ref = _s(row, 1);
        final business = _s(row, 2).toLowerCase();
        Lead? lead;
        for (final l in allLeads) {
          if (l.id == ref || l.business.toLowerCase() == ref.toLowerCase() || (business.isNotEmpty && l.business.toLowerCase() == business)) {
            lead = l;
            break;
          }
        }
        final statusText = _s(row, 6).toLowerCase();
        await followUps.create(
          id: RegExp(r'^FU-\d+$').hasMatch(fid) ? fid : null,
          leadId: lead?.id,
          title: 'Follow up with ${_s(row, 3).isNotEmpty ? _s(row, 3) : (lead?.business ?? _s(row, 2))}',
          dueAt: DateTime(date.year, date.month, date.day),
          type: FollowUpType.fromLabel(_s(row, 5)),
          status: statusText.contains('done') || statusText.contains('complete') ? FollowUpStatus.done : (statusText.contains('skip') || statusText.contains('cancel') ? FollowUpStatus.skipped : FollowUpStatus.pending),
          notes: _s(row, 7),
        );
        r.followUps++;
      } catch (e) {
        r.errors.add('FOLLOW UPS row: $e');
      }
    }
  }

  // ----------------------------------------------------------------- FINANCE
  Future<void> _importFinance(gs.SheetsApi api, String id, ImportResult r) async {
    final rows = await _rows(api, id, 'FINANCE!A2:K');
    for (final row in rows) {
      try {
        final iid = _s(row, 0);
        final amount = _n(row, 4);
        if (iid.isEmpty && amount == 0) continue;
        if (iid.isNotEmpty && await invoices.byId(iid) != null) {
          r.skipped++;
          continue;
        }
        final client = await _resolveClient(_s(row, 1));
        if (client == null) {
          r.errors.add('FINANCE "$iid": client "${_s(row, 1)}" not found');
          continue;
        }
        final received = _n(row, 5);
        final due = _d(row, 7) ?? _d(row, 3) ?? DateTime.now();
        final statusText = _s(row, 8).toLowerCase();
        InvoiceStatus status;
        if (received >= amount && amount > 0) {
          status = InvoiceStatus.paid;
        } else if (received > 0) {
          status = InvoiceStatus.partiallyPaid;
        } else if (statusText.contains('draft')) {
          status = InvoiceStatus.draft;
        } else if (statusText.contains('cancel')) {
          status = InvoiceStatus.cancelled;
        } else if (due.isBefore(DateTime.now())) {
          status = InvoiceStatus.overdue;
        } else {
          status = InvoiceStatus.sent;
        }
        await invoices.create(
          id: RegExp(r'^INV-\d+$').hasMatch(iid) ? iid : null,
          clientId: client.id,
          invoiceDate: _d(row, 3),
          amount: amount,
          amountReceived: received,
          dueDate: due,
          status: status,
          paymentDate: _d(row, 9),
          description: _s(row, 2),
          notes: _s(row, 10),
        );
        r.invoices++;
      } catch (e) {
        r.errors.add('FINANCE row: $e');
      }
    }
  }

  // ---------------------------------------------------------- FORM RESPONSES
  Future<void> _importFormResponses(gs.SheetsApi api, String id, ImportResult r) async {
    final rows = await _rows(api, id, "'Form responses 1'!A2:J");
    if (rows.isEmpty) return;
    final existing = await leads.all();
    for (final row in rows) {
      try {
        final ts = _d(row, 0);
        final business = _s(row, 1);
        if (business.isEmpty) continue;
        final key = 'form:${ts?.toIso8601String() ?? business.toLowerCase()}';
        if (await leads.byExternalKey(key) != null) {
          r.skipped++;
          continue;
        }
        final email = _s(row, 4).toLowerCase();
        final dup = existing.any((l) =>
            l.business.toLowerCase() == business.toLowerCase() &&
            (email.isEmpty || l.email.toLowerCase() == email) &&
            (ts == null || (l.dateAdded.difference(ts).inHours).abs() < 48));
        if (dup) {
          r.skipped++;
          continue;
        }
        final lead = await leads.create(
          dateAdded: ts,
          business: business,
          contactPerson: _s(row, 2),
          phone: _s(row, 3),
          email: _s(row, 4),
          instagram: _s(row, 5),
          source: LeadSource.fromLabel(_s(row, 6)),
          service: ServiceType.fromLabel(_s(row, 7)),
          potentialValue: _n(row, 8),
          notes: _s(row, 9),
          externalKey: key,
          logKind: ActivityKind.imported,
        );
        existing.add(lead);
        if (onNewLead != null) await onNewLead!(lead);
        r.formLeads++;
      } catch (e) {
        r.errors.add('Form response row: $e');
      }
    }
  }
}
