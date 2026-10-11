import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../ui/widgets/bz_toast.dart';
import 'intro_overlay.dart';
import 'router.dart';
import 'theme/bz_theme.dart';

class FrameWorkzApp extends ConsumerWidget {
  const FrameWorkzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'FrameWorkz',
      debugShowCheckedModeBanner: false,
      theme: BzTheme.light(),
      darkTheme: BzTheme.dark(),
      themeMode: mode,
      routerConfig: appRouter,
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: true),
      builder: (context, child) => BzToastHost(
        child: Stack(
          children: [
            child ?? const SizedBox(),
            const IntroOverlay(),
          ],
        ),
      ),
    );
  }
}
