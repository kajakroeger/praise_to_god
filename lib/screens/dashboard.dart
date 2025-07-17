import 'package:flutter/material.dart';
import 'package:praise_to_god/components/next_service_card.dart';
import 'package:praise_to_god/components/bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

      // 👉 Hier kommt der eigentliche Inhalt rein
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Deine dynamische Komponente
          NextServiceCard(),
        ],
      ),

      // 👉 BottomNavBar korrekt eingebunden
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
