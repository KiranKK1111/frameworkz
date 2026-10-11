import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'theme/bz_colors.dart';

/// Branded intro shown over the app on launch: the logo springs in, a light
/// sweep crosses it, the word mark types itself in letter by letter, then the
/// whole overlay dissolves to reveal the dashboard. ~2.5 s total.
class IntroOverlay extends StatefulWidget {
  const IntroOverlay({super.key, this.duration = const Duration(milliseconds: 2500)});
  final Duration duration;

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> {
  bool _leaving = false;
  bool _done = false;
  Timer? _t1;
  Timer? _t2;

  @override
  void initState() {
    super.initState();
    _t1 = Timer(widget.duration, () {
      if (!mounted) return;
      setState(() => _leaving = true);
      _t2 = Timer(const Duration(milliseconds: 550), () {
        if (mounted) setState(() => _done = true);
      });
    });
  }

  @override
  void dispose() {
    _t1?.cancel();
    _t2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return const SizedBox.shrink();
    const word = 'FrameWorkz';
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 700;
    final logoSize = compact ? 96.0 : 120.0;

    final content = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B1220), Color(0xFF0D2B6B), Color(0xFF3A1D9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Soft ambient blobs.
          Positioned(
            left: -size.width * 0.2,
            top: -size.height * 0.15,
            child: _Blob(color: BzColors.primary.withValues(alpha: 0.35), size: size.width * 0.6)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 2600.ms, curve: Curves.easeInOut),
          ),
          Positioned(
            right: -size.width * 0.15,
            bottom: -size.height * 0.2,
            child: _Blob(color: BzColors.buzz.withValues(alpha: 0.22), size: size.width * 0.5)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.1, end: 0.9, duration: 3000.ms, curve: Curves.easeInOut),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo tile
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(logoSize * 0.28),
                        gradient: const LinearGradient(colors: [Color(0xFF0D6EFD), Color(0xFF3D8BFD)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        boxShadow: [BoxShadow(color: BzColors.primary.withValues(alpha: 0.55), blurRadius: 40, offset: const Offset(0, 16))],
                      ),
                      alignment: Alignment.center,
                      child: Text('F', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: logoSize * 0.56, height: 1, fontFamily: 'Inter')),
                    )
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .scale(begin: const Offset(0.4, 0.4), end: const Offset(1, 1), duration: 750.ms, curve: Curves.easeOutBack)
                        .then(delay: 150.ms)
                        .shimmer(duration: 1100.ms, color: Colors.white.withValues(alpha: 0.55), angle: 0.6),
                    // Amber "buzz" dot
                    Positioned(
                      right: logoSize * 0.14,
                      top: logoSize * 0.14,
                      child: Container(
                        width: logoSize * 0.17,
                        height: logoSize * 0.17,
                        decoration: BoxDecoration(color: BzColors.buzz, shape: BoxShape.circle, boxShadow: [BoxShadow(color: BzColors.buzz.withValues(alpha: 0.8), blurRadius: 16)]),
                      )
                          .animate(delay: 600.ms)
                          .scale(begin: Offset.zero, end: const Offset(1, 1), duration: 400.ms, curve: Curves.elasticOut)
                          .then()
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scaleXY(begin: 1, end: 1.25, duration: 900.ms, curve: Curves.easeInOut),
                    ),
                  ],
                ),
                SizedBox(height: compact ? 26 : 34),
                // Word mark, letter by letter
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < word.length; i++)
                      Text(
                        word[i],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 36 : 46,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          fontFamily: 'Inter',
                        ),
                      ).animate(delay: (750 + i * 55).ms).fadeIn(duration: 260.ms).slideY(begin: 0.6, end: 0, duration: 420.ms, curve: Curves.easeOutCubic),
                  ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'BUSINESS OS FOR CREATIVE STUDIOS',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: compact ? 11 : 12.5, letterSpacing: 3, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                ).animate(delay: 1400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                SizedBox(height: compact ? 40 : 52),
                // Loading bar
                Container(
                  width: 160,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(2)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(colors: [BzColors.buzz, Color(0xFF6EDFF6)]),
                      ),
                    ).animate(delay: 500.ms).custom(
                          duration: 1900.ms,
                          curve: Curves.easeInOutCubic,
                          builder: (context, v, child) => FractionallySizedBox(widthFactor: v, child: child),
                        ),
                  ),
                ).animate(delay: 450.ms).fadeIn(duration: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );

    return IgnorePointer(
      ignoring: _leaving,
      child: content
          .animate(target: _leaving ? 1 : 0)
          .fadeOut(duration: 500.ms, curve: Curves.easeInOut)
          .scaleXY(begin: 1, end: 1.06, duration: 550.ms, curve: Curves.easeInCubic),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      );
}
