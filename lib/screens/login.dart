import 'package:flutter/material.dart';
import 'package:praise_to_god/services/auth_service.dart';
import '../flavor_config.dart';

final flavor = FlavorConfig.instance.flavor;

class LoginScreen extends StatelessWidget {
  final AuthService? authServiceOverride;

  const LoginScreen({super.key, this.authServiceOverride});

  @override
  Widget build(BuildContext context) {
    final authService = authServiceOverride ?? AuthService();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logo-platzhalter.jpg'),
                ),

                // Umgebungshinweis nur in dev
                if (flavor == Flavor.dev)
                  const Text(
                    'PraiseToGod (dev)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 24),
                const Text(
                  'Herzlich Willkommen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),
                const Text('Bitte logge dich ein'),
                const SizedBox(height: 24),

                TextField(
                  key: const Key('email_field'),
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                ),

                TextField(
                  key: const Key('password_field'),
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Passwort'),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: () {
                    // Beispiel: authService.signInWithEmailPassword(email, password)
                  },
                  child: const Text('Anmelden'),
                ),

                TextButton(
                  key: const Key('forgot_password_button'),
                  onPressed: () {
                    // Passwort vergessen Logik
                  },
                  child: const Text('Passwort vergessen?'),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  key: const Key('google_login_button'),
                  onPressed: () {
                    authService.signInWithGoogle();
                  },
                  child: const Text('Mit Google anmelden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
