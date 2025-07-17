// lib/main_dev.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ hinzufügen
import 'package:intl/intl.dart'; // ✅ optional, falls du Intl.defaultLocale setzt

import 'main.dart';
import 'flavor_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Wichtig: await verwenden!
  await initializeDateFormatting('de_DE', null);
  Intl.defaultLocale = 'de_DE';

  mainCommon(
    FlavorConfig(
      name: "PraiseToGod (dev)",
      flavor: Flavor.dev,
      baseUrl: "",
      color: Colors.orange,
      showBanner: true,
    ),
  );
}
