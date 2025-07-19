import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praise_to_god/components/next_service_card.dart';
import 'package:praise_to_god/components/bottom_nav_bar.dart';
import 'package:praise_to_god/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? firstName;
  bool isLoading = true;

  /// 🔁 Daten vom User neu laden
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      firstName = snapshot.data()?['first_name'] ?? 'Nutzer';
      isLoading = false;
    });
  }

  /// 🚪 Logout-Funktion
  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hi $firstName 👋'),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () => _logout(context),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData, // 👈 beim Wischen nach unten neu laden
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [SizedBox(height: 12), NextServiceCard()],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
