import 'package:flutter/material.dart';
import 'package:praise_to_god/components/generate_events.dart'; // Dort liegt deine generateSundayServices()-Funktion

class GenerateEventsScreen extends StatefulWidget {
  const GenerateEventsScreen({super.key});

  @override
  State<GenerateEventsScreen> createState() => _GenerateEventsScreenState();
}

class _GenerateEventsScreenState extends State<GenerateEventsScreen> {
  bool _isGenerating = false;
  String? _statusMessage;

  Future<void> _handleGenerate() async {
    setState(() {
      _isGenerating = true;
      _statusMessage = null;
    });

    try {
      await generateSundayServices(); // Deine Logik zum Erstellen in Firestore
      setState(() {
        _statusMessage = '✅ Gottesdienste erfolgreich erstellt!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Fehler: $e';
      });
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events generieren')),
      body: Center(
        child: _isGenerating
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _handleGenerate,
                    child: const Text('Gottesdienste erstellen'),
                  ),
                  if (_statusMessage != null) ...[
                    const SizedBox(height: 20),
                    Text(_statusMessage!),
                  ],
                ],
              ),
      ),
    );
  }
}
