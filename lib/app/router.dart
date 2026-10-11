import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/calendar_page.dart';
import '../features/clients/client_detail_page.dart';
import '../features/clients/clients_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/email/templates_page.dart';
import '../features/finance/finance_page.dart';
import '../features/followups/followups_page.dart';
import '../features/leads/lead_detail_page.dart';
import '../features/leads/leads_page.dart';
import '../features/projects/projects_page.dart';
import '../features/settings/settings_page.dart';
import 'shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

class Routes {
  Routes._();
  static const dashboard = '/dashboard';
  static const leads = '/leads';
  static const followUps = '/follow-ups';
  static const calendar = '/calendar';
  static const clients = '/clients';
  static const projects = '/projects';
  static const finance = '/finance';
  static const templates = '/templates';
  static const settings = '/settings';

  static String lead(String id) => '/leads/$id';
  static String client(String id) => '/clients/$id';
}

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.015), end: Offset.zero).animate(curved), child: child),
        );
      },
    );

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.dashboard,
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: Routes.dashboard, pageBuilder: (c, s) => _fade(s, const DashboardPage())),
        GoRoute(
          path: Routes.leads,
          pageBuilder: (c, s) => _fade(s, const LeadsPage()),
          routes: [
            GoRoute(path: ':id', pageBuilder: (c, s) => _fade(s, LeadDetailPage(leadId: s.pathParameters['id']!))),
          ],
        ),
        GoRoute(path: Routes.followUps, pageBuilder: (c, s) => _fade(s, const FollowUpsPage())),
        GoRoute(path: Routes.calendar, pageBuilder: (c, s) => _fade(s, const CalendarPage())),
        GoRoute(
          path: Routes.clients,
          pageBuilder: (c, s) => _fade(s, const ClientsPage()),
          routes: [
            GoRoute(path: ':id', pageBuilder: (c, s) => _fade(s, ClientDetailPage(clientId: s.pathParameters['id']!))),
          ],
        ),
        GoRoute(path: Routes.projects, pageBuilder: (c, s) => _fade(s, const ProjectsPage())),
        GoRoute(path: Routes.finance, pageBuilder: (c, s) => _fade(s, const FinancePage())),
        GoRoute(path: Routes.templates, pageBuilder: (c, s) => _fade(s, const TemplatesPage())),
        GoRoute(path: Routes.settings, pageBuilder: (c, s) => _fade(s, const SettingsPage())),
      ],
    ),
  ],
);
