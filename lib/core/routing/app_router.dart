import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/document_viewer/document_viewer_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/billing/paywall_screen.dart';
import '../../domain/entities/document.dart';

/// App routing configuration using GoRouter
class AppRouter {
  static const String onboarding = '/onboarding';
  static const String library = '/library';
  static const String documentViewer = '/document/:id';
  static const String settings = '/settings';
  static const String paywall = '/paywall';
  static const String aiChat = '/document/:id/chat';

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: library,
        name: 'library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/document/:id',
        name: 'document_viewer',
        builder: (context, state) {
          final docId = state.pathParameters['id']!;
          final doc = state.extra as Document?;
          return DocumentViewerScreen(
            documentId: docId,
            document: doc,
          );
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: paywall,
        name: 'paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
    ],
  );
}
