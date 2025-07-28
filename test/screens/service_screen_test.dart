import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praise_to_god/screens/service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUpAll(() async {
    await Firebase.initializeApp();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();

    // Diese Zeile reicht aus, wenn du dein Auth-Handling kapselst
    when(() => mockAuth.currentUser).thenReturn(mockUser);
  });

  testWidgets('zeigt Dropdown', (tester) async {
    await tester.pumpWidget(MaterialApp(home: ServiceScreen()));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('teamDropdown')), findsOneWidget);
  });
}
