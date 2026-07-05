/// Xiishopy ERP - Authentication Bloc
/// Manages auth state: sign-in, sign-up, sign-out, forgot-password, and auth checking.
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<CheckAuthState>(_onCheckAuthState);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);

    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _authRepository.authStateChanges.listen((result) {
      result.fold(
        (failure) => add(CheckAuthState()),
        (user) {
          if (user != null) {
            add(CheckAuthState());
          } else if (state is Authenticated) {
            add(CheckAuthState());
          }
        },
      );
    });
  }

  Future<void> _onCheckAuthState(
    CheckAuthState event, Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event, Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.signInWithEmail(
      event.email, event.password,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event, Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
      role: event.role,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event, Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event, Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.sendPasswordResetEmail(event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(PasswordResetSent(email: event.email)),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event, Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    emit(const AuthError(message: 'Google Sign-In not yet configured'));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}