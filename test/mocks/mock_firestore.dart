import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  Query<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
])
void main() {}
