import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../core/utils/format.dart';
import '../features/clients/client_form_dialog.dart';
import '../features/finance/invoice_form_dialog.dart';
import '../features/followups/followup_form_dialog.dart';
import '../features/leads/lead_form_dialog.dart';
import '../features/projects/project_form_dialog.dart';
import '../ui/widgets/bz_badge.dart';
import '../ui/widgets/bz_button.dart';
import '../ui/widgets/bz_misc.dart';
import '../ui/widgets/bz_modal.dart';
import 'responsive.dart';
import 'router.dart';
import 'theme/bz_colors.dart';
import 'theme/bz_theme.dart';

class _NavItem {
  const _NavItem(this.label, this.icon, this.activeIcon, this.route);
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}

const _navItems = [
  _NavItem(
    'Dashboard',
    BootstrapIcons.speedometer2,
    BootstrapIcons.speedometer2,
    Routes.dashboard,
  ),
  _NavItem(
    'Leads',
    BootstrapIcons.funnel,
    BootstrapIcons.funnel_fill,
    Routes.leads,
  ),
  _NavItem(
    'Follow-ups',
    BootstrapIcons.bell,
    BootstrapIcons.bell_fill,
    Routes.followUps,
  ),
  _NavItem(
    'Calendar',
    BootstrapIcons.calendar3,
    BootstrapIcons.calendar_week,
    Routes.calendar,
  ),
  _NavItem(
    'Clients',
    BootstrapIcons.people,
    BootstrapIcons.people_fill,
    Routes.clients,
  ),
  _NavItem(
    'Projects',
    BootstrapIcons.camera_reels,
    BootstrapIcons.camera_reels,
    Routes.projects,
  ),
  _NavItem(
    'Finance',
    BootstrapIcons.wallet2,
    BootstrapIcons.wallet2,
    Routes.finance,
  ),
  _NavItem(
    'Email templates',
    BootstrapIcons.envelope_paper,
    BootstrapIcons.envelope_paper,
    Routes.templates,
  ),
];

const _settingsItem = _NavItem(
  'Settings',
  BootstrapIcons.gear,
  BootstrapIcons.gear_fill,
  Routes.settings,
);

String _pageTitle(String location) => [..._navItems, _settingsItem]
    .firstWhere(
      (n) => location.startsWith(n.route),
      orElse: () => _navItems.first,
    )
    .label;

