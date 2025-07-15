import 'main.dart';
import 'flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  mainCommon(
    const FlavorConfig(
      name: 'PraiseToGod',
      environment: Environment.prod,
      color: Colors.deepPurple,
      baseUrl: 'https://api.praisetogod.com', // oder was du brauchst
    ),
  );
}
