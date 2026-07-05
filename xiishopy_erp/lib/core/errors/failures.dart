/// Xiishopy ERP - Error Handling Foundation
/// Defines failure types for the Either pattern across the app.
library;

import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server/API failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Firebase Auth failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Firestore database failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

/// Network/Connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Cache/Storage failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Payment processing failures
class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.code});
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code});

  factory NotFoundFailure.entity(String entityName) {
    return NotFoundFailure(
      message: '$entityName not found',
      code: 'not_found',
    );
  }
}

/// Permission denied failures
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.code});
}

/// Utility to convert Firebase exceptions to failures
Failure firebaseExceptionToFailure(dynamic exception) {
  final code = exception.code ?? 'unknown';
  final message = exception.message ?? 'An unexpected error occurred';

  switch (code) {
    case 'permission-denied':
      return const PermissionFailure(
        message: 'You do not have permission to perform this action',
        code: 'permission-denied',
      );
    case 'not-found':
      return const NotFoundFailure(
        message: 'The requested resource was not found',
        code: 'not-found',
      );
    case 'already-exists':
      return const DatabaseFailure(
        message: 'This resource already exists',
        code: 'already-exists',
      );
    case 'unauthenticated':
      return const AuthFailure(
        message: 'Please sign in to continue',
        code: 'unauthenticated',
      );
    case 'invalid-argument':
      return ValidationFailure(
        message: message,
        code: 'invalid-argument',
      );
    case 'unavailable':
      return const NetworkFailure(
        message: 'Service temporarily unavailable. Please try again.',
        code: 'unavailable',
      );
    default:
      return ServerFailure(
        message: message,
        code: code,
      );
  }
}