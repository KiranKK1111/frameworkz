// Renders every screen and dialog at phone, tablet and desktop sizes and
// fails on any layout exception (overflow, unbounded constraints, …).
//
//   flutter test test/screens_test.dart
//
// Uses an in-memory SQLite database seeded with sample data, so no platform
// plugins are touched.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frameworkz/app/app.dart';
import 'package:frameworkz/app/router.dart';
import 'package:frameworkz/core/db/seed.dart';
import 'package:frameworkz/core/email/template_engine.dart';
import 'package:frameworkz/core/providers.dart';
import 'package:frameworkz/features/email/compose_email_dialog.dart';
import 'package:frameworkz/features/finance/invoice_form_dialog.dart';
import 'package:frameworkz/features/followups/followup_actions.dart';
import 'package:frameworkz/features/leads/convert_to_client_dialog.dart';
import 'package:frameworkz/features/leads/status_change_dialog.dart';
import 'package:frameworkz/ui/widgets/bz_modal.dart';

class _Size {
  const _Size(this.name, this.width, this.height, {this.textScale = 1.0});
  final String name;
  final double width;
  final double height;
  final double textScale;
}

const _sizes = [
  _Size('phone-small', 360, 780, textScale: 1.1),
  _Size('phone', 390, 844),
  _Size('tablet', 900, 1200),
  _Size('desktop', 1400, 900),
  _Size('desktop-wide', 1920, 1080),
];

late AppDatabase db;
late ProviderContainer container;
late Lead sampleLead;
late Client sampleClient;
late Invoice sampleInvoice;
late FollowUp sampleFollowUp;
final List<String> failures = [];
final List<String> pendingLocs = [];

Future<void> seedSample(AppDatabase db) async {
  final leads = LeadsRepo(db);
  final clients = ClientsRepo(db);
  final projects = ProjectsRepo(db);
  final followUps = FollowUpsRepo(db);
  final invoices = InvoicesRepo(db);
  sampleLead = await leads.create(
    business: 'Chennai Fitness Lab',
    contactPerson: 'Rahul Sharma',
    phone: '9876543210',
    email: 'rahul@chennaifit.in',
    instagram: '@chennaifit',
    source: LeadSource.instagram,
    service: ServiceType.monthlyRetainer,
    potentialValue: 30000,
    status: LeadStatus.proposalSent,
    notes: 'Wants reels for the new branch launch.',
    lastContact: DateTime.now().subtract(const Duration(days: 2)),
    nextFollowUp: DateTime.now().subtract(const Duration(days: 1)),
    proposalLink: 'https://drive.google.com/proposal',
  );
  for (var i = 0; i < 6; i++) {
    await leads.create(
      business: 'Studio Lead $i with a fairly long business name',
      contactPerson: 'Contact Person $i',
      phone: '98765000$i',
      email: 'lead$i@example.com',
      source: LeadSource.values[i % LeadSource.values.length],
      service: ServiceType.values[i % ServiceType.values.length],
      potentialValue: 12000.0 * (i + 1),
      status: LeadStatus.values[i % LeadStatus.values.length],
    );
  }
  sampleClient = await clients.create(
    name: 'Bombay Bakehouse Pvt Ltd',
    contactPerson: 'Anita Desai',
    phone: '9811111111',
    email: 'anita@bakehouse.in',
    service: ServiceType.socialContent,
    monthlyValue: 45000,
    status: ClientStatus.active,
    notes: 'Monthly retainer, 8 reels.',
  );
  final project = await projects.create(
    clientId: sampleClient.id,
    name: 'October launch reels and photography',
    service: ServiceType.reels,
    shootDate: DateTime.now().add(const Duration(days: 3, hours: 10)),
    deadline: DateTime.now().add(const Duration(days: 10)),
    status: ProjectStatus.editing,
    deliverables: '8 reels, 20 photos',
    value: 60000,
  );
  sampleInvoice = await invoices.create(
    clientId: sampleClient.id,
    projectId: project.id,
    amount: 60000,
    amountReceived: 20000,
    dueDate: DateTime.now().subtract(const Duration(days: 3)),
    status: InvoiceStatus.overdue,
    description: 'October retainer',
  );
  await invoices.create(clientId: sampleClient.id, amount: 15000, dueDate: DateTime.now().add(const Duration(days: 5)), status: InvoiceStatus.sent, description: 'Extra shoot day');
  sampleFollowUp = await followUps.create(leadId: sampleLead.id, title: 'Follow up on proposal with Rahul Sharma', dueAt: DateTime.now().subtract(const Duration(days: 1)), type: FollowUpType.email);
  await followUps.create(leadId: sampleLead.id, title: 'Discovery call', dueAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16), hasTime: true, durationMinutes: 45, type: FollowUpType.meeting, notes: 'Zoom');
  await followUps.create(clientId: sampleClient.id, title: 'Monthly review with Anita', dueAt: DateTime.now().add(const Duration(days: 2)), type: FollowUpType.call);
  await db.logActivity(entityType: EntityType.lead, entityId: sampleLead.id, kind: ActivityKind.statusChanged, title: 'Status changed: Replied → Proposal Sent', detail: 'Sent the deck');
  await db.pushNotification(kind: NotificationKind.followUpOverdue, title: 'Overdue · Follow up with Rahul', body: 'Chennai Fitness Lab');
}

