/// Testet, ob alle zentralen Bedienelemente des LoginScreens korrekt angezeigt werden.
/// Dazu gehören E-Mail-Feld, Passwort-Feld sowie die Buttons für Login, Passwort vergessen und Google-Login.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praise_to_god/screens/login.dart';
import 'package:praise_to_god/flavor_config.dart';

void main() {
  setUp(() {
    // FlavorConfig für Tests initialisieren
    FlavorConfig.instance = FlavorConfig(
      name: 'Test',
      flavor: Flavor.dev,
      baseUrl: '',
      color: Colors.blue,
      showBanner: false,
    );
  });

  group('LoginScreen UI-Tests', () {
    testWidgets('zeigt E-Mail, Passwort und Login-Buttons korrekt an', (
      tester,
    ) async {
      // Widget bauen
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Erwartete UI-Elemente prüfen
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.byKey(const Key('forgot_password_button')), findsOneWidget);
      expect(find.byKey(const Key('google_login_button')), findsOneWidget);
    });
  });
}