/// Application frame.
///
/// * Desktop (≥ 1100 dp): collapsible sidebar + top bar.
/// * Tablet (700–1100 dp): sidebar forced to icon rail.
/// * Phone (< 700 dp): top app bar + bottom navigation + floating "New".
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isPhone) return _MobileShell(child: child);
    final collapsed =
        context.isTablet ||
        ref.watch(settingsSnapshotProvider).sidebarCollapsed;
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(collapsed: collapsed, lockCollapsed: context.isTablet),
          Expanded(
            child: Column(
              children: [
                const _TopBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================ mobile shell
class _MobileShell extends ConsumerWidget {
  const _MobileShell({required this.child});
  final Widget child;

  static const _tabs = [
    Routes.dashboard,
    Routes.leads,
    Routes.followUps,
    Routes.calendar,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;
    final counts = ref.watch(agendaCountsProvider);
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    final settings = ref.watch(settingsSnapshotProvider);
    var index = _tabs.indexWhere(
      (t) => location == t || (t != Routes.dashboard && location.startsWith(t)),
    );
    if (index == -1) index = 4;
    final isDashboard = location == Routes.dashboard;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 58,
        titleSpacing: 16,
        title: isDashboard
            ? Row(
                children: [
                  _Logo(size: 32),
                  const SizedBox(width: 10),
                  Text(
                    'FrameWorkz',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              )
            : Text(
                _pageTitle(location),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
        actions: [
          BzIconButton(
            icon: BootstrapIcons.search,
            tooltip: 'Search',
            size: 40,
            iconSize: 17,
            onPressed: () => _openSearch(context),
          ),
          BzIconButton(
            icon: unread > 0 ? BootstrapIcons.bell_fill : BootstrapIcons.bell,
            tooltip: 'Notifications',
            size: 40,
            iconSize: 17,
            badgeCount: unread,
            variant: unread > 0 ? BzVariant.primary : BzVariant.secondary,
            onPressed: () => showBzSideSheet(
              context: context,
              child: const _NotificationsPanel(),
            ),
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => context.go(Routes.settings),
              child: BzAvatar(
                settings.myName.isEmpty
                    ? settings.businessName
                    : settings.myName,
                size: 32,
                radius: 999,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.colorScheme.outline),
        ),
      ),
      body: child,
      floatingActionButton:
          FloatingActionButton.extended(
            onPressed: () => _openNewSheet(context, ref),
            backgroundColor: BzColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(BootstrapIcons.plus_lg, size: 16),
            label: const Text(
              'New',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 300.ms,
            curve: Curves.easeOutBack,
          ),
      bottomNavigationBar: NavigationBar(
        height: 66,
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: BzColors.primary.withValues(alpha: 0.14),
        onDestinationSelected: (i) {
          if (i < _tabs.length) {
            context.go(_tabs[i]);
          } else {
            _openMoreSheet(context);
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(BootstrapIcons.house_door, size: 20),
            selectedIcon: Icon(
              BootstrapIcons.house_door,
              size: 20,
              color: BzColors.primary,
            ),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(BootstrapIcons.funnel, size: 20),
            selectedIcon: Icon(
              BootstrapIcons.funnel_fill,
              size: 20,
              color: BzColors.primary,
            ),
            label: 'Leads',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: counts.attention > 0,
              label: Text('${counts.attention}'),
              backgroundColor: counts.overdue > 0
                  ? BzColors.danger
                  : BzColors.warning,
              textColor: counts.overdue > 0 ? Colors.white : BzColors.gray900,
              child: const Icon(BootstrapIcons.bell, size: 20),
            ),
            selectedIcon: const Icon(
              BootstrapIcons.bell_fill,
              size: 20,
              color: BzColors.primary,
            ),
            label: 'Follow-ups',
          ),
          const NavigationDestination(
            icon: Icon(BootstrapIcons.calendar3, size: 20),
            selectedIcon: Icon(
              BootstrapIcons.calendar_week,
              size: 20,
              color: BzColors.primary,
            ),
            label: 'Calendar',
          ),
          const NavigationDestination(
            icon: Icon(BootstrapIcons.grid, size: 20),
            selectedIcon: Icon(
              BootstrapIcons.grid_fill,
              size: 20,
              color: BzColors.primary,
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }

  void _openSearch(BuildContext context) {
    showBzModal(
      context: context,
      title: 'Search',
      icon: BootstrapIcons.search,
      width: 620,
      bodyPadding: const EdgeInsets.all(16),
      fullscreenOnPhone: true,
      child: const _GlobalSearch(),
    );
  }

  void _openMoreSheet(BuildContext context) {
    final theme = Theme.of(context);
    final google = ProviderScope.containerOf(context)
        .read(googleAuthProvider)
        .state
        .value;
    showBzModal(
      context: context,
      title: 'More',
      icon: BootstrapIcons.grid,
      bodyPadding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in [..._navItems.sublist(4), _settingsItem])
            BzHoverRow(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              onTap: () {
                Navigator.of(context).pop();
                context.go(item.route);
              },
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: BzColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: Icon(item.icon, size: 17, color: BzColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    BootstrapIcons.chevron_right,
                    size: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          const Divider(height: 16),
          BzHoverRow(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            onTap: () {
              Navigator.of(context).pop();
              context.go(Routes.settings);
            },
            child: Row(
              children: [
                Icon(
                  BootstrapIcons.google,
                  size: 16,
                  color: google.connected
                      ? BzColors.success
                      : BzColors.warningEmphasis,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    google.connected
                        ? (google.email ?? 'Google connected')
                        : 'Connect Google',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const _ThemeToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openNewSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Widget item(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
    ) => BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: BzColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 17, color: BzColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
    showBzModal(
      context: context,
      title: 'Create new',
      icon: BootstrapIcons.plus_lg,
      bodyPadding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          item(
            BootstrapIcons.person_plus,
            'Lead',
            'Capture a new enquiry',
            () => showLeadFormDialog(context, ref),
          ),
          item(
            BootstrapIcons.bell,
            'Follow-up or meeting',
            'Schedule a reminder',
            () => showFollowUpFormDialog(context, ref),
          ),
          item(
            BootstrapIcons.people,
            'Client',
            'Add a client directly',
            () => showClientFormDialog(context, ref),
          ),
          item(
            BootstrapIcons.camera_reels,
            'Project',
            'Shoot, edit or retainer work',
            () => showProjectFormDialog(context, ref),
          ),
          item(
            BootstrapIcons.receipt,
            'Invoice',
            'Bill a client',
            () => showInvoiceFormDialog(context, ref),
          ),
        ],
      ),
    );
  }
}

// ================================================================ sidebar
class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.collapsed, this.lockCollapsed = false});
  final bool collapsed;
  final bool lockCollapsed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;
    final counts = ref.watch(agendaCountsProvider);
    final google =
        ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    final width = collapsed ? 72.0 : 236.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              collapsed ? 14 : 18,
              18,
              collapsed ? 14 : 12,
              14,
            ),
            child: Row(
              children: [
                _Logo(size: 38),
                if (!collapsed) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FrameWorkz',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Business OS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                for (final item in _navItems)
                  _NavTile(
                    item: item,
                    collapsed: collapsed,
                    active:
                        location == item.route ||
                        (item.route != Routes.dashboard &&
                            location.startsWith(item.route)),
                    badge: item.route == Routes.followUps
                        ? counts.attention
                        : null,
                    badgeVariant: counts.overdue > 0
                        ? BzVariant.danger
                        : BzVariant.warning,
                    onTap: () => context.go(item.route),
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NavTile(
                  item: _settingsItem,
                  collapsed: collapsed,
                  active: location.startsWith(Routes.settings),
                  onTap: () => context.go(Routes.settings),
                ),
                const SizedBox(height: 6),
                Tooltip(
                  message: google.connected
                      ? 'Google connected${google.email != null ? ' as ${google.email}' : ''}'
                      : 'Connect Google for Calendar + Gmail',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(BzTheme.radius),
                    onTap: () => context.go(Routes.settings),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: collapsed ? 0 : 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (google.connected
                                    ? BzColors.success
                                    : BzColors.warning)
                                .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(BzTheme.radius),
                      ),
                      child: Row(
                        mainAxisAlignment: collapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            BootstrapIcons.google,
                            size: 14,
                            color: google.connected
                                ? BzColors.success
                                : BzColors.warningEmphasis,
                          ),
                          if (!collapsed) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                google.connected
                                    ? (google.email ?? 'Google connected')
                                    : 'Connect Google',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: collapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!collapsed) const _ThemeToggle(),
                    if (!lockCollapsed)
                      BzIconButton(
                        icon: collapsed
                            ? BootstrapIcons.chevron_right
                            : BootstrapIcons.chevron_left,
                        tooltip: collapsed
                            ? 'Expand sidebar'
                            : 'Collapse sidebar',
                        iconSize: 13,
                        onPressed: () => ref.setSetting(
                          Keys.sidebarCollapsed,
                          (!collapsed).toString(),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D6EFD), Color(0xFF3D8BFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: BzColors.primary.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'F',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: size * 0.55,
              height: 1,
            ),
          ),
          Positioned(
            right: size * 0.16,
            top: size * 0.16,
            child: Container(
              width: size * 0.18,
              height: size * 0.18,
              decoration: const BoxDecoration(
                color: BzColors.buzz,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.collapsed,
    required this.active,
    required this.onTap,
    this.badge,
    this.badgeVariant = BzVariant.danger,
  });
  final _NavItem item;
  final bool collapsed;
  final bool active;
  final VoidCallback onTap;
  final int? badge;
  final BzVariant badgeVariant;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = widget.active;
    final fg = active
        ? BzColors.primary
        : (_hover
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurfaceVariant);
    final tile = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 3),
          padding: EdgeInsets.symmetric(
            horizontal: widget.collapsed ? 0 : 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: active
                ? BzColors.primary.withValues(alpha: 0.10)
                : (_hover
                      ? theme.colorScheme.surfaceContainerHigh
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(BzTheme.radius),
          ),
          // ClipRect: during the collapse/expand animation the row is briefly
          // narrower than its content.
          child: ClipRect(
            child: Row(
              mainAxisAlignment: widget.collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      active ? widget.item.activeIcon : widget.item.icon,
                      size: 17,
                      color: fg,
                    ),
                    if (widget.collapsed && (widget.badge ?? 0) > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: widget.badgeVariant.color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (!widget.collapsed) ...[
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      widget.item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: fg,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if ((widget.badge ?? 0) > 0)
                    BzBadge(
                      '${widget.badge}',
                      variant: widget.badgeVariant,
                      soft: false,
                      fontSize: 10.5,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return widget.collapsed
        ? Tooltip(message: widget.item.label, child: tile)
        : tile;
  }
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(settingsSnapshotProvider).themeMode;
    final theme = Theme.of(context);
    Widget btn(String value, IconData icon, String tip) {
      final active = mode == value;
      return Tooltip(
        message: tip,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => ref.setSetting(Keys.themeMode, value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 30,
            height: 26,
            decoration: BoxDecoration(
              color: active ? theme.colorScheme.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              boxShadow: active ? BzShadows.sm(context) : null,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 13,
              color: active
                  ? BzColors.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn('light', BootstrapIcons.sun, 'Light'),
          btn('dark', BootstrapIcons.moon_stars, 'Dark'),
          btn('system', BootstrapIcons.circle_half, 'System'),
        ],
      ),
    );
  }
}

// ================================================================= topbar
class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    final settings = ref.watch(settingsSnapshotProvider);
    final location = GoRouterState.of(context).uri.path;
    final compact = context.isTablet;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        children: [
          Text(
            _pageTitle(location),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(child: SizedBox()),
          _GlobalSearchButton(compact: compact),
          const SizedBox(width: 10),
          _NewMenu(compact: compact),
          const SizedBox(width: 10),
          BzIconButton(
            icon: unread > 0 ? BootstrapIcons.bell_fill : BootstrapIcons.bell,
            tooltip: 'Notifications',
            badgeCount: unread,
            variant: unread > 0 ? BzVariant.primary : BzVariant.secondary,
            onPressed: () => showBzSideSheet(
              context: context,
              width: 440,
              child: const _NotificationsPanel(),
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: settings.myName.isEmpty
                ? 'Set up your profile'
                : settings.myName,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => context.go(Routes.settings),
              child: BzAvatar(
                settings.myName.isEmpty
                    ? settings.businessName
                    : settings.myName,
                size: 34,
                radius: 999,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalSearchButton extends StatelessWidget {
  const _GlobalSearchButton({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void open() => showBzModal(
      context: context,
      title: 'Search',
      icon: BootstrapIcons.search,
      width: 620,
      bodyPadding: const EdgeInsets.all(16),
      child: const _GlobalSearch(),
    );
    if (compact) {
      return BzIconButton(
        icon: BootstrapIcons.search,
        tooltip: 'Search (Ctrl K)',
        onPressed: open,
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(BzTheme.radius),
      onTap: open,
      child: Container(
        width: 330,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(BzTheme.radius),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(
              BootstrapIcons.search,
              size: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search leads, clients, projects…',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Text(
                'Ctrl K',
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobalSearch extends ConsumerStatefulWidget {
  const _GlobalSearch();
  @override
  ConsumerState<_GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends ConsumerState<_GlobalSearch> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leads = ref.watch(leadsProvider).value ?? const [];
    final clients = ref.watch(clientsProvider).value ?? const [];
    final projects = ref.watch(projectsProvider).value ?? const [];
    final q = _q.trim().toLowerCase();

    bool m(String s) => s.toLowerCase().contains(q);
    final leadHits = q.isEmpty
        ? <Lead>[]
        : leads
              .where(
                (l) =>
                    m(l.business) ||
                    m(l.contactPerson) ||
                    m(l.email) ||
                    m(l.phone) ||
                    m(l.id),
              )
              .take(6)
              .toList();
    final clientHits = q.isEmpty
        ? <Client>[]
        : clients
              .where(
                (c) => m(c.name) || m(c.contactPerson) || m(c.email) || m(c.id),
              )
              .take(5)
              .toList();
    final projectHits = q.isEmpty
        ? <Project>[]
        : projects.where((p) => m(p.name) || m(p.id)).take(4).toList();

    Widget section(String label) => Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          onChanged: (v) => setState(() => _q = v),
          decoration: const InputDecoration(
            hintText: 'Business, person, email, phone or ID…',
            prefixIcon: Icon(BootstrapIcons.search, size: 15),
          ),
        ),
        const SizedBox(height: 10),
        if (q.isEmpty)
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              'Start typing to search across leads, clients and projects.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          )
        else if (leadHits.isEmpty && clientHits.isEmpty && projectHits.isEmpty)
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              'No matches for "$_q"',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          )
        else ...[
          if (leadHits.isNotEmpty) ...[
            section('LEADS'),
            for (final l in leadHits)
              BzHoverRow(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(Routes.lead(l.id));
                },
                child: Row(
                  children: [
                    BzAvatar(l.business, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.business,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${l.contactPerson} · ${l.id}',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    LeadStatusBadge(l.status),
                  ],
                ),
              ),
          ],
          if (clientHits.isNotEmpty) ...[
            section('CLIENTS'),
            for (final c in clientHits)
              BzHoverRow(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(Routes.client(c.id));
                },
                child: Row(
                  children: [
                    BzAvatar(c.name, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${c.contactPerson} · ${c.id}',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ClientStatusBadge(c.status),
                  ],
                ),
              ),
          ],
          if (projectHits.isNotEmpty) ...[
            section('PROJECTS'),
            for (final p in projectHits)
              BzHoverRow(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(Routes.projects);
                },
                child: Row(
                  children: [
                    const Icon(BootstrapIcons.camera_reels, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        p.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ProjectStatusBadge(p.status),
                  ],
                ),
              ),
          ],
        ],
      ],
    );
  }
}

class _NewMenu extends ConsumerWidget {
  const _NewMenu({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, 6),
      builder: (context, controller, _) => compact
          ? BzIconButton(
              icon: BootstrapIcons.plus_lg,
              tooltip: 'New',
              variant: BzVariant.primary,
              filled: true,
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            )
          : BzButton(
              label: 'New',
              icon: BootstrapIcons.plus_lg,
              trailingIcon: BootstrapIcons.chevron_down,
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
      menuChildren: [
        _menuItem(
          context,
          BootstrapIcons.person_plus,
          'Lead',
          'Capture a new enquiry',
          () => showLeadFormDialog(context, ref),
        ),
        _menuItem(
          context,
          BootstrapIcons.bell,
          'Follow-up or meeting',
          'Schedule a reminder',
          () => showFollowUpFormDialog(context, ref),
        ),
        _menuItem(
          context,
          BootstrapIcons.people,
          'Client',
          'Add a client directly',
          () => showClientFormDialog(context, ref),
        ),
        _menuItem(
          context,
          BootstrapIcons.camera_reels,
          'Project',
          'Shoot, edit or retainer work',
          () => showProjectFormDialog(context, ref),
        ),
        _menuItem(
          context,
          BootstrapIcons.receipt,
          'Invoice',
          'Bill a client',
          () => showInvoiceFormDialog(context, ref),
        ),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return MenuItemButton(
      onPressed: onTap,
      child: SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, size: 15, color: BzColors.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================================== notifications
class _NotificationsPanel extends ConsumerStatefulWidget {
  const _NotificationsPanel();
  @override
  ConsumerState<_NotificationsPanel> createState() =>
      _NotificationsPanelState();
}

class _NotificationsPanelState extends ConsumerState<_NotificationsPanel> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) ref.read(databaseProvider).markAllNotificationsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = ref.watch(notificationsProvider).value ?? const [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
          child: Row(
            children: [
              const Icon(
                BootstrapIcons.bell_fill,
                size: 16,
                color: BzColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Notifications',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (items.isNotEmpty)
                BzButton(
                  label: 'Clear all',
                  size: BzSize.sm,
                  variant: BzVariant.light,
                  onPressed: () =>
                      ref.read(databaseProvider).clearNotifications(),
                ),
              const SizedBox(width: 6),
              BzIconButton(
                icon: BootstrapIcons.x_lg,
                tooltip: 'Close',
                iconSize: 14,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: items.isEmpty
              ? const BzEmptyState(
                  icon: BootstrapIcons.bell_slash,
                  title: 'All quiet',
                  message: 'Reminders for follow-ups, meetings and overdue invoices will show up here.',
                  compact: true,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, i) {
                    final n = items[i];
                    final v = switch (n.kind) {
                      NotificationKind.followUpOverdue ||
                      NotificationKind.invoiceOverdue ||
                      NotificationKind.error => BzVariant.danger,
                      NotificationKind.followUpDue ||
                      NotificationKind.warning => BzVariant.warning,
                      NotificationKind.meeting => BzVariant.primary,
                      NotificationKind.success => BzVariant.success,
                      _ => BzVariant.info,
                    };
                    final icon = switch (n.kind) {
                      NotificationKind.meeting => BootstrapIcons.camera_video,
                      NotificationKind.invoiceOverdue => BootstrapIcons.receipt,
                      NotificationKind.success =>
                        BootstrapIcons.check_circle_fill,
                      NotificationKind.followUpOverdue =>
                        BootstrapIcons.exclamation_circle,
                      _ => BootstrapIcons.bell_fill,
                    };
                    return BzHoverRow(
                          onTap: () {
                            Navigator.of(context).pop();
                            _open(context, n);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: v.subtle(theme.brightness),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  icon,
                                  size: 15,
                                  color: v.emphasis(theme.brightness),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            n.title,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: n.readAt == null
                                                      ? FontWeight.w700
                                                      : FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        if (n.readAt == null)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: BzColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (n.body.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        n.body,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                    const SizedBox(height: 3),
                                    Text(
                                      Fmt.timeAgo(n.createdAt),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate(delay: (i * 30).ms)
                        .fadeIn(duration: 200.ms)
                        .slideX(begin: 0.05, end: 0);
                  },
                ),
        ),
      ],
    );
  }

  void _open(BuildContext context, AppNotification n) {
    switch (n.entityType) {
      case EntityType.lead:
        context.go(
          n.entityId != null ? Routes.lead(n.entityId!) : Routes.leads,
        );
      case EntityType.client:
        if (n.entityId != null) context.go(Routes.client(n.entityId!));
      case EntityType.invoice:
        context.go(Routes.finance);
      case EntityType.project:
        context.go(Routes.projects);
      case EntityType.followUp:
      case null:
        context.go(Routes.followUps);
    }
  }
}
