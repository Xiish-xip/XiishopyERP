/// Xiishopy ERP - Authentication Bloc Events
library;

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  final String role;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
    this.role = 'retailer',
  });

  @override
  List<Object?> get props => [email, password, displayName, role];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class CheckAuthState extends AuthEvent {
  const CheckAuthState();
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class PhoneSignInRequested extends AuthEvent {
  final String phoneNumber;

  const PhoneSignInRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}