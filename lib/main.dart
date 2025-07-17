import 'package:flutter/material.dart';
import 'flavor_config.dart';
import 'screens/login.dart';
import 'logger.dart';
import 'screens/dashboard.dart';

void mainCommon(FlavorConfig config) {
  if (config.flavor == Flavor.dev) {
    logger.i('🚀 App gestartet mit Flavor: ${config.flavor}');
  }
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final FlavorConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.name,
      theme: ThemeData(primarySwatch: config.color, useMaterial3: true),
      // home: Stack(children: [const LoginScreen()]),
      home: const DashboardScreen(), // Hier der neue Screen
      debugShowCheckedModeBanner: false,
    );
  }
}
