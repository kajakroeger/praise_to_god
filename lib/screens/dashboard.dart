import 'package:flutter/material.dart';
import 'package:praise_to_god/components/next_service_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        children: const [
          SizedBox(height: 16),
          NextServiceCard(key: Key('nextServiceCard')),
          BottomMenuBar(key: Key('bottomMenuBar')),
        ],
      ),
    );
  }
}
