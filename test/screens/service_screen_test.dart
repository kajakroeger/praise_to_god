// Stellt sicher, dass im ServiceScreen der Dropdown zur Teamauswahl vorhanden ist

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praise_to_god/screens/service.dart';

// Mock-Klassen für FirebaseAuth und User, damit kein echter Login nötig ist.
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  // Initialisiert Flutter-Testsystem zum Testen von Widgets
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUpAll(() async {
    // Simuliert die Initialisierung von Firebase – erforderlich,
    // wenn z.B. ein StreamBuilder oder Auth-Status im UI verwendet wird.
    await Firebase.initializeApp();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();

    // Gibt an, dass ein "eingeloggter" Benutzer zurückgegeben werden soll –
    // wichtig, wenn der Screen Zugriff auf den aktuellen Benutzer erwartet.
    when(() => mockAuth.currentUser).thenReturn(mockUser);
  });

  testWidgets('zeigt Dropdown', (tester) async {
    await tester.pumpWidget(MaterialApp(home: ServiceScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('teamDropdown')), findsOneWidget);
  });
}
