// lib/main_prod.dart
import 'main.dart';
import 'flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  mainCommon(
    FlavorConfig(
      name: "PraiseToGod",
      flavor: Flavor.prod,
      color: Colors.green,
      baseUrl: '',
      showBanner: false,
    ),
  );
}
