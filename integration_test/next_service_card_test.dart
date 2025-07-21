import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:praise_to_god/app.dart';
import 'package:praise_to_god/firebase_options.dart';

void main() async {
  // 📌 Binding vorbereiten (notwendig für Integrationstests)
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // 📅 Locale-Daten initialisieren (z. B. für "de")
  await initializeDateFormatting('de_DE');
  Intl.defaultLocale = 'de_DE';

  testWidgets(
    'Integrationstest: NextServiceCard zeigt korrekte Firestore-Daten',
    (tester) async {
      // 🔥 Firebase initialisieren
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 🧪 Testnutzer anmelden
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'kaja@test.com',
        password: 'YHWH4E',
      );

      // ✅ App starten im Testmodus (z. B. direkt Dashboard ohne Login-Screen)
      await tester.pumpWidget(const MyApp(isTestMode: true));

      // ⏳ Zeit geben, bis Daten geladen werden
      await tester.pumpAndSettle(const Duration(seconds: 7));

      // 🔎 Prüfe, ob Dienstname angezeigt wird
      expect(find.byKey(const Key('serviceName')), findsOneWidget);
      expect(find.textContaining('TECHNIK'), findsOneWidget);

      // 🔎 Prüfe, ob Startzeit angezeigt wird
      expect(find.byKey(const Key('startTime')), findsOneWidget);

      // 🔎 Prüfe, ob Benutzernamen sichtbar sind
      expect(find.text('Anna'), findsOneWidget);
      expect(find.text('David'), findsOneWidget);

      // 🚪 Am Ende ggf. wieder abmelden (sauberer Testabschluss)
      addTearDown(() async => FirebaseAuth.instance.signOut());
    },
  );
}
