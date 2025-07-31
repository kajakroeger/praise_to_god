import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praise_to_god/services/auth_service.dart';
import '../flavor_config.dart';

class LoginScreen extends StatefulWidget {
  final AuthService? authServiceOverride;

  const LoginScreen({super.key, this.authServiceOverride});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService authService;

  // Controller für E-Mail und Passwort
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Wird bei Widget-Erstellung einmalig ausgeführt und initialisiert den AuthService
  @override
  void initState() {
    super.initState();
    authService = widget.authServiceOverride ?? AuthService();
  }

  // Prüft, ob sich die App im Dev-Modus befindet (über FlavorConfig)
  bool get _isDevEnvironment {
    try {
      return FlavorConfig.instance.flavor == Flavor.dev;
    } catch (e) {
      // Fallback für Tests oder uninitialisierte FlavorConfig
      return false;
    }
  }

  // Funktion zum Einloggen mit E-Mail & Passwort
  Future<void> _loginWithEmailPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await authService.signInWithEmailPassword(email, password);

      // Erfolgreich eingeloggt → Weiterleitung zum Dashboard
      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      // Bei Fehler: Snackbar mit Fehlermeldung
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login fehlgeschlagen: $e')));
    }
  }

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

                // Hinweis, wenn App in Dev-Umgebung gestartet ist
                if (_isDevEnvironment)
                  Text(
                    'PraiseToGod (dev)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00254c),
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

                // 📧 Eingabefeld für E-Mail
                TextField(
                  key: const Key('email_field'),
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                ),

                // 🔑 Eingabefeld für Passwort
                TextField(
                  key: const Key('password_field'),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Passwort'),
                ),

                const SizedBox(height: 16),

                // Login-Button
                ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: _loginWithEmailPassword,
                  child: const Text('Anmelden'),
                ),

                // Passwort vergessen
                TextButton(
                  key: const Key('forgot_password_button'),
                  onPressed: () {
                    // TODO: Passwort vergessen-Logik hier implementieren
                  },
                  child: const Text('Passwort vergessen?'),
                ),

                const SizedBox(height: 16),

                // Google Login
                ElevatedButton(
                  key: const Key('google_login_button'),
                  onPressed: () async {
                    try {
                      await authService.signInWithGoogle();

                      if (!mounted) return;
                      context.go('/dashboard');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Google-Login fehlgeschlagen: $e'),
                        ),
                      );
                    }
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
