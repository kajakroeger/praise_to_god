import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // für Logout Navigation
import 'package:praise_to_god/components/next_service_card.dart';
import 'package:praise_to_god/components/bottom_nav_bar.dart';
import 'package:praise_to_god/services/auth_service.dart'; // für Logout

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  /// 🔍 Vornamen des aktuell angemeldeten Users aus Firestore laden
  Future<String?> _getFirstName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return snapshot.data()?['first_name'];
  }

  /// 🚪 Logout-Funktion
  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      context.go('/login'); // Navigation zum Login-Screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getFirstName(), // 🔁 Vorname laden
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final firstName = snapshot.data ?? 'Nutzer';

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hi $firstName 👋'), // ✅ Jetzt verfügbar
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () => _logout(context),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: const [NextServiceCard()],
          ),
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
