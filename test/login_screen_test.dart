import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praise_to_god/screens/login.dart'; // Pfad ggf. anpassen

void main() {
  testWidgets('Login Screen zeigt E-Mail und Passwortfelder an', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Prüfe, ob die Eingabefelder und Button da sind
    expect(find.byKey(Key('email_field')), findsOneWidget);
    expect(find.byKey(Key('password_field')), findsOneWidget);
    expect(find.byKey(Key('login_button')), findsOneWidget);
    expect(find.byKey(Key('forgot_password_button')), findsOneWidget);
    expect(find.byKey(Key('google_login_button')), findsOneWidget);
  });
}
