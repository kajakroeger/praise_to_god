import 'package:flutter/material.dart';

enum Environment { dev, prod }

class FlavorConfig {
  final String name;
  final Environment environment;
  final Color color;
  final String baseUrl;

  const FlavorConfig({
    required this.name,
    required this.environment,
    required this.color,
    required this.baseUrl,
  });
}
