import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:praise_to_god/screens/login.dart';
import 'package:praise_to_god/services/auth_service.dart';
import '../mocks/mock_firebase_auth.mocks.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('LoginScreen UI-Tests', () {
    testWidgets('zeigt E-Mail, Passwort und Login-Buttons korrekt an', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(authServiceOverride: mockAuthService)),
      );

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.byKey(const Key('forgot_password_button')), findsOneWidget);
      expect(find.byKey(const Key('google_login_button')), findsOneWidget);
    });
  });
}
