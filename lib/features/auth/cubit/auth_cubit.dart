// lib/features/auth/cubit/auth_cubit.dart

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:glow_up/core/constants/auth_constants.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial()) {
    _checkInitialSession();
    _authSubscription = _repository.authStateChanges.listen(_onAuthChange);
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen(_onFcmTokenRefresh);
  }

  final AuthRepository _repository;
  late final StreamSubscription<supabase.AuthState> _authSubscription;
  late final StreamSubscription<String> _tokenRefreshSubscription;
  String? _currentUserId;

  void _checkInitialSession() {
    final user = _repository.currentUser;
    final isEmailConfirmed = user?.emailConfirmedAt != null;
    if (user != null && isEmailConfirmed) {
      _currentUserId = user.id;
      emit(AuthAuthenticated(user));
      _updateFcmToken(user.id);
    } else {
      _currentUserId = null;
      emit(const AuthUnauthenticated());
    }
  }

  void _onAuthChange(supabase.AuthState data) {
    if (data.event == supabase.AuthChangeEvent.passwordRecovery) {
      emit(const AuthPasswordRecovery());
      return;
    }
    final user = data.session?.user;
    final isEmailConfirmed = user?.emailConfirmedAt != null;
    if (user != null && isEmailConfirmed) {
      _currentUserId = user.id;
      emit(AuthAuthenticated(user));
      _updateFcmToken(user.id);
    } else {
      _currentUserId = null;
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _repository.signIn(email: email, password: password);
      final currentUser = _repository.currentUser;
      if (currentUser != null && currentUser.emailConfirmedAt == null) {
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
        emit(AuthError(ErrorMessages.emailNotAvailable));
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
      _currentUserId = null;
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthLoading());
    try {
      await _repository.resetPasswordForEmail(
        email,
        redirectTo: AuthRedirectUrls.passwordRecovery,
      );
      emit(const AuthPasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  /// بتستدعى من شاشة تعيين كلمة مرور جديدة (بعد فتح رابط الاستعادة).
  Future<void> updatePassword(String newPassword) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.updatePassword(newPassword);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> _updateFcmToken(String userId) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _saveFcmToken(userId, fcmToken);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update FCM token for user $userId: $e');
      }
    }
  }

  Future<void> _onFcmTokenRefresh(String token) async {
    final userId = _currentUserId;
    if (userId == null) return;
    await _saveFcmToken(userId, token);
  }

  Future<void> _saveFcmToken(String userId, String fcmToken) async {
    try {
      await supabase.Supabase.instance.client
          .from(SupabaseTables.trainers)
          .update({SupabaseColumns.fcmToken: fcmToken})
          .eq(SupabaseColumns.id, userId);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save FCM token for user $userId: $e');
      }
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _tokenRefreshSubscription.cancel();
    return super.close();
  }
}
