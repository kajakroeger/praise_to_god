import 'main.dart';
import 'flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  mainCommon(
    const FlavorConfig(
      name: "PraiseToGod (Dev)",
      color: Colors.orange,
      environment: Environment.dev,
      baseUrl: '',
    ),
  );
}
