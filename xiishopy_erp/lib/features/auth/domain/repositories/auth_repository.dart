import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, AuthUserEntity>> signInWithEmail(
    String email,
    String password,
  );

  /// Create a new account
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Get currently authenticated user
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();

  /// Stream of auth state changes
  Stream<Either<Failure, AuthUserEntity?>> get authStateChanges;
}