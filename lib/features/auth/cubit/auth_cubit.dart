// lib/features/auth/cubit/auth_cubit.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

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
    emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated());
  }

  void _onAuthChange(supabase.AuthState data) {
    final user = data.session?.user;
    emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated());
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _repository.signIn(email: email, password: password);
      // ما منعمل emit(Authenticated) يدويًا هون — الـ authStateChanges
      // listener فوق رح يلتقطها تلقائيًا ويحدّث الحالة.
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
      await _repository.signUp(email: email, password: password, fullName: fullName);
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
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