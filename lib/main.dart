import 'package:flutter/material.dart';
import 'flavor_config.dart';
import 'screens/login.dart';

void mainCommon(FlavorConfig config) {
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final FlavorConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.name,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
