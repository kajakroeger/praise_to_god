import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'flavor_config.dart';
import 'logger.dart';
import 'router/router.dart';

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
    return MaterialApp.router(
      title: config.name,
      theme: ThemeData(primarySwatch: config.color, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
