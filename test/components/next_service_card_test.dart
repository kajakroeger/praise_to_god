// Testet die Firestore-Anbindung mit Mock-Daten

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:praise_to_god/components/next_service_card.dart';

import 'next_service_card_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  Query<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockSnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockDocument;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockDocument = MockQueryDocumentSnapshot<Map<String, dynamic>>();
  });

  testWidgets(
    'NextServiceCard zeigt Dienstname, Startzeit und Mitglieder korrekt an',
    (WidgetTester tester) async {
      const serviceName = 'Lobpreis';
      const startTime = '10:00';
      const members = [
        {'name': 'Sarah', 'profileImageUrl': 'https://example.com/sarah.jpg'},
        {'name': 'Paul', 'profileImageUrl': ''},
      ];

      // Firestore-Mocks konfigurieren
      when(mockFirestore.collection('services')).thenReturn(mockCollection);
      when(mockCollection.orderBy('startTime')).thenReturn(mockQuery);
      when(mockQuery.limit(1)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.docs).thenReturn([mockDocument]);
      when(mockDocument.data()).thenReturn({
        'serviceName': serviceName,
        'startTime': startTime,
        'members': members,
      });

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: NextServiceCard())),
      );

      await tester.pumpAndSettle();

      // Tests
      expect(find.text(serviceName), findsOneWidget);
      expect(find.text('Startzeit: $startTime Uhr'), findsOneWidget);
      expect(find.text('Sarah'), findsOneWidget);
      expect(find.text('Paul'), findsOneWidget);
    },
  );
}
