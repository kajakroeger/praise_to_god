// lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/login.dart';
import 'screens/dashboard.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final goingToLogin = state.uri.toString() == '/login';

    if (!isLoggedIn && !goingToLogin) {
      return '/login';
    }

    if (isLoggedIn && goingToLogin) {
      return '/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(path: '/', redirect: (_, _) => '/dashboard'),
  ],
);