Future<void> settle(WidgetTester tester, {int frames = 6}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 350));
  }
}

void check(WidgetTester tester, String label) {
  final e = tester.takeException();
  if (e != null) {
    final text = e.toString().split('\n').first;
    final locs = pendingLocs.toSet().join(', ');
    failures.add('$label: $text @ $locs');
    // drain any follow-up exceptions for the same frame
    while (tester.takeException() != null) {}
  }
  pendingLocs.clear();
}

BuildContext ctx(WidgetTester tester) => tester.element(find.byType(Scaffold).first);

Future<void> closeTop(WidgetTester tester) async {
  rootNavigatorKey.currentState?.maybePop();
  await settle(tester, frames: 3);
}

Future<void> visit(WidgetTester tester, String size, String route) async {
  appRouter.go(route);
  await settle(tester);
  check(tester, '[$size] $route');
}

Future<void> openDialog(WidgetTester tester, String size, String label, Future<void> Function(BuildContext c) open) async {
  final c = ctx(tester);
  open(c).ignore();
  await settle(tester);
  check(tester, '[$size] dialog: $label');
  await closeTop(tester);
  check(tester, '[$size] dialog close: $label');
}

Future<void> tapText(WidgetTester tester, String size, String text, {bool close = true}) async {
  var f = find.text(text);
  if (f.evaluate().isEmpty) {
    // Off-screen in a scrolling list? Bring it into view first.
    try {
      await tester.scrollUntilVisible(f, 200, scrollable: find.byType(Scrollable).first);
      await settle(tester, frames: 2);
    } catch (_) {}
    f = find.text(text);
  }
  if (f.evaluate().isEmpty) {
    final texts = find.byType(Text).evaluate().map((e) => (e.widget as Text).data ?? '').where((d) => d.isNotEmpty).take(40).join(' | ');
    failures.add('[$size] missing control "$text" · route=${appRouter.routerDelegate.currentConfiguration.uri} · texts: $texts');
    return;
  }
  // Off-screen rows would otherwise be "tapped" through the bottom nav bar.
  try {
    await tester.ensureVisible(f.first);
    await settle(tester, frames: 2);
  } catch (_) {}
  await tester.tap(f.first, warnIfMissed: false);
  await settle(tester);
  check(tester, '[$size] tap "$text"');
  if (close) {
    await closeTop(tester);
    check(tester, '[$size] after closing "$text"');
    if (find.byType(BottomSheet).evaluate().isNotEmpty || find.byType(Dialog).evaluate().isNotEmpty) {
      failures.add('[$size] a sheet or dialog is still open after closing "$text"');
      await closeTop(tester);
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedDefaults(db);
    await seedSample(db);
    container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    await container.read(settingsStoreProvider).ready;
    await db.setSetting(Keys.profileName, 'Lokesh Kumar');
    await db.setSetting(Keys.profileBusiness, 'Lokesh Films');
    await db.setSetting(Keys.workbookPromptOff, 'true');
  });

  testWidgets('every screen renders without layout errors at every size', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    final prevOnError = FlutterError.onError!;
    FlutterError.onError = (details) {
      var loc = 'unknown';
      for (final n in details.informationCollector?.call() ?? const <DiagnosticsNode>[]) {
        final v = n.value;
        if (v is DebugCreator) {
          loc = v.element.debugGetCreatorChain(40).split(' \u2190 ').where((w) => !RegExp(r'^(Listener|RawGestureDetector|GestureDetector|MouseRegion|Semantics|_\w+|Padding|DecoratedBox|Container|AnimatedContainer|Builder|DefaultSelectionStyle|Expanded|Flexible|SizedBox|Align|Focus|Actions|IgnorePointer|KeyedSubtree|RepaintBoundary|ClipRRect|ClipRect|Material|InkWell|InkResponse|PhysicalModel|PhysicalShape|AnimatedBuilder|AnimatedPhysicalModel|Tooltip|Hero|FadeTransition|SlideTransition|Transform|Opacity|Column|Row|Stack|Positioned|IntrinsicHeight|LayoutBuilder|ConstrainedBox|UnconstrainedBox|Center|Wrap|ListView|SingleChildScrollView|Scrollable|Viewport|CustomScrollView|SliverPadding|SliverList|SliverToBoxAdapter|NotificationListener|PrimaryScrollController|ScrollConfiguration|Theme|DefaultTextStyle|IconTheme|MediaQuery|Directionality|Overlay|Navigator|Router|HeroControllerScope|Title|Localizations|AnimatedTheme|Form|WillPopScope|PopScope|Offstage|TickerMode|Visibility|AbsorbPointer|TextFieldTapRegion|TapRegion|DecoratedBoxTransition|ScaleTransition|RotationTransition|SizeTransition|AnimatedSwitcher|AnimatedOpacity|AnimatedSize|Animate|FittedBox|AspectRatio|FractionallySizedBox|LimitedBox|OverflowBox|Dismissible|Draggable|DragTarget|LongPressDraggable|ReorderableListView|PageView|GridView|Table|TableCell|CompositedTransformTarget|CompositedTransformFollower|CustomPaint|ShaderMask|BackdropFilter|ColorFiltered|ImageFiltered|InteractiveViewer|SelectionContainer|SelectionArea|SelectableRegion|TextSelectionGestureDetector|Scaffold|ScaffoldMessenger|AppBar|Drawer|BottomSheet|Dialog|AlertDialog|SimpleDialog|ModalBarrier|SafeArea|Baseline|Spacer|Divider|VerticalDivider|Icon|Text|RichText|Image|RawImage|Placeholder|ErrorWidget|ExcludeSemantics|MergeSemantics|BlockSemantics|IndexedSemantics|Shortcuts|FocusScope|FocusTraversalGroup|DefaultTextEditingShortcuts|RestorationScope|UnmanagedRestorationScope|RootRestorationScope|SharedAppData|Banner|CheckedModeBanner|WidgetsApp|MaterialApp|CupertinoApp|Element|StatefulElement|StatelessElement|SingleChildRenderObjectElement|MultiChildRenderObjectElement|RenderObjectToWidgetAdapter|View|ViewAnchor|LookupBoundary|InheritedModel|InheritedWidget|InheritedTheme|CaptureAll)(-\[.*\])?$').hasMatch(w)).take(6).join(' < ');
          break;
        }
      }
      pendingLocs.add(loc);
      prevOnError(details);
    };
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    tester.view.physicalSize = Size(_sizes.first.width, _sizes.first.height);
    tester.platformDispatcher.textScaleFactorTestValue = _sizes.first.textScale;

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const FrameWorkzApp()));
    // Let the intro overlay play out.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    check(tester, 'boot');

    final settings = container.read(settingsStoreProvider).current;

    for (final s in _sizes) {
      tester.view.physicalSize = Size(s.width, s.height);
      tester.platformDispatcher.textScaleFactorTestValue = s.textScale;
      await settle(tester);
      check(tester, '[${s.name}] resize');

      for (final r in [Routes.dashboard, Routes.leads, Routes.followUps, Routes.calendar, Routes.clients, Routes.projects, Routes.finance, Routes.templates, Routes.settings, Routes.lead(sampleLead.id), Routes.client(sampleClient.id)]) {
        await visit(tester, s.name, r);
      }

      // ---- dialogs reachable with a plain context
      await visit(tester, s.name, Routes.lead(sampleLead.id));
      await openDialog(tester, s.name, 'status change → Call Scheduled', (c) => showStatusChangeDialog(c, sampleLead, LeadStatus.callScheduled));
      await openDialog(tester, s.name, 'status change → Lost', (c) => showStatusChangeDialog(c, sampleLead, LeadStatus.lost));
      await openDialog(tester, s.name, 'compose email', (c) => showComposeEmailDialog(c, to: sampleLead.email, vars: TemplateEngine.leadVars(sampleLead, settings), entityType: EntityType.lead, entityId: sampleLead.id));
      await openDialog(tester, s.name, 'convert to client', (c) => showConvertToClientDialog(c, sampleLead));
      await openDialog(tester, s.name, 'complete follow-up', (c) => completeFollowUpFlow(c, sampleFollowUp));
      await openDialog(tester, s.name, 'record payment', (c) => showRecordPaymentDialog(c, sampleInvoice));
      await openDialog(tester, s.name, 'confirm', (c) => showBzConfirm(c, title: 'Delete lead?', message: 'This permanently removes the lead and its history.', confirmLabel: 'Delete'));

      // ---- dialogs reached through the UI
      await visit(tester, s.name, Routes.leads);
      await tapText(tester, s.name, 'New lead');
      await visit(tester, s.name, Routes.clients);
      await tapText(tester, s.name, 'New client');
      await visit(tester, s.name, Routes.projects);
      await tapText(tester, s.name, 'New project');
      await visit(tester, s.name, Routes.finance);
      await tapText(tester, s.name, 'New invoice');
      await visit(tester, s.name, Routes.followUps);
      await tapText(tester, s.name, 'New follow-up');
      await tapText(tester, s.name, 'Meeting');

      // ---- settings sections and templates editor on phones open as sheets
      if (s.width < 700) {
        await visit(tester, s.name, Routes.settings);
        for (final section in ['Profile', 'Excel workbook', 'Follow-up rules', 'Reminders', 'Google account', 'Google Sheets import', 'Appearance & behaviour', 'About']) {
          await tapText(tester, s.name, section);
        }
        await visit(tester, s.name, Routes.templates);
        await tapText(tester, s.name, 'First touch · Introduction');
        await tapText(tester, s.name, 'More', close: true);
        await tapText(tester, s.name, 'New', close: true);
      } else {
        await visit(tester, s.name, Routes.settings);
        for (final section in ['Excel workbook', 'Follow-up rules', 'Reminders', 'Google account', 'Google Sheets import', 'Appearance & behaviour', 'About']) {
          await tapText(tester, s.name, section, close: false);
        }
        final bell = find.byTooltip('Notifications');
        if (bell.evaluate().isEmpty) {
          failures.add('[${s.name}] missing control "Notifications"');
        } else {
          await tester.tap(bell.first, warnIfMissed: false);
          await settle(tester);
          check(tester, '[${s.name}] tap "Notifications"');
          await closeTop(tester);
          check(tester, '[${s.name}] after closing "Notifications"');
        }
      }
    }

    // Let toasts and other timers expire before the test ends.
    await tester.pump(const Duration(seconds: 15));
    check(tester, 'drain');

    FlutterError.onError = prevOnError;
    if (failures.isNotEmpty) {
      fail('Layout problems found:\n  ${failures.join('\n  ')}');
    }
  });
}
