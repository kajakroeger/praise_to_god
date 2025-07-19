import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praise_to_god/firebase_options.dart';
import 'package:praise_to_god/services/auth_service.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late AuthService authService;

  setUpAll(() async {
    // Initialisiere Firebase für deine DEV-Umgebung
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    authService = AuthService(); // Nutzt echte Instanzen
  });

  group('AuthService Integration (Firebase Dev)', () {
    test('Login mit E-Mail/Passwort (echte Firebase-Daten)', () async {
      // Testkonto, das vorher in der Firebase-Console (dev) angelegt wurde
      const email = 'testuser@example.com';
      const password = 'testpass123';

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      expect(userCredential.user, isNotNull);
      expect(userCredential.user?.email, email);
    });

    test('Logout funktioniert korrekt', () async {
      await FirebaseAuth.instance.signOut();

      expect(FirebaseAuth.instance.currentUser, isNull);
    });

    test('Login mit Google (manuell initiiert)', () async {
      final result = await authService.signInWithGoogle();

      // Wenn du testest, brauchst du ggf. einen echten Google Login im Emulator
      expect(result, isA<UserCredential>());
      expect(result?.user, isNotNull);
      print('Angemeldet als: ${result?.user?.email}');
    });
  });
}
