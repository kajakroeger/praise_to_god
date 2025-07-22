import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NextServiceCard extends StatelessWidget {
  const NextServiceCard({super.key});

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

  /// 🔄 Dienst-Daten aus Firestore laden
  Future<List<Map<String, dynamic>>> _fetchNextServicesFromEvents() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final userUid = currentUser.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userUid);
    final now = DateTime.now();

    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc('sunday_service')
        .collection('dates')
        .orderBy('date')
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final dateStr = data['date'] as String;

      final parsedDate = DateTime.tryParse(dateStr);
      if (parsedDate == null || parsedDate.isBefore(now)) continue;

      final services = data['services'] as Map<String, dynamic>? ?? {};
      final List<Map<String, dynamic>> matchedServices = [];

      for (final entry in services.entries) {
        final serviceKey = entry.key;
        final service = entry.value as Map<String, dynamic>;
        final assigned = service['assigned'] as List<dynamic>? ?? [];

        final isAssigned = assigned.any(
          (ref) => ref is DocumentReference && ref.path == userRef.path,
        );
        if (!isAssigned) continue;

        final startTimeStr = service['startTime'] ?? '00:00';
        final timeParts = startTimeStr.split(':');

        // 💡 Sicherstellen, dass Zeit korrekt geparst werden kann
        if (timeParts.length < 2) continue;

        final fullDateTime = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          int.parse(timeParts[0]) ?? 0,
          int.parse(timeParts[1]) ?? 0,
        );

        // 🛡️ Dienste in der Vergangenheit ignorieren
        if (fullDateTime.isBefore(now)) continue;

        final List<Map<String, dynamic>> loadedUsers = await Future.wait(
          assigned.map((ref) async {
            if (ref is DocumentReference) {
              try {
                final userDoc = await ref.get();
                final userData = userDoc.data() as Map<String, dynamic>;
                return {
                  'name': userData['displayName'] ?? 'Unbekannt',
                  'avatar': userData['avatarAssetPath'] ?? '',
                };
              } catch (e) {
                return {'name': 'Unbekannt', 'avatar': ''};
              }
            }
            return {'name': 'Unbekannt', 'avatar': ''};
          }),
        );

        matchedServices.add({
          'serviceName': serviceKey,
          'startTime': Timestamp.fromDate(fullDateTime),
          'users': loadedUsers,
        });
      }

      // 👉 Nur das nächste Event mit mind. einem passenden Dienst zurückgeben
      if (matchedServices.isNotEmpty) return matchedServices;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchNextServicesFromEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final dataList = snapshot.data ?? [];
        if (dataList.isEmpty) {
          return _buildWithTitle(const Text('Kein nächster Dienst gefunden'));
        }

        return _buildWithTitle(
          Column(
            children: dataList.map((data) {
              return _buildCard(
                data['serviceName'],
                data['startTime'],
                List<Map<String, dynamic>>.from(data['users']),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// 🧩 Überschrift + Cards
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
      key: Key('nextServiceCard_${serviceName}_$startTime'),
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
                                ? AssetImage(avatarUrl)
                                : const AssetImage(
                                    'assets/avatars/avatar_default.png',
                                  ),
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
