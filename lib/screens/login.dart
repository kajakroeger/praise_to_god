import 'package:flutter/material.dart';
import '../flavor_config.dart';
import '../services/auth_service.dart';

final flavor = FlavorConfig.instance.flavor;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                const TextField(
                  key: Key('email_field'),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),
                const TextField(
                  key: Key('password_field'),
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Passwort',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),
                ElevatedButton(
                  key: Key('login_button'),
                  onPressed: () {},
                  child: const Text('Einloggen'),
                ),
                TextButton(
                  key: Key('forgot_password_button'),
                  onPressed: () {},
                  child: const Text('Passwort vergessen'),
                ),

                const Divider(height: 32),

                ElevatedButton.icon(
                  key: const Key('google_login_button'),
                  icon: const Icon(Icons.login),
                  label: const Text('Anmelden mit Google'),
                  onPressed: () async {
                    final authService = AuthService();
                    final userCredential = await authService.signInWithGoogle();
                    if (userCredential != null) {
                      // ✅ Erfolgreich angemeldet → Navigieren oder anzeigen
                      print("Angemeldet: ${userCredential.user?.email}");
                    } else {
                      // ❌ Anmeldung fehlgeschlagen oder abgebrochen
                      print("Anmeldung fehlgeschlagen");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
