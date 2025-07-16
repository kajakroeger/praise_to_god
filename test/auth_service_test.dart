// Dieser Test prüft die gesamte Logik innerhalb signInWithGoogle(), aber ohne echte Firebase- oder Google-Services – alles wird gemockt.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:praise_to_god/services/auth_service.dart';

import 'mocks/mock_google_sign_in.mocks.dart';
import 'mocks/mock_firebase_auth.mocks.dart';

void main() {
  group('AuthService', () {
    test('signInWithGoogle() sollte Firebase-Login auslösen', () async {
      final mockGoogleSignIn = MockGoogleSignIn();
      final mockAccount = MockGoogleSignInAccount();
      final mockAuth = MockGoogleSignInAuthentication();
      final mockFirebaseAuth = MockFirebaseAuth();
      final mockUserCredential = MockUserCredential();

      // Google Sign-In simulieren
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
      when(mockAccount.authentication).thenAnswer((_) async => mockAuth);
      when(mockAuth.accessToken).thenReturn('fake_access_token');
      when(mockAuth.idToken).thenReturn('fake_id_token');

      // Firebase Login simulieren
      when(
        mockFirebaseAuth.signInWithCredential(any),
      ).thenAnswer((_) async => mockUserCredential);

      final authService = AuthService.forTest(
        googleSignIn: mockGoogleSignIn,
        auth: mockFirebaseAuth,
      );

      final result = await authService.signInWithGoogle();

      expect(result, isNotNull);
      expect(result, equals(mockUserCredential));
    });
  });
}
