import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/auth_user_entity.dart';

/// Remote data source for authentication operations
/// Interacts with Firebase Auth + Firestore + Storage
class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRemoteDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  /// Sign in with email and password
  Future<AuthUserEntity> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = result.user!;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    return _mapFirebaseUser(user, userDoc);
  }

  /// Create a new user with email and password
  Future<AuthUserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = result.user!;

    // Send email verification
    await user.sendEmailVerification();

    // Create user document in Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'email': email.trim(),
      'displayName': displayName,
      'role': role,
      'emailVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    return _mapFirebaseUser(user, userDoc);
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Get the current authenticated user
  Future<AuthUserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    return _mapFirebaseUser(user, userDoc);
  }

  /// Watch auth state changes
  Stream<AuthUserEntity?> get authStateChanges => _auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    return _mapFirebaseUser(user, userDoc);
  });

  /// Map Firebase User + Firestore doc to AuthUserEntity
  AuthUserEntity _mapFirebaseUser(User user, DocumentSnapshot userDoc) {
    final data = userDoc.data() as Map<String, dynamic>?;

    return AuthUserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: data?['displayName'] as String? ?? user.displayName ?? '',
      role: data?['role'] as String? ?? 'retailer',
      country: data?['country'] as String?,
      phone: user.phoneNumber ?? data?['phone'] as String?,
      photoUrl: user.photoURL ?? data?['photoUrl'] as String?,
      emailVerified: user.emailVerified,
    );
  }

  /// Sign in with Google (platform-specific)
  Future<AuthUserEntity> signInWithGoogle() async {
    // Platform-specific GoogleSignIn would go here
    // For now, this is a placeholder for the actual implementation
    throw UnsupportedError('Google Sign-In requires platform-specific setup');
  }

  /// Sign in with phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(AuthUserEntity user) onVerified,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        final result = await _auth.signInWithCredential(credential);
        final user = result.user!;
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        onVerified(_mapFirebaseUser(user, userDoc));
      },
      verificationFailed: (e) => onError(e.message ?? 'Phone verification failed'),
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Update display name
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;
    updates['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.collection('users').doc(uid).update(updates);
  }
}