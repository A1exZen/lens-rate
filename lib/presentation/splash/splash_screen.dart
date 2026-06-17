import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

/// Animated launch screen (docs §15). Theme-aware: uses colorScheme so it
/// looks correct in both light and dark mode. Shows animated title only —
/// no icon (avoids background artefacts). Navigates to converter after 1.8s.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  // "LensRate": scale up + fade in.
  late final Animation<double> _titleScale = Tween(begin: 0.88, end: 1.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ),
  );
  late final Animation<double> _titleFade = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    ),
  );

  // Tagline slides up + fades in after title settles.
  late final Animation<double> _tagSlide = Tween(begin: 14.0, end: 0.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
    ),
  );
  late final Animation<double> _tagFade = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
    ),
  );

  // Glow behind title grows in.
  late final Animation<double> _glowFade = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ),
  );

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 1800), _finish);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _finish() {
    if (!mounted) return;
    context.go('/converter');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glowColor = isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final bgColor = scheme.surface;

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Radial brand glow centred on the title.
              Positioned.fill(
                child: Opacity(
                  opacity: _glowFade.value * (isDark ? 0.28 : 0.55),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.65,
                        colors: [glowColor, bgColor],
                      ),
                    ),
                  ),
                ),
              ),

              // Title + tagline.
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "Lens" (brand green) + "Rate" (onSurface).
                    Opacity(
                      opacity: _titleFade.value,
                      child: Transform.scale(
                        scale: _titleScale.value,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.0,
                              height: 1.1,
                              color: scheme.onSurface,
                            ),
                            children: [
                              TextSpan(
                                text: 'Lens',
                                style: TextStyle(color: scheme.primary),
                              ),
                              const TextSpan(text: 'Rate'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline.
                    Opacity(
                      opacity: _tagFade.value,
                      child: Transform.translate(
                        offset: Offset(0, _tagSlide.value),
                        child: Text(
                          'AR Currency Converter',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: scheme.onSurface.withValues(alpha: 0.45),
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Pulsing brand dot at bottom.
              Positioned(
                bottom: 52,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _tagFade.value,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_PulseDot()],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Opacity(
        opacity: 0.35 + 0.65 * _c.value,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
