// Der ServiceScreen zeigt eine Liste von Diensten für ausgewählte Teams.
// Nutzer:innen können sich per Dialog in einen Dienst ein- oder austragen.
// Daten werden aus Firestore geladen und dynamisch angezeigt.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import 'package:praise_to_god/services/auth_service.dart';

class ServiceScreen extends StatefulWidget {
  final AuthService authService;

  ServiceScreen({super.key, AuthService? authService})
    : authService = authService ?? AuthService(); // Default-Instanz

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String selectedTeam = 'tech'; // Anfangs-Auswahl
  late AuthService _authService;

  final Map<String, String> teamLabels = {
    'tech': 'Technik',
    'worship': 'Worship',
    'welcome': 'Welcome',
    'kitchen': 'Küche',
  };

  @override
  void initState() {
    super.initState();
    _authService = widget.authService;
  }

  /// Gibt Monatsnamen zurück
  String _getMonthName(int month) {
    const names = [
      '',
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ];
    return names[month];
  }

  /// Format wie „13 SO“
  String _formatDate(DateTime date) {
    const weekdays = ['MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO'];
    return '${date.day.toString().padLeft(2, '0')} ${weekdays[date.weekday - 1]}';
  }

  /// Dialog zur Ein- oder Austragung
  /// - Prüft, ob Nutzer schon zugewiesen ist
  /// - Zeigt passenden Dialog (eintragen / austragen)
  /// - Aktualisiert Firestore und zeigt Feedback
  void _handleServiceTap(
    BuildContext context,
    String date,
    String team,
    List<dynamic> assignedRefs,
  ) async {
    final user = _authService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Fehler: Du bist nicht eingeloggt. Bitte kontaktiere den Support',
          ),
        ),
      );
      return;
    }

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final isAssigned = assignedRefs.any(
      (ref) => ref is DocumentReference && ref.path == userRef.path,
    );

    if (isAssigned) {
      final shouldUnassign = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Vom Dienst austragen'),
          content: Text(
            'Möchtest du dich wirklich vom Dienst am $date austragen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Austragen'),
            ),
          ],
        ),
      );

      if (shouldUnassign == true) {
        final docRef = FirebaseFirestore.instance
            .collection('events')
            .doc('sunday_service')
            .collection('dates')
            .doc(date);

        await docRef.update({
          'services.$team.assigned': FieldValue.arrayRemove([userRef]),
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Du wurdest ausgetragen.')),
        );
      }
    } else {
      final shouldAssign = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Zum Dienst eintragen'),
          content: Text('Möchtest du dich für den Dienst am $date eintragen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eintragen'),
            ),
          ],
        ),
      );

      if (shouldAssign == true) {
        final docRef = FirebaseFirestore.instance
            .collection('events')
            .doc('sunday_service')
            .collection('dates')
            .doc(date);

        await docRef.update({
          'services.$team.assigned': FieldValue.arrayUnion([userRef]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Du wurdest eingetragen.')),
        );
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dienste')),
      body: Column(
        children: [
          // 🔽 Dropdown zur Auswahl des Teams
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
              items: teamLabels.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ),

          // 🔁 StreamBuilder: Lädt und aktualisiert Diensttermine in Echtzeit aus Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .doc('sunday_service')
                  .collection('dates')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Keine Termine gefunden.'));
                }

                final docs = snapshot.data!.docs;

                // Liste der Termine für das gewählte Team
                // Pro Termin wird ein Card-Widget angezeigt
                return ListView.builder(
                  key: const Key('serviceList'),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final serviceData = data['services']?[selectedTeam];
                    if (serviceData == null) return const SizedBox.shrink();

                    final date = DateTime.parse(data['date']);
                    final startTime = serviceData['startTime'] ?? '';
                    final assigned =
                        serviceData['assigned'] as List<dynamic>? ?? [];

                    // Header mit Monatsnamen (z.B. "Mai") für Monatswechsel
                    final bool showMonthHeader =
                        index == 0 ||
                        date.month != DateTime.parse(docs[index - 1].id).month;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showMonthHeader)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Text(
                              key: const Key('month'),
                              _getMonthName(date.month),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // Dienst-Karte mit Datum, Uhrzeit und Teilnehmer:innen
                        // Beim Tippen wird Dialog zur Ein-/Austragung geöffnet
                        InkWell(
                          onTap: () => _handleServiceTap(
                            context,
                            data['date'],
                            selectedTeam,
                            assigned,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 6,
                            ),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDate(date),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          startTime,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (assigned.isNotEmpty)
                                      // 👤 Zeigt Teilnehmer:innen als Chips mit Name + Avatar
                                      // Daten werden aus Firestore geladen (über DocumentReference)
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: assigned.map<Widget>((ref) {
                                          if (ref is DocumentReference) {
                                            return FutureBuilder<
                                              DocumentSnapshot
                                            >(
                                              future: ref.get(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData ||
                                                    !snapshot.data!.exists) {
                                                  return const Chip(
                                                    label: Text('Unbekannt'),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  );
                                                }

                                                final userData =
                                                    snapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                final name =
                                                    userData['displayName'] ??
                                                    'Unbekannt';
                                                final avatarPath =
                                                    userData['avatarAssetPath'] ??
                                                    'assets/avatars/avatar_default.png';

                                                return Chip(
                                                  avatar: CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                      avatarPath,
                                                    ),
                                                  ),
                                                  label: Text(name),
                                                  backgroundColor:
                                                      Colors.grey.shade200,
                                                );
                                              },
                                            );
                                          } else {
                                            return const SizedBox.shrink(); // Sicherheitsfallback
                                          }
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/service'),
    );
  }
}
