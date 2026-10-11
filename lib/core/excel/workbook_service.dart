import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../db/database.dart';
import '../db/repos.dart';
import '../google/sheets_import_service.dart' show ImportResult;
import '../platform.dart';

/// What the UI shows about the workbook link.
@immutable
class WorkbookStatus {
  const WorkbookStatus({this.path, this.syncing = false, this.lastSyncAt, this.error});
  final String? path;
  final bool syncing;
  final DateTime? lastSyncAt;
  final String? error;

  bool get connected => path != null && path!.isNotEmpty;

  WorkbookStatus copyWith({String? path, bool? syncing, DateTime? lastSyncAt, String? error, bool clearError = false, bool clearPath = false}) => WorkbookStatus(
        path: clearPath ? null : (path ?? this.path),
        syncing: syncing ?? this.syncing,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Keeps an Excel workbook (.xlsx) in step with the app.
///
/// The workbook is the user-facing copy of all business data: one sheet each
/// for Leads, Clients, Projects, Follow-ups and Invoices. Every change made in
/// the app is written to the workbook a moment later, and the workbook can be
/// read back in (rows are matched by their ID column) so edits made in Excel
/// flow into the app as well.
class WorkbookService {
  WorkbookService({
    required this.db,
    required this.leads,
    required this.clients,
    required this.projects,
    required this.followUps,
    required this.invoices,
    required this.readPath,
    required this.readAutoSync,
    required this.readLastSync,
    required this.writeSetting,
  });

  final AppDatabase db;
  final LeadsRepo leads;
  final ClientsRepo clients;
  final ProjectsRepo projects;
  final FollowUpsRepo followUps;
  final InvoicesRepo invoices;
  final String Function() readPath;
  final bool Function() readAutoSync;
  final DateTime? Function() readLastSync;
  final Future<void> Function(String key, String value) writeSetting;

  static const keyPath = 'workbook.path';
  static const keyAutoSync = 'workbook.autoSync';
  static const keyLastSyncAt = 'workbook.lastSyncAt';
  static const keyPromptOff = 'workbook.promptOff';

  static const fileName = 'FrameWorkz.xlsx';
  static const sheetLeads = 'Leads';
  static const sheetClients = 'Clients';
  static const sheetProjects = 'Projects';
  static const sheetFollowUps = 'Follow-ups';
  static const sheetInvoices = 'Invoices';

  final ValueNotifier<WorkbookStatus> status = ValueNotifier(const WorkbookStatus());

  StreamSubscription<Set<TableUpdate>>? _sub;
  Timer? _debounce;
  bool _writing = false;
  bool _dirty = false;

  String? get path => readPath().isEmpty ? null : readPath();
  bool get isConfigured => path != null;

  /// On phones the workbook lives in the app's documents folder; on desktop a
  /// sensible default inside Documents is proposed but the user can pick any
  /// location.
  Future<String> defaultPath() async {
    final dir = await getApplicationDocumentsDirectory();
    if (AppPlatform.isDesktop) return p.join(dir.path, 'FrameWorkz', fileName);
    return p.join(dir.path, fileName);
  }

  // ------------------------------------------------------------------ lifecycle
  void start() {
    status.value = WorkbookStatus(path: path, lastSyncAt: readLastSync());
    _sub?.cancel();
    _sub = db.tableUpdates().listen((updates) {
      final names = updates.map((u) => u.table).toSet();
      const watched = {'leads', 'clients', 'projects', 'follow_ups', 'invoices'};
      if (names.intersection(watched).isEmpty) return;
      _scheduleExport();
    });
  }

  void _scheduleExport() {
    if (!isConfigured || !readAutoSync()) return;
    _dirty = true;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 2500), () => syncNow(quiet: true));
  }

  void dispose() {
    _sub?.cancel();
    _debounce?.cancel();
    status.dispose();
  }

