import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'flavor_config.dart';
import 'services/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase mit try-catch initialisieren
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase bereits initialisiert - das ist OK
  }

  await initializeDateFormatting('de_DE');
  Intl.defaultLocale = 'de_DE';

  // Flavor automatisch erkennen
  const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

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
