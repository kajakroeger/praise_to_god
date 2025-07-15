// lib/main_dev.dart
import 'main.dart';
import 'flavor_config.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'flavor_config.dart';

void main() {
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