  // ------------------------------------------------------------------ connect
  /// Links the app to [target]. If the file already exists its rows are read
  /// in first (so an existing workbook is never wiped), then the app writes
  /// the merged data back out.
  Future<ImportResult?> connect(String target) async {
    ImportResult? imported;
    final file = File(target);
    if (await file.exists() && await file.length() > 0) {
      imported = await importFrom(target);
    }
    await writeSetting(keyPath, target);
    status.value = status.value.copyWith(path: target, clearError: true);
    await syncNow();
    return imported;
  }

  Future<void> disconnect() async {
    await writeSetting(keyPath, '');
    status.value = status.value.copyWith(clearPath: true, clearError: true);
  }

  // ------------------------------------------------------------------- export
  /// Writes every table to the workbook. Safe to call at any time.
  Future<bool> syncNow({bool quiet = false}) async {
    final target = path;
    if (target == null) return false;
    if (_writing) {
      _dirty = true;
      return true;
    }
    _writing = true;
    _dirty = false;
    status.value = status.value.copyWith(syncing: true, clearError: true);
    try {
      final bytes = await buildWorkbook();
      final file = File(target);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      final now = DateTime.now();
      await writeSetting(keyLastSyncAt, now.toIso8601String());
      status.value = status.value.copyWith(syncing: false, lastSyncAt: now, path: target);
      return true;
    } catch (e) {
      debugPrint('Workbook write failed: $e');
      status.value = status.value.copyWith(syncing: false, error: _friendly(e));
      return false;
    } finally {
      _writing = false;
      if (_dirty) _scheduleExport();
    }
  }

  String _friendly(Object e) {
    final s = e.toString();
    if (s.contains('being used by another process') || s.contains('errno = 32') || s.contains('Sharing violation')) {
      return 'The workbook is open in Excel. Close it there and FrameWorkz will save your changes.';
    }
    if (s.contains('Permission denied') || s.contains('errno = 13')) return 'FrameWorkz is not allowed to write to that location. Pick another folder.';
    if (s.contains('No such file') || s.contains('errno = 2') || s.contains('errno = 3')) return 'The workbook folder no longer exists. Pick a new location.';
    return 'Could not save the workbook: $s';
  }

