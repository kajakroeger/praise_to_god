// lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login.dart';
import '../screens/dashboard.dart';
import 'auth_state_notifier.dart';

final authStateNotifier = AuthStateNotifier();

final GoRouter appRouter = GoRouter(
  // Beobachtet den Auth-Zustand und baut Router neu bei Änderung
  refreshListenable: authStateNotifier,

  // Startseite
  initialLocation: '/',

  // Routing-Logik basierend auf Login-Zustand
  redirect: (context, state) {
    // 🚫 Verhindere Redirects solange Auth noch nicht initialisiert ist
    if (!authStateNotifier.isInitialized) return null;

    final isLoggedIn = authStateNotifier.isLoggedIn;
    final goingToLogin = state.uri.toString() == '/login';

    if (!isLoggedIn && !goingToLogin) return '/login';
    if (isLoggedIn && goingToLogin) return '/dashboard';

    return null;
  },

  routes: [
    // Login-Seite
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Dashboard nach Login
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    // Weiterleitung von Root zur passenden Route
    GoRoute(path: '/', redirect: (_, __) => '/dashboard'),
  ],
);
