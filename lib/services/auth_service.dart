import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// 🔐 AuthService
class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Erstellt das Nutzer-Dokument, falls es noch nicht existiert
  /// Gibt den Vornamen aus displayName extrahieren (nur erstes Wort)
  String extractFirstName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return 'Unbekannt';
    return displayName.split(' ').first;
  }

  /// Stellt sicher, dass ein User-Dokument im Firestore existiert
  /// Falls es noch nicht da ist, wird es mit Basisdaten angelegt
  Future<void> ensureUserDocumentExists(User user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'first_name': extractFirstName(user.displayName),
        'email': user.email,
        'role': 'teamMember',
      });
    }
  }

  /// Login mit Google
  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    // Sicherstellen, dass Nutzer-Daten im Firestore vorhanden sind
    await ensureUserDocumentExists(userCredential.user!);

    return userCredential;
  }

  /// Login mit E-Mail & Passwort
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Sicherstellen, dass Nutzer-Daten im Firestore vorhanden sind
    await ensureUserDocumentExists(userCredential.user!);

    return userCredential;
  }

  /// Logout aus Firebase + Google Sign-In
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  /// Zugriff auf den aktuell eingeloggten Nutzer
  User? get currentUser => _auth.currentUser;

  // Statische Hilfsmethode für Tests mit eigenen Auth-Instanzen
  static AuthService forTest({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) {
    return AuthService(auth: auth, googleSignIn: googleSignIn);
  }
}