  Future<List<int>> buildWorkbook() async {
    final excel = Excel.createExcel();
    final allLeads = await (db.select(db.leads)..orderBy([(l) => OrderingTerm.asc(l.id)])).get();
    final allClients = await (db.select(db.clients)..orderBy([(c) => OrderingTerm.asc(c.id)])).get();
    final allProjects = await (db.select(db.projects)..orderBy([(x) => OrderingTerm.asc(x.id)])).get();
    final allFollowUps = await (db.select(db.followUps)..orderBy([(f) => OrderingTerm.asc(f.dueAt)])).get();
    final allInvoices = await (db.select(db.invoices)..orderBy([(i) => OrderingTerm.asc(i.id)])).get();
    final clientName = {for (final c in allClients) c.id: c.name};
    final leadName = {for (final l in allLeads) l.id: l.business};

    _sheet(excel, sheetLeads, [
      'ID', 'Date added', 'Business', 'Contact person', 'Phone', 'Email', 'Instagram', 'Source', 'Service', 'Potential value', 'Status', 'Last contact', 'Next follow-up', 'Notes', 'Proposal link', 'Drive folder', 'Lost reason', 'Client ID',
    ], [
      for (final l in allLeads)
        [
          _t(l.id), _dt(l.dateAdded), _t(l.business), _t(l.contactPerson), _t(l.phone), _t(l.email), _t(l.instagram), _t(l.source.label), _t(l.service.label), _num(l.potentialValue), _t(l.status.label), _d(l.lastContact), _d(l.nextFollowUp), _t(l.notes), _t(l.proposalLink), _t(l.driveFolder), _t(l.lostReason), _t(l.clientId ?? ''),
        ],
    ]);
    _sheet(excel, sheetClients, [
      'ID', 'Name', 'Contact person', 'Phone', 'Email', 'Instagram', 'Service', 'Monthly value', 'Project value', 'Start date', 'Status', 'Drive folder', 'Notes', 'Lead ID',
    ], [
      for (final c in allClients)
        [
          _t(c.id), _t(c.name), _t(c.contactPerson), _t(c.phone), _t(c.email), _t(c.instagram), _t(c.service.label), _num(c.monthlyValue), _num(c.projectValue), _d(c.startDate), _t(c.status.label), _t(c.driveFolder), _t(c.notes), _t(c.leadId ?? ''),
        ],
    ]);
    _sheet(excel, sheetProjects, [
      'ID', 'Client ID', 'Client', 'Name', 'Service', 'Shoot date', 'Deadline', 'Status', 'Deliverables', 'Client review', 'Final delivery', 'Payment status', 'Value', 'Drive folder', 'Notes',
    ], [
      for (final x in allProjects)
        [
          _t(x.id), _t(x.clientId), _t(clientName[x.clientId] ?? ''), _t(x.name), _t(x.service.label), _dt(x.shootDate), _d(x.deadline), _t(x.status.label), _t(x.deliverables), _d(x.clientReviewDate), _d(x.finalDeliveryDate), _t(x.paymentStatus.label), _num(x.value), _t(x.driveFolder), _t(x.notes),
        ],
    ]);
    _sheet(excel, sheetFollowUps, [
      'ID', 'Lead ID', 'Client ID', 'Who', 'Title', 'Due', 'Has time', 'Duration (min)', 'Type', 'Status', 'Notes', 'Outcome', 'Meet link', 'Completed at',
    ], [
      for (final f in allFollowUps)
        [
          _t(f.id), _t(f.leadId ?? ''), _t(f.clientId ?? ''), _t(f.leadId != null ? (leadName[f.leadId] ?? '') : (f.clientId != null ? (clientName[f.clientId] ?? '') : '')), _t(f.title), f.hasTime ? _dt(f.dueAt) : _d(f.dueAt), BoolCellValue(f.hasTime), IntCellValue(f.durationMinutes), _t(f.type.label), _t(f.status.label), _t(f.notes), _t(f.outcome), _t(f.meetLink), _dt(f.completedAt),
        ],
    ]);
    _sheet(excel, sheetInvoices, [
      'ID', 'Client ID', 'Client', 'Project ID', 'Invoice date', 'Amount', 'Amount received', 'Due date', 'Status', 'Payment date', 'Description', 'Notes',
    ], [
      for (final i in allInvoices)
        [
          _t(i.id), _t(i.clientId), _t(clientName[i.clientId] ?? ''), _t(i.projectId ?? ''), _d(i.invoiceDate), _num(i.amount), _num(i.amountReceived), _d(i.dueDate), _t(i.status.label), _d(i.paymentDate), _t(i.description), _t(i.notes),
        ],
    ]);
    if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');
    excel.setDefaultSheet(sheetLeads);
    final bytes = excel.encode();
    if (bytes == null) throw StateError('Workbook could not be encoded');
    return bytes;
  }

