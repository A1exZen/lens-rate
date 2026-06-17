import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/camera/camera_screen.dart';
import '../../presentation/converter/converter_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/splash/splash_screen.dart';

/// Declarative routing (docs §6.1). Splash is the entry point; Converter is
/// the home screen after that. Camera and Settings are full-screen pushed routes.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        // No transition into the splash itself (it's the first screen).
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/converter',
        // Fade in from splash — smooth handoff with no slide.
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ConverterScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
