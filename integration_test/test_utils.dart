import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:praise_to_god/firebase_options.dart';

/// 📦 Initialisiert Firebase und lädt Umgebungsvariablen
Future<void> initializeTestEnvironment() async {
  await dotenv.load(fileName: '.env');

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

/// 🔐 Meldet Testnutzer mit E-Mail/Passwort an
Future<void> signInTestUser() async {
  final email = dotenv.env['TEST_USER_EMAIL']!;
  final password = dotenv.env['TEST_USER_PASSWORD']!;
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

/// 🚪 Meldet den Testnutzer ab
Future<void> signOutTestUser() async {
  await FirebaseAuth.instance.signOut();
}