  void _sheet(Excel excel, String name, List<String> headers, List<List<CellValue?>> rows) {
    final sheet = excel[name];
    final headerStyle = CellStyle(bold: true);
    for (var c = 0; c < headers.length; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0));
      cell.value = TextCellValue(headers[c]);
      cell.cellStyle = headerStyle;
      sheet.setColumnWidth(c, headers[c].length < 10 ? 14 : (headers[c].length.toDouble() + 6));
    }
    for (final r in rows) {
      sheet.appendRow(r);
    }
  }

  static CellValue _t(String s) => TextCellValue(s);
  static CellValue _num(double v) => DoubleCellValue(v);
  static CellValue? _d(DateTime? d) => d == null ? null : DateCellValue.fromDateTime(d);
  static CellValue? _dt(DateTime? d) => d == null ? null : DateTimeCellValue.fromDateTime(d);

  // ------------------------------------------------------------------- import
  /// Reads a workbook and merges it into the app. Rows whose ID exists are
  /// updated; rows without a known ID are created.
  Future<ImportResult> importFrom(String source) async {
    final result = ImportResult();
    final bytes = await File(source).readAsBytes();
    final excel = Excel.decodeBytes(bytes);

    // Clients first so projects / invoices can resolve them.
    for (final row in _records(excel, sheetClients)) {
      try {
        await _upsertClient(row, result);
      } catch (e) {
        result.errors.add('Clients: $e');
      }
    }
    for (final row in _records(excel, sheetLeads)) {
      try {
        await _upsertLead(row, result);
      } catch (e) {
        result.errors.add('Leads: $e');
      }
    }
    for (final row in _records(excel, sheetProjects)) {
      try {
        await _upsertProject(row, result);
      } catch (e) {
        result.errors.add('Projects: $e');
      }
    }
    for (final row in _records(excel, sheetFollowUps)) {
      try {
        await _upsertFollowUp(row, result);
      } catch (e) {
        result.errors.add('Follow-ups: $e');
      }
    }
    for (final row in _records(excel, sheetInvoices)) {
      try {
        await _upsertInvoice(row, result);
      } catch (e) {
        result.errors.add('Invoices: $e');
      }
    }
    return result;
  }

  /// Rows of a sheet keyed by lower-case header name.
  List<Map<String, CellValue?>> _records(Excel excel, String sheet) {
    final table = excel.tables[sheet];
    if (table == null || table.rows.isEmpty) return const [];
    final headers = table.rows.first.map((c) => _str(c?.value).toLowerCase().trim()).toList();
    final out = <Map<String, CellValue?>>[];
    for (final row in table.rows.skip(1)) {
      final m = <String, CellValue?>{};
      var empty = true;
      for (var i = 0; i < headers.length && i < row.length; i++) {
        final v = row[i]?.value;
        if (v != null && _str(v).trim().isNotEmpty) empty = false;
        m[headers[i]] = v;
      }
      if (!empty) out.add(m);
    }
    return out;
  }

  static String _str(CellValue? v) => switch (v) {
        null => '',
        TextCellValue t => t.value.toString(),
        IntCellValue i => i.value.toString(),
        DoubleCellValue d => d.value == d.value.roundToDouble() ? d.value.toInt().toString() : d.value.toString(),
        BoolCellValue b => b.value ? 'true' : 'false',
        DateCellValue d => d.asDateTimeLocal().toIso8601String(),
        DateTimeCellValue d => d.asDateTimeLocal().toIso8601String(),
        TimeCellValue t => '${t.hour}:${t.minute}',
        FormulaCellValue f => f.formula,
      };

  static String _s(Map<String, CellValue?> r, String key) => _str(r[key.toLowerCase()]).trim();

  static double _n(Map<String, CellValue?> r, String key) {
    final v = r[key.toLowerCase()];
    if (v is IntCellValue) return v.value.toDouble();
    if (v is DoubleCellValue) return v.value;
    return double.tryParse(_str(v).replaceAll(RegExp(r'[^0-9.\-]'), '')) ?? 0;
  }

  static bool _b(Map<String, CellValue?> r, String key) {
    final v = r[key.toLowerCase()];
    if (v is BoolCellValue) return v.value;
    final s = _str(v).toLowerCase();
    return s == 'true' || s == 'yes' || s == '1';
  }

  static DateTime? _date(Map<String, CellValue?> r, String key) {
    final v = r[key.toLowerCase()];
    switch (v) {
      case null:
        return null;
      case DateCellValue d:
        return d.asDateTimeLocal();
      case DateTimeCellValue d:
        return d.asDateTimeLocal();
      case IntCellValue i:
        return i.value <= 0 ? null : DateTime(1899, 12, 30).add(Duration(days: i.value));
      case DoubleCellValue d:
        if (d.value <= 0) return null;
        final whole = d.value.floor();
        return DateTime(1899, 12, 30).add(Duration(days: whole, milliseconds: ((d.value - whole) * 86400000).round()));
      default:
        final s = _str(v).trim();
        if (s.isEmpty) return null;
        final iso = DateTime.tryParse(s);
        if (iso != null) return iso;
        final m = RegExp(r'^(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})(?:\s+(\d{1,2}):(\d{2}))?').firstMatch(s);
        if (m == null) return null;
        var year = int.parse(m.group(3)!);
        if (year < 100) year += 2000;
        return DateTime(year, int.parse(m.group(2)!), int.parse(m.group(1)!), int.tryParse(m.group(4) ?? '') ?? 0, int.tryParse(m.group(5) ?? '') ?? 0);
    }
  }

  static T _enum<T extends Enum>(List<T> values, String Function(T) labelOf, String raw, T fallback) {
    final l = raw.trim().toLowerCase();
    if (l.isEmpty) return fallback;
    for (final v in values) {
      if (labelOf(v).toLowerCase() == l || v.name.toLowerCase() == l) return v;
    }
    for (final v in values) {
      if (labelOf(v).toLowerCase().contains(l) || l.contains(labelOf(v).toLowerCase())) return v;
    }
    return fallback;
  }

  static String? _nullable(String s) => s.isEmpty ? null : s;

  Future<void> _upsertClient(Map<String, CellValue?> r, ImportResult res) async {
    final id = _s(r, 'ID');
    final name = _s(r, 'Name');
    if (name.isEmpty) return;
    final existing = id.isEmpty ? null : await clients.byId(id);
    final companion = ClientsCompanion(
      name: Value(name),
      contactPerson: Value(_s(r, 'Contact person')),
      phone: Value(_s(r, 'Phone')),
      email: Value(_s(r, 'Email')),
      instagram: Value(_s(r, 'Instagram')),
      service: Value(ServiceType.fromLabel(_s(r, 'Service'))),
      monthlyValue: Value(_n(r, 'Monthly value')),
      projectValue: Value(_n(r, 'Project value')),
      startDate: Value(_date(r, 'Start date') ?? existing?.startDate ?? DateTime.now()),
      status: Value(_enum(ClientStatus.values, (e) => e.label, _s(r, 'Status'), existing?.status ?? ClientStatus.active)),
      driveFolder: Value(_s(r, 'Drive folder')),
      notes: Value(_s(r, 'Notes')),
      leadId: Value(_nullable(_s(r, 'Lead ID')) ?? existing?.leadId),
      updatedAt: Value(DateTime.now()),
    );
    if (existing != null) {
      await (db.update(db.clients)..where((c) => c.id.equals(id))).write(companion);
    } else {
      await clients.create(
        id: RegExp(r'^CL-\d+$').hasMatch(id) ? id : null,
        name: name,
        contactPerson: _s(r, 'Contact person'),
        phone: _s(r, 'Phone'),
        email: _s(r, 'Email'),
        instagram: _s(r, 'Instagram'),
        service: ServiceType.fromLabel(_s(r, 'Service')),
        monthlyValue: _n(r, 'Monthly value'),
        projectValue: _n(r, 'Project value'),
        startDate: _date(r, 'Start date'),
        status: _enum(ClientStatus.values, (e) => e.label, _s(r, 'Status'), ClientStatus.active),
        driveFolder: _s(r, 'Drive folder'),
        notes: _s(r, 'Notes'),
        logKind: ActivityKind.imported,
      );
    }
    res.clients++;
  }

  Future<void> _upsertLead(Map<String, CellValue?> r, ImportResult res) async {
    final id = _s(r, 'ID');
    final business = _s(r, 'Business');
    if (business.isEmpty) return;
    final existing = id.isEmpty ? null : await leads.byId(id);
    if (existing != null) {
      await (db.update(db.leads)..where((l) => l.id.equals(id))).write(LeadsCompanion(
        business: Value(business),
        contactPerson: Value(_s(r, 'Contact person')),
        phone: Value(_s(r, 'Phone')),
        email: Value(_s(r, 'Email')),
        instagram: Value(_s(r, 'Instagram')),
        source: Value(LeadSource.fromLabel(_s(r, 'Source'))),
        service: Value(ServiceType.fromLabel(_s(r, 'Service'))),
        potentialValue: Value(_n(r, 'Potential value')),
        status: Value(LeadStatus.fromLabel(_s(r, 'Status'))),
        lastContact: Value(_date(r, 'Last contact')),
        nextFollowUp: Value(_date(r, 'Next follow-up')),
        notes: Value(_s(r, 'Notes')),
        proposalLink: Value(_s(r, 'Proposal link')),
        driveFolder: Value(_s(r, 'Drive folder')),
        lostReason: Value(_s(r, 'Lost reason')),
        clientId: Value(_nullable(_s(r, 'Client ID')) ?? existing.clientId),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await leads.create(
        id: RegExp(r'^LD-\d+$').hasMatch(id) ? id : null,
        dateAdded: _date(r, 'Date added'),
        business: business,
        contactPerson: _s(r, 'Contact person'),
        phone: _s(r, 'Phone'),
        email: _s(r, 'Email'),
        instagram: _s(r, 'Instagram'),
        source: LeadSource.fromLabel(_s(r, 'Source')),
        service: ServiceType.fromLabel(_s(r, 'Service')),
        potentialValue: _n(r, 'Potential value'),
        status: LeadStatus.fromLabel(_s(r, 'Status')),
        lastContact: _date(r, 'Last contact'),
        nextFollowUp: _date(r, 'Next follow-up'),
        notes: _s(r, 'Notes'),
        proposalLink: _s(r, 'Proposal link'),
        driveFolder: _s(r, 'Drive folder'),
        externalKey: id.isEmpty ? null : 'workbook:$id',
        logKind: ActivityKind.imported,
      );
    }
    res.leads++;
  }

  Future<Client?> _client(Map<String, CellValue?> r) async {
    final id = _s(r, 'Client ID');
    if (id.isNotEmpty) {
      final c = await clients.byId(id);
      if (c != null) return c;
    }
    final name = _s(r, 'Client').toLowerCase();
    if (name.isEmpty) return null;
    for (final c in await clients.all()) {
      if (c.name.toLowerCase() == name) return c;
    }
    return null;
  }

  Future<void> _upsertProject(Map<String, CellValue?> r, ImportResult res) async {
    final id = _s(r, 'ID');
    final name = _s(r, 'Name');
    if (name.isEmpty) return;
    final client = await _client(r);
    final existing = id.isEmpty ? null : await (db.select(db.projects)..where((x) => x.id.equals(id))).getSingleOrNull();
    if (client == null && existing == null) {
      res.errors.add('Project "$name": client not found');
      return;
    }
    if (existing != null) {
      await (db.update(db.projects)..where((x) => x.id.equals(id))).write(ProjectsCompanion(
        clientId: Value(client?.id ?? existing.clientId),
        name: Value(name),
        service: Value(ServiceType.fromLabel(_s(r, 'Service'))),
        shootDate: Value(_date(r, 'Shoot date')),
        deadline: Value(_date(r, 'Deadline')),
        status: Value(_enum(ProjectStatus.values, (e) => e.label, _s(r, 'Status'), existing.status)),
        deliverables: Value(_s(r, 'Deliverables')),
        clientReviewDate: Value(_date(r, 'Client review')),
        finalDeliveryDate: Value(_date(r, 'Final delivery')),
        paymentStatus: Value(_enum(PaymentStatus.values, (e) => e.label, _s(r, 'Payment status'), existing.paymentStatus)),
        value: Value(_n(r, 'Value')),
        driveFolder: Value(_s(r, 'Drive folder')),
        notes: Value(_s(r, 'Notes')),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await projects.create(
        id: RegExp(r'^PR-\d+$').hasMatch(id) ? id : null,
        clientId: client!.id,
        name: name,
        service: ServiceType.fromLabel(_s(r, 'Service')),
        shootDate: _date(r, 'Shoot date'),
        deadline: _date(r, 'Deadline'),
        status: _enum(ProjectStatus.values, (e) => e.label, _s(r, 'Status'), ProjectStatus.values.first),
        deliverables: _s(r, 'Deliverables'),
        value: _n(r, 'Value'),
        notes: _s(r, 'Notes'),
      );
    }
    res.projects++;
  }

  Future<void> _upsertFollowUp(Map<String, CellValue?> r, ImportResult res) async {
    final id = _s(r, 'ID');
    final title = _s(r, 'Title');
    final due = _date(r, 'Due');
    if (title.isEmpty || due == null) return;
    final existing = id.isEmpty ? null : await (db.select(db.followUps)..where((f) => f.id.equals(id))).getSingleOrNull();
    final leadId = _nullable(_s(r, 'Lead ID'));
    final clientId = _nullable(_s(r, 'Client ID'));
    final status = _enum(FollowUpStatus.values, (e) => e.label, _s(r, 'Status'), existing?.status ?? FollowUpStatus.pending);
    if (existing != null) {
      await followUps.patch(id, FollowUpsCompanion(
        leadId: Value(leadId ?? existing.leadId),
        clientId: Value(clientId ?? existing.clientId),
        title: Value(title),
        dueAt: Value(due),
        hasTime: Value(_b(r, 'Has time')),
        durationMinutes: Value(_n(r, 'Duration (min)').round() == 0 ? existing.durationMinutes : _n(r, 'Duration (min)').round()),
        type: Value(FollowUpType.fromLabel(_s(r, 'Type'))),
        status: Value(status),
        notes: Value(_s(r, 'Notes')),
        outcome: Value(_s(r, 'Outcome')),
        meetLink: Value(_s(r, 'Meet link')),
        completedAt: Value(_date(r, 'Completed at') ?? (status == FollowUpStatus.pending ? null : existing.completedAt)),
      ));
    } else {
      if (leadId == null && clientId == null) {
        res.errors.add('Follow-up "$title": no lead or client');
        return;
      }
      await followUps.create(
        leadId: leadId,
        clientId: clientId,
        title: title,
        dueAt: due,
        hasTime: _b(r, 'Has time'),
        durationMinutes: _n(r, 'Duration (min)').round() == 0 ? 30 : _n(r, 'Duration (min)').round(),
        type: FollowUpType.fromLabel(_s(r, 'Type')),
        notes: _s(r, 'Notes'),
      );
    }
    res.followUps++;
  }

  Future<void> _upsertInvoice(Map<String, CellValue?> r, ImportResult res) async {
    final id = _s(r, 'ID');
    final amount = _n(r, 'Amount');
    final client = await _client(r);
    final existing = id.isEmpty ? null : await (db.select(db.invoices)..where((i) => i.id.equals(id))).getSingleOrNull();
    if (client == null && existing == null) {
      if (amount > 0) res.errors.add('Invoice $id: client not found');
      return;
    }
    final due = _date(r, 'Due date');
    if (existing != null) {
      await (db.update(db.invoices)..where((i) => i.id.equals(id))).write(InvoicesCompanion(
        clientId: Value(client?.id ?? existing.clientId),
        projectId: Value(_nullable(_s(r, 'Project ID')) ?? existing.projectId),
        invoiceDate: Value(_date(r, 'Invoice date') ?? existing.invoiceDate),
        amount: Value(amount),
        amountReceived: Value(_n(r, 'Amount received')),
        dueDate: Value(due ?? existing.dueDate),
        status: Value(_enum(InvoiceStatus.values, (e) => e.label, _s(r, 'Status'), existing.status)),
        paymentDate: Value(_date(r, 'Payment date')),
        description: Value(_s(r, 'Description')),
        notes: Value(_s(r, 'Notes')),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      if (amount <= 0 || due == null) return;
      await invoices.create(
        clientId: client!.id,
        projectId: _nullable(_s(r, 'Project ID')),
        amount: amount,
        amountReceived: _n(r, 'Amount received'),
        dueDate: due,
        status: _enum(InvoiceStatus.values, (e) => e.label, _s(r, 'Status'), InvoiceStatus.values.first),
        description: _s(r, 'Description'),
      );
    }
    res.invoices++;
  }
}
