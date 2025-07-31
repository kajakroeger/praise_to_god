// Diese Datei definiert eine Klasse zur Beobachtung des Login-Zustands eines Nutzers.
// Sie lauscht auf Änderungen des Authentifizierungsstatus und benachrichtigt andere Widgets,
// wenn sich dieser Status ändert.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// AuthStateNotifier ist ein ChangeNotifier, der andere Widgets informiert,
/// wenn sich der Auth-Status (eingeloggt / ausgeloggt) ändert.
class AuthStateNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Speichert den eingeloggten Nutzer. Wenn User nicht eingeloggt ist, dann ist User null
  User? _user;

  // Zeigt an, ob die erste Initialisierung abgeschlossen ist
  bool _initialized = false;

  // Konstruktor: startet das Lauschen auf Änderungen im Auth-Status
  AuthStateNotifier() {
    // .authStateChanges() gibt einen Stream zurück, der bei Login/Logout-Änderung feuert
    _auth.authStateChanges().listen((user) {
      _user = user; // Setzt den aktuellen Benutzer (kann auch null sein)
      _initialized = true; // Merkt sich, dass der erste Zustand geladen wurde
      notifyListeners(); // Informiert alle abhängigen Widgets über die Änderung
    });
  }

  // Gibt true zurück, wenn der Authentifizierungsstatus (z.B. eingeloggt oder nicht) bereits einmal abgefragt wurde
  bool get isInitialized => _initialized;

  // Gibt true zurück, wenn aktuell ein Benutzer eingeloggt ist.
  bool get isLoggedIn => _user != null;
}
