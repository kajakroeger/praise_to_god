// Einstiegspunkt der App-Konfiguration für PraiseToGod.
//
// Diese Datei definiert:
//    Die Navigationsstruktur (GoRouter)
//    Die globalen Design-Themes (Farben, Buttons, Karten)
//    Den Startpunkt der App (AuthGate – prüft Login-Zustand)
//
// Alle Screens wie Login, Dashboard und Dienste sind hier eingebunden.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'services/auth_gate.dart';
import 'screens/service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        // AuthGate: entscheidet basierend auf Login-Zustand
        GoRoute(path: '/', builder: (context, state) => const AuthGate()),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
        GoRoute(path: '/service', builder: (context, state) => ServiceScreen()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PraiseToGod',
      routerConfig: router,

      // Globales Theme
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF00254c),

        // AppBar Design
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Card Design
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: EdgeInsets.all(12),
        ),

        // BottomNavigationBar Design
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
        ),

        // Dialogfenster Design
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
        ),

        // ElevatedButton Design
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF27bac2), // Hintergrund
            foregroundColor: Colors.white, // Textfarbe
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // TextButton Design
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF00254C), // Textfarbe
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
