import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NextServiceCard extends StatelessWidget {
  final String? serviceName;
  final Timestamp? startTime;
  final List<Map<String, dynamic>>? users;

  const NextServiceCard({
    super.key,
    this.serviceName,
    this.startTime,
    this.users,
  });

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat('EEEE, dd.MM', 'de_DE');
    return formatter.format(date);
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat.Hm('de_DE');
    return formatter.format(date);
  }

  Future<Map<String, dynamic>?> _fetchNextServiceWithUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .orderBy('start') // sicherstellen, dass 'start' korrekt ist
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
      'startTime': serviceData['start'] as Timestamp,
      'users': loadedUsers,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (serviceName != null && startTime != null && users != null) {
      return _buildCard(serviceName!, startTime!, users!);
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchNextServiceWithUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('Kein nächster Dienst gefunden');
        }

        final data = snapshot.data!;
        return _buildCard(
          data['serviceName'] ?? '',
          data['startTime'] as Timestamp,
          List<Map<String, dynamic>>.from(data['users'] ?? []),
        );
      },
    );
  }

  Widget _buildCard(
    String serviceName,
    Timestamp startTime,
    List<Map<String, dynamic>> users,
  ) {
    final dateStr = _formatDate(startTime); // z. B. „Sonntag, 20.07“
    final timeStr = _formatTime(startTime); // z. B. „10:00“

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 👉 Linke Spalte: Dienstname & User-Avatare
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: users.map((user) {
                      final name = user['name'] ?? 'Unbekannt';
                      final avatarUrl = user['avatar'] ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: avatarUrl.isNotEmpty
                                  ? NetworkImage(avatarUrl)
                                  : const AssetImage(
                                          'assets/avatar_default.png',
                                        )
                                        as ImageProvider,
                              radius: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(name, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // 👉 Rechte Spalte: Datum & Zeit
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
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
