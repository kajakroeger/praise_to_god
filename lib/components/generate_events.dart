// Hilfskomponente zum Erstellen von wiederkehrenden Events, wie Sonntags-Gottesdienste

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Erstellt Sonntag-Gottesdienste für 3 Monate (ab heute)
Future<void> generateSundayServices() async {
  final firestore = FirebaseFirestore.instance;

  final now = DateTime.now();
  final endDate = DateTime(now.year, now.month + 3, now.day);

  final List<DateTime> sundays = _getSundaysBetween(now, endDate);

  for (final date in sundays) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print('Prüfe Datum: $formattedDate');

    final docRef = firestore
        .collection('events')
        .doc('sunday_service')
        .collection('dates')
        .doc(formattedDate);

    final doc = await docRef.get();
    if (doc.exists) {
      print('⚠️ $formattedDate existiert bereits – übersprungen');
      continue;
    }

    await docRef.set({
      'date': formattedDate,
      'services': {
        'worship': {'startTime': '09:45', 'maxTeamMembers': 3, 'assigned': []},
        'kitchen': {'startTime': '09:45', 'maxTeamMembers': 2, 'assigned': []},
        'tech': {'startTime': '10:00', 'maxTeamMembers': 2, 'assigned': []},
        'welcome': {'startTime': '10:00', 'maxTeamMembers': 2, 'assigned': []},
      },
    });

    print('✅ Event für $formattedDate erstellt');
  }
}

/// Gibt alle Sonntage zwischen [start] und [end] zurück
List<DateTime> _getSundaysBetween(DateTime start, DateTime end) {
  final List<DateTime> sundays = [];
  DateTime current = start;

  while (current.isBefore(end)) {
    if (current.weekday == DateTime.sunday) {
      sundays.add(current);
    }
    current = current.add(const Duration(days: 1));
  }

  return sundays;
}
