import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithEmail(
      String email, String password) async {
    try {
      final user = await _remoteDataSource.signInWithEmail(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, AuthUserEntity?>> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((user) {
      return Right<Failure, AuthUserEntity?>(user);
    }).handleError((Object error) {
      return Left<Failure, AuthUserEntity?>(ServerFailure(message: error.toString()));
    });
  }

  Failure _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthFailure(message: 'No account found with this email', code: e.code);
      case 'wrong-password':
        return AuthFailure(message: 'Incorrect password', code: e.code);
      case 'invalid-email':
        return AuthFailure(message: 'Invalid email address', code: e.code);
      case 'email-already-in-use':
        return AuthFailure(message: 'An account already exists with this email', code: e.code);
      case 'weak-password':
        return AuthFailure(message: 'Password must be at least 6 characters', code: e.code);
      case 'too-many-requests':
        return AuthFailure(message: 'Too many attempts. Please try again later.', code: e.code);
      case 'network-request-failed':
        return NetworkFailure(message: 'No internet connection', code: e.code);
      default:
        return AuthFailure(message: e.message ?? 'Authentication failed', code: e.code);
    }
  }
}