import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praise_to_god/services/firebase_options.dart';

/// 📦 Initialisiert Firebase und lädt Umgebungsvariablen
Future<void> initializeTestEnvironment() async {
  await dotenv.load(fileName: '.env');

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

/// Meldet Testnutzer mit E-Mail/Passwort an
Future<void> signInTestUser() async {
  final email = dotenv.env['TEST_USER_EMAIL'];
  final password = dotenv.env['TEST_USER_PASSWORD'];

  if (email == null || password == null) {
    throw Exception('TEST_USER_EMAIL oder TEST_USER_PASSWORD fehlt in .env');
  }

  // Nutzer anmelden
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

/// Setup: Weist den aktuellen User einem zukünftigen Service zu
Future<Map<String, dynamic>?> setupTestServiceAssignment() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final now = DateTime.now();

  // Finde den nächsten verfügbaren Service-Termin
  final snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc('sunday_service')
      .collection('dates')
      .orderBy('date')
      .get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final dateStr = data['date'] as String?;
    final parsedDate = dateStr != null ? DateTime.tryParse(dateStr) : null;
    if (parsedDate == null || parsedDate.isBefore(now)) continue;

    final services = data['services'] as Map<String, dynamic>? ?? {};

    // Suche einen Service mit freien Plätzen (z.B. tech)
    for (final entry in services.entries) {
      final serviceKey = entry.key;
      final service = entry.value as Map<String, dynamic>;
      final assigned = service['assigned'] as List<dynamic>? ?? [];
      final maxMembers = service['maxTeamMembers'] as int? ?? 2;

      if (assigned.length < maxMembers) {
        // Füge User hinzu
        assigned.add(userRef);

        // Update Firestore
        await doc.reference.update({'services.$serviceKey.assigned': assigned});

        // Hole User-Daten für Rückgabe
        final userSnap = await userRef.get();
        final userData = userSnap.data() as Map<String, dynamic>? ?? {};

        return {
          "serviceName": serviceKey.toUpperCase(),
          "date": parsedDate,
          "dateString": dateStr,
          "docId": doc.id,
          "members": [
            {
              "name":
                  userData["displayName"] ?? userData["name"] ?? "Unbekannt",
              "avatarUrl": userData["avatarAssetPath"] ?? "",
            },
          ],
        };
      }
    }
  }

  return null;
}

/// Cleanup: Entfernt Test-Zuweisungen
Future<void> cleanupTestServiceAssignment(
  String docId,
  String serviceName,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  try {
    final docRef = FirebaseFirestore.instance
        .collection('events')
        .doc('sunday_service')
        .collection('dates')
        .doc(docId);

    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final services = data['services'] as Map<String, dynamic>? ?? {};
    final service =
        services[serviceName.toLowerCase()] as Map<String, dynamic>? ?? {};
    final assigned = List<dynamic>.from(
      service['assigned'] as List<dynamic>? ?? [],
    );

    // Entferne User aus der Liste
    assigned.removeWhere(
      (ref) => ref is DocumentReference && ref.path == userRef.path,
    );

    await docRef.update({
      'services.${serviceName.toLowerCase()}.assigned': assigned,
    });
  } catch (e) {
    print('Cleanup error: $e');
  }
}

Future<Map<String, dynamic>?> getAssignedServiceInfoForCurrentUser() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final now = DateTime.now();

  final snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc('sunday_service')
      .collection('dates')
      .orderBy('date')
      .get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final dateStr = data['date'] as String?;
    final parsedDate = dateStr != null ? DateTime.tryParse(dateStr) : null;
    if (parsedDate == null || parsedDate.isBefore(now)) continue;

    final services = data['services'] as Map<String, dynamic>? ?? {};

    for (final entry in services.entries) {
      final serviceKey = entry.key;
      final service = entry.value as Map<String, dynamic>;
      final assigned = service['assigned'] as List<dynamic>? ?? [];

      final isAssigned = assigned.any(
        (ref) => ref is DocumentReference && ref.path == userRef.path,
      );

      if (isAssigned) {
        // Hole Infos zu allen zugewiesenen Usern
        final List<Map<String, dynamic>> members = [];

        for (final ref in assigned) {
          if (ref is DocumentReference) {
            final userSnap = await ref.get();
            final userData = userSnap.data() as Map<String, dynamic>? ?? {};

            members.add({
              "name":
                  userData["displayName"] ?? userData["name"] ?? "Unbekannt",
              "avatarUrl": userData["avatarAssetPath"] ?? "",
            });
          }
        }

        return {
          "serviceName": serviceKey.toUpperCase(),
          "date": parsedDate,
          "dateString": dateStr,
          "members": members,
        };
      }
    }
  }

  return null;
}

/// Meldet den Testnutzer ab
Future<void> signOutTestUser() async {
  await FirebaseAuth.instance.signOut();
}
