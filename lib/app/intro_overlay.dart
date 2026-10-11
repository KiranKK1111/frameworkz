import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'theme/bz_colors.dart';

/// Branded intro shown over the app on launch: the logo tile springs in and
/// keeps gently moving (a slow 3-D tilt, an orbiting amber spark and a light
/// sweep), the word mark rises letter by letter, then the whole overlay
/// dissolves to reveal the dashboard. ~2.6 s total.
class IntroOverlay extends StatefulWidget {
  const IntroOverlay({super.key, this.duration = const Duration(milliseconds: 2600)});
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
    final logoSize = compact ? 104.0 : 128.0;

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
                AnimatedLogo(size: logoSize),
                SizedBox(height: compact ? 30 : 38),
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
                            fontSize: compact ? 38 : 48,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            height: 1.1,
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.none,
                          ),
                        ).animate(delay: (750 + i * 55).ms).fadeIn(duration: 260.ms).slideY(begin: 0.6, end: 0, duration: 420.ms, curve: Curves.easeOutCubic),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Business OS for creative studios',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: compact ? 13.5 : 15,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.none,
                  ),
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
                          duration: 2000.ms,
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

    // Material + DefaultTextStyle: the overlay sits above the app's Navigator,
    // so without them text would get the framework's fallback styling.
    return IgnorePointer(
      ignoring: _leaving,
      child: Material(
        type: MaterialType.transparency,
        child: DefaultTextStyle(
          style: const TextStyle(fontFamily: 'Inter', color: Colors.white, decoration: TextDecoration.none),
          child: content
              .animate(target: _leaving ? 1 : 0)
              .fadeOut(duration: 500.ms, curve: Curves.easeInOut)
              .scaleXY(begin: 1, end: 1.06, duration: 550.ms, curve: Curves.easeInCubic),
        ),
      ),
    );
  }
}

/// The FrameWorkz mark in motion: the tile springs in, then keeps a slow 3-D
/// tilt while an amber spark orbits it and a light sweep crosses the face.
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key, this.size = 120});
  final double size;

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final r = s * 0.28;
    final tile = AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value * 2 * math.pi;
        // Gentle figure-eight tilt.
        final tiltX = math.sin(t) * 0.16;
        final tiltY = math.cos(t * 0.5) * 0.22;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(tiltX)
            ..rotateY(tiltY),
          child: child,
        );
      },
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          gradient: const LinearGradient(colors: [Color(0xFF0D6EFD), Color(0xFF4D96FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: BzColors.primary.withValues(alpha: 0.55), blurRadius: 44, offset: const Offset(0, 18))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(r),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glossy highlight on the upper half.
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: s * 0.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.18), Colors.white.withValues(alpha: 0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
              ),
              Text(
                'F',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: s * 0.58, height: 1, fontFamily: 'Poppins', decoration: TextDecoration.none),
              ),
              // Light sweep that keeps crossing the face.
              Positioned.fill(
                child: const _Sweep().animate(onPlay: (c) => c.repeat()).custom(
                      duration: 2400.ms,
                      builder: (context, v, child) => FractionalTranslation(translation: Offset(-1.2 + v * 2.4, 0), child: child),
                    ),
              ),
            ],
          ),
        ),
      ),
    );

    // Orbiting amber spark. Two copies: one painted under the tile (visible
    // on the far side of the orbit) and one above it (near side).
    Widget spark({required bool frontLayer}) => AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final a = _c.value * 2 * math.pi;
            final rx = s * 0.6, ry = s * 0.34;
            final dx = math.cos(a) * rx;
            final dy = math.sin(a) * ry;
            final front = math.sin(a) >= 0; // lower half of the ellipse passes in front
            if (front != frontLayer) return const SizedBox.shrink();
            final scale = front ? 1.0 : 0.78;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: s * 0.16,
                  height: s * 0.16,
                  decoration: BoxDecoration(
                    color: BzColors.buzz,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: BzColors.buzz.withValues(alpha: 0.85), blurRadius: 18, spreadRadius: 1)],
                  ),
                ),
              ),
            );
          },
        );

    return SizedBox(
      width: s * 1.5,
      height: s * 1.4,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          spark(frontLayer: false).animate(delay: 500.ms).fadeIn(duration: 400.ms),
          tile
              .animate()
              .fadeIn(duration: 350.ms)
              .scale(begin: const Offset(0.4, 0.4), end: const Offset(1, 1), duration: 750.ms, curve: Curves.easeOutBack),
          spark(frontLayer: true).animate(delay: 500.ms).fadeIn(duration: 400.ms).scale(begin: Offset.zero, end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
}

class _Sweep extends StatelessWidget {
  const _Sweep();
  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: -0.5,
        child: FractionallySizedBox(
          widthFactor: 0.45,
          heightFactor: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0), Colors.white.withValues(alpha: 0.42), Colors.white.withValues(alpha: 0)]),
            ),
          ),
        ),
      );
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
