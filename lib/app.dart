import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'services/auth_gate.dart'; // ✅ Importiere das AuthGate-Widget

class MyApp extends StatelessWidget {
  final bool isTestMode;

  const MyApp({super.key, this.isTestMode = false});

  @override
  Widget build(BuildContext context) {
    // ✅ Im Testmodus direkt das Dashboard anzeigen
    if (isTestMode) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PraiseToGod (Test)',
        home: DashboardScreen(),
      );
    }

    // ✅ GoRouter mit AuthGate als Einstieg
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        // 🔐 AuthGate entscheidet über Login oder Weiterleitung
        GoRoute(path: '/', builder: (context, state) => const AuthGate()),

        // 📋 Dashboard (geschützte Route)
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),

        // 🔑 Login manuell erreichbar (falls nötig)
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PraiseToGod',
      routerConfig: router,
    );
  }
}
