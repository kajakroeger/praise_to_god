import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:praise_to_god/screens/login.dart';
import 'package:praise_to_god/services/auth_service.dart';
import 'package:praise_to_god/flavor_config.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  // Test für beide Flavors durchlaufen lassen
  for (final flavor in Flavor.values) {
    group('LoginScreen UI-Tests – Flavor: $flavor', () {
      setUp(() {
        // FlavorConfig setzen für dev oder prod
        if (flavor == Flavor.dev) {
          FlavorConfig.initialize(
            flavor: Flavor.dev,
            name: 'DEV',
            values: FlavorValues(baseUrl: 'https://dev.api.praisetogod.de'),
            showBanner: true,
            color: 0xFFE91E63,
          );
        } else if (flavor == Flavor.prod) {
          FlavorConfig.initialize(
            flavor: Flavor.prod,
            name: 'PROD',
            values: FlavorValues(baseUrl: 'https://api.praisetogod.de'),
            showBanner: false,
            color: 0xFF2196F3,
          );
        }
      });

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
}
