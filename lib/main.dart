// Einstiegspunkt der App. Initialisiert alles, was vor dem Start der App nötig ist:
// - Initialisiert Firebase.
// - Setzt das deutsche Datumsformat.
// - Liest den aktuellen Flavor aus.
// - Damit die App in der gewünschten Umgebung geladen wird, den gewünschten Flavor angeben:
//     - flutter run --dart-define=FLAVOR=dev
//     - flutter run --dart-define=FLAVOR=prod
// - Initialisiert die jeweilige Umgebungskonfiguration.
// - Startet die App.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'flavor_config.dart';
import 'services/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  // Notwendig für asynchrone Initialisierungen vor App-Start
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase bereits initialisiert - das ist OK
  }

  // Deutsche Datumsformate aktivieren
  await initializeDateFormatting('de_DE');
  Intl.defaultLocale = 'de_DE';

  // Flavor automatisch erkennen
  const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  // Je nach Umgebung die passende Konfiguration setzen
  if (flavor == 'prod') {
    FlavorConfig.initialize(
      flavor: Flavor.prod,
      name: "PROD",
      values: FlavorValues(baseUrl: "https://api.praisetogod.de"),
      showBanner: false,
      color: 0xFF2196F3,
    );
  } else {
    FlavorConfig.initialize(
      flavor: Flavor.dev,
      name: "DEV",
      values: FlavorValues(baseUrl: "https://dev.api.praisetogod.de"),
      showBanner: true,
      color: 0xFFE91E63,
    );
  }

  runApp(MyApp());
}
