// lib/features/auth/cubit/auth_cubit.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial()) {
    _checkInitialSession();
    _authSubscription = _repository.authStateChanges.listen(_onAuthChange);
  }

  final AuthRepository _repository;
  late final StreamSubscription<supabase.AuthState> _authSubscription;

  void _checkInitialSession() {
    final user = _repository.currentUser;
    final isEmailConfirmed = user?.emailConfirmedAt != null;
    emit(user != null && isEmailConfirmed ? AuthAuthenticated(user) : const AuthUnauthenticated());
  }

  void _onAuthChange(supabase.AuthState data) {
    final user = data.session?.user;
    final isEmailConfirmed = user?.emailConfirmedAt != null;
    emit(user != null  && isEmailConfirmed ? AuthAuthenticated(user) : const AuthUnauthenticated());
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _repository.signIn(email: email, password: password);
      final currentUser = _repository.currentUser;
      if(currentUser != null && currentUser.emailConfirmedAt == null) {
        await _repository.signOut();
        emit(const AuthSignUpEmailConfirmationRequired());
      }
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(const AuthLoading());
    try {
      final response = await _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      final identities = response.user?.identities;
      if (identities != null && identities.isEmpty) {
        emit(const AuthError(ErrorMessages.emailNotAvailable));
        return;
      }
      if (response.session == null) {
        emit(const AuthSignUpEmailConfirmationRequired());
      }
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  void clearError() {
    if (state is AuthError) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    try {
      await _repository.signOut();
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthLoading());
    try {
      await _repository.resetPasswordForEmail(email);
      emit(const AuthPasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
