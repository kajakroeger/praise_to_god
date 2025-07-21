import 'package:flutter/material.dart';

import '../components/bottom_nav_bar.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String selectedTeam = 'Technik'; // Standard-Team
  final List<String> availableTeams = ['Technik', 'Worship', 'Welcome'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dienste')),
      body: Column(
        children: [
          // 🔽 Dropdown zur Teamauswahl
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              key: const Key('teamDropdown'),
              value: selectedTeam,
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedTeam = value;
                  });
                }
              },
              items: availableTeams.map((team) {
                return DropdownMenuItem<String>(value: team, child: Text(team));
              }).toList(),
            ),
          ),

          // 📋 Liste der Dienste
          Expanded(
            child: ListView(
              key: const Key('serviceList'),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    key: Key('month'),
                    'Juli',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(title: Text('13 SO')),
                ListTile(title: Text('20 SO')),
                ListTile(title: Text('27 SO')),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    key: Key('month'),
                    'August',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(title: Text('03 SO')),
                ListTile(title: Text('10 SO')),
                ListTile(title: Text('17 SO')),
                ListTile(title: Text('24 SO')),
                ListTile(title: Text('31 SO')),
              ],
            ),
          ),
        ],
      ),

      // 📱 BottomNavigationBar
      bottomNavigationBar: const BottomNavBar(currentRoute: '/service'),
    );
  }
}
