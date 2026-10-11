// Round-trips the Excel workbook: export from one database, read it into a
// fresh one, and check that every record survived with its ID and fields.
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frameworkz/core/db/seed.dart';
import 'package:frameworkz/core/excel/workbook_service.dart';
import 'package:frameworkz/core/providers.dart';

WorkbookService service(AppDatabase db, Map<String, String> settings) => WorkbookService(
      db: db,
      leads: LeadsRepo(db),
      clients: ClientsRepo(db),
      projects: ProjectsRepo(db),
      followUps: FollowUpsRepo(db),
      invoices: InvoicesRepo(db),
      readPath: () => settings['path'] ?? '',
      readAutoSync: () => true,
      readLastSync: () => null,
      writeSetting: (k, v) async => settings[k] = v,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('workbook export and import keep every record', () async {
    final dir = await Directory.systemTemp.createTemp('fw_wb_');
    final path = '${dir.path}${Platform.pathSeparator}FrameWorkz.xlsx';

    final a = AppDatabase.forTesting(NativeDatabase.memory());
    await seedDefaults(a);
    final leads = LeadsRepo(a), clients = ClientsRepo(a), projects = ProjectsRepo(a), followUps = FollowUpsRepo(a), invoices = InvoicesRepo(a);
    final lead = await leads.create(business: 'Chennai Fitness Lab', contactPerson: 'Rahul', phone: '9876543210', email: 'r@x.in', source: LeadSource.instagram, service: ServiceType.reels, potentialValue: 30000, status: LeadStatus.proposalSent, nextFollowUp: DateTime(2026, 10, 15), notes: 'Reels for launch');
    final client = await clients.create(name: 'Bombay Bakehouse', contactPerson: 'Anita', email: 'a@b.in', service: ServiceType.socialContent, monthlyValue: 45000, status: ClientStatus.active);
    final project = await projects.create(clientId: client.id, name: 'October reels', service: ServiceType.reels, shootDate: DateTime(2026, 10, 20, 10), deadline: DateTime(2026, 10, 30), status: ProjectStatus.editing, deliverables: '8 reels', value: 60000);
    await followUps.create(leadId: lead.id, title: 'Call Rahul', dueAt: DateTime(2026, 10, 12, 16), hasTime: true, durationMinutes: 45, type: FollowUpType.meeting, notes: 'Zoom');
    await invoices.create(clientId: client.id, projectId: project.id, amount: 60000, amountReceived: 20000, dueDate: DateTime(2026, 10, 25), status: InvoiceStatus.sent, description: 'October retainer');

    final sa = service(a, {'path': path});
    expect(await sa.syncNow(), isTrue);
    expect(await File(path).length(), greaterThan(1000));

    final b = AppDatabase.forTesting(NativeDatabase.memory());
    await seedDefaults(b);
    final sb = service(b, {});
    final result = await sb.importFrom(path);
    expect(result.errors, isEmpty);
    expect(result.leads, 1);
    expect(result.clients, 1);
    expect(result.projects, 1);
    expect(result.followUps, 1);
    expect(result.invoices, 1);

    final lead2 = await LeadsRepo(b).byId(lead.id);
    expect(lead2, isNotNull);
    expect(lead2!.business, 'Chennai Fitness Lab');
    expect(lead2.status, LeadStatus.proposalSent);
    expect(lead2.potentialValue, 30000);
    expect(lead2.nextFollowUp, DateTime(2026, 10, 15));

    final client2 = await ClientsRepo(b).byId(client.id);
    expect(client2?.monthlyValue, 45000);

    final projects2 = await b.select(b.projects).get();
    expect(projects2.single.id, project.id);
    expect(projects2.single.clientId, client.id);
    expect(projects2.single.shootDate, DateTime(2026, 10, 20, 10));

    final fus = await b.select(b.followUps).get();
    expect(fus.single.hasTime, isTrue);
    expect(fus.single.dueAt, DateTime(2026, 10, 12, 16));
    expect(fus.single.durationMinutes, 45);

    final inv = await b.select(b.invoices).get();
    expect(inv.single.amountReceived, 20000);
    expect(inv.single.status, InvoiceStatus.sent);

    // Importing the same file again updates rather than duplicates.
    await sb.importFrom(path);
    expect((await b.select(b.leads).get()).length, 1);
    expect((await b.select(b.invoices).get()).length, 1);

    await a.close();
    await b.close();
    await dir.delete(recursive: true);
  });
}
