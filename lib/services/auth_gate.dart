import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Ladeanzeige
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Wenn eingeloggt: weiterleiten zum Dashboard
          if (snapshot.hasData) {
            context.go('/dashboard');
          } else {
            // Wenn nicht eingeloggt: weiterleiten zum Login
            context.go('/login');
          }
        });

        // Zeige nichts – da ohnehin weitergeleitet wird
        return const SizedBox.shrink();
      },
    );
  }
}
