import 'package:flutter/material.dart';

enum Flavor { dev, prod }

class FlavorConfig {
  final String name;
  final Flavor flavor;
  final MaterialColor color;

  static late FlavorConfig instance;

  FlavorConfig({
    required this.name,
    required this.flavor,
    required this.color,
    required String baseUrl,
    required bool showBanner,
  }) {
    instance = this;
  }

  static bool isProd() => instance.flavor == Flavor.prod;
  static bool isDev() => instance.flavor == Flavor.dev;
}
