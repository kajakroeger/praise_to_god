// Firestore-Abfrage

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/services.dart';

class ServiceRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<Service?> fetchNextService() async {
    final snapshot = await _firestore
        .collection('services')
        .orderBy('startTime') // oder eigenes Feld z. B. timestamp
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final data = snapshot.docs.first.data();
    return Service.fromFirestore(data);
  }
}
