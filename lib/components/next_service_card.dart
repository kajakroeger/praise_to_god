import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NextServiceCard extends StatelessWidget {
  final String? serviceName;
  final String? startTime;
  final List<Map<String, dynamic>>? members;

  const NextServiceCard({
    super.key,
    this.serviceName,
    this.startTime,
    this.members,
  });

  Future<Map<String, dynamic>?> _fetchNextService() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .orderBy('startTime')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Widget build(BuildContext context) {
    // Wenn Testdaten übergeben wurden, direkt verwenden
    if (serviceName != null && startTime != null && members != null) {
      return _buildCard(serviceName!, startTime!, members!);
    }

    // Sonst Firestore-Daten laden
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchNextService(),
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
          data['startTime'] ?? '',
          List<Map<String, dynamic>>.from(data['members'] ?? []),
        );
      },
    );
  }

  Widget _buildCard(
    String serviceName,
    String startTime,
    List<Map<String, dynamic>> members,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Startzeit: $startTime Uhr',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: members.map((member) {
                final name = member['name'] ?? '';
                final imageUrl = member['profileImageUrl'] ?? '';

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/avatar_default.png')
                                as ImageProvider,
                      radius: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(name),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
