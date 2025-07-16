// lib/main_dev.dart
import 'package:firebase_core/firebase_core.dart';
import 'main.dart';
import 'flavor_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
