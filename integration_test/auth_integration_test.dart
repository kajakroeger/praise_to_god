// Der Test prüft, ob die Anmeldungsmethoden E-Mail & Passwort sowie Google Login.
// Konkret wird getestet,
// ob registrierte User sich mit E-Mail und Passwort anmelden können,
// ob sich registrierte User über den Logout Button abmelden können,
// ob sich registrierte User über den Google-Login Button anmelden können.

// Dieser Test muss manuell ausgeführt werden, weil Google-Login User-Interaktion erfordert
@Tags(['manual'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praise_to_god/services/firebase_options.dart';
import 'package:praise_to_god/services/auth_service.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'test_utils.dart';

void main() {
  // Initialisiert das Integrationstest-Framework
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late AuthService authService;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');

    // Firebase initialisieren, wenn es noch nicht initialisiert wurde
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    authService = AuthService();
  });

  // Clean-up nach allen Tests
  tearDownAll(() async {
    await signOutTestUser();
  });

  group('AuthService Integration (Firebase Dev)', () {
    test('Login mit E-Mail/Passwort', () async {
      await signInTestUser();

      final user = FirebaseAuth.instance.currentUser;

      expect(user, isNotNull);
      expect(user?.email, dotenv.env['TEST_USER_EMAIL']);
    });

    test('Logout funktioniert korrekt', () async {
      await signOutTestUser();

      expect(FirebaseAuth.instance.currentUser, isNull);
    });

    test('Login mit Google (manuell ausführen)', () async {
      final result = await authService.signInWithGoogle();

      expect(result, isA<UserCredential>());
      expect(result?.user, isNotNull);
    });
  });
}
