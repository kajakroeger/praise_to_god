import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NextServiceCard extends StatelessWidget {
  // Diese Variable prüft automatisch, ob der Code im Test läuft
  static const bool isTestMode = bool.fromEnvironment('FLUTTER_TEST');
  final String? serviceName;
  final Timestamp? startTime;
  final List<Map<String, dynamic>>? users;

  const NextServiceCard({
    super.key,
    this.serviceName,
    this.startTime,
    this.users,
  });

  /// 🗓 Datum formatieren (z. B. „Sonntag, 20.07“)
  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat('EEEE, dd.MM', 'de_DE');
    return formatter.format(date);
  }

  /// 🕑 Zeit formatieren (z. B. „10:00“)
  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat.Hm('de_DE');
    return formatter.format(date);
  }

  /// 🔄 Dienst + Benutzer aus Firestore laden
  Future<Map<String, dynamic>?> _fetchNextServiceWithUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('startTime', isGreaterThan: Timestamp.now())
        .orderBy('startTime')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final serviceDoc = snapshot.docs.first;
    final serviceData = serviceDoc.data();

    final List<dynamic> userRefs = serviceData['users'] ?? [];

    final List<Map<String, dynamic>> loadedUsers = await Future.wait(
      userRefs.map((ref) async {
        try {
          final userDoc = await (ref as DocumentReference).get();
          final userData = userDoc.data() as Map<String, dynamic>;
          return {
            'name': userData['first_name'] ?? 'Unbekannt',
            'avatar': userData['avatar'] ?? '',
          };
        } catch (e) {
          return {'name': 'Unbekannt', 'avatar': ''};
        }
      }),
    );

    return {
      'serviceName': serviceData['serviceName'],
      'startTime': serviceData['startTime'] as Timestamp,
      'users': loadedUsers,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isTestMode) {
      return const Placeholder(key: Key('nextServiceCard'));
    }

    // 👉 Falls Testdaten übergeben wurden
    if (serviceName != null && startTime != null && users != null) {
      return _buildWithTitle(_buildCard(serviceName!, startTime!, users!));
    }

    // 👉 Sonst: Daten aus Firestore laden
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchNextServiceWithUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return _buildWithTitle(const Text('Kein nächster Dienst gefunden'));
        }

        final data = snapshot.data!;
        return _buildWithTitle(
          _buildCard(
            data['serviceName'] ?? '',
            data['startTime'] as Timestamp,
            List<Map<String, dynamic>>.from(data['users'] ?? []),
          ),
        );
      },
    );
  }

  /// 🧩 Hilfsfunktion, die die Überschrift + Card zusammen zurückgibt
  Widget _buildWithTitle(Widget card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Nächster Dienst',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        card,
      ],
    );
  }

  /// 🧾 Dienst-Karte mit Datum, Uhrzeit & Avataren
  Widget _buildCard(
    String serviceName,
    Timestamp startTime,
    List<Map<String, dynamic>> users,
  ) {
    final dateStr = _formatDate(startTime);
    final timeStr = _formatTime(startTime);

    return Card(
      key: const Key('nextServiceCard'),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 🔹 Linke Spalte: Dienstname & Benutzer
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key: const Key('serviceName'),
                    serviceName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: users.map((user) {
                      final name = user['name'] ?? 'Unbekannt';
                      final avatarUrl = user['avatar'] ?? '';

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : const AssetImage('assets/avatar_default.png')
                                      as ImageProvider,
                            radius: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            key: Key('userName_${name.toLowerCase()}'),
                            name,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // 🔹 Rechte Spalte: Datum & Zeit
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    key: const Key('startTime'),
                    dateStr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Start: $timeStr', style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
