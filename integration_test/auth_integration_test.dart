@Tags(['manual'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praise_to_god/firebase_options.dart';
import 'package:praise_to_god/services/auth_service.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late AuthService authService;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    authService = AuthService();
  });

  group('AuthService Integration (Firebase Dev)', () {
    test('Login mit E-Mail/Passwort', () async {
      final email = dotenv.env['TEST_USER_EMAIL'];
      final password = dotenv.env['TEST_USER_PASSWORD'];

      expect(email, isNotNull, reason: 'TEST_USER_EMAIL fehlt in .env');
      expect(password, isNotNull, reason: 'TEST_USER_PASSWORD fehlt in .env');

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      expect(userCredential.user, isNotNull);
      expect(userCredential.user?.email, email);
    });

    test('Logout funktioniert korrekt', () async {
      final email = dotenv.env['TEST_USER_EMAIL']!;
      final password = dotenv.env['TEST_USER_PASSWORD']!;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.signOut();

      expect(FirebaseAuth.instance.currentUser, isNull);
    });

    test('Login mit Google (manuell ausführen)', () async {
      final result = await authService.signInWithGoogle();

      expect(result, isA<UserCredential>());
      expect(result?.user, isNotNull);
    });
  });
}
