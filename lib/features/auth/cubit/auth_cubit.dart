// lib/features/auth/cubit/auth_cubit.dart

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:glow_up/core/constants/auth_constants.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import 'package:glow_up/core/utils/app_logger.dart';
import 'package:glow_up/features/notifications/services/notification_service.dart';
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

  /// أثناء تسجيل خروج مقصود من [signIn] (حساب بريده غير مؤكّد) منتجاهل
  /// أحداث الـ stream. بدونها كان حدث `signedOut` بيوصل بعد ما نعمل
  /// emit لرسالة "أكّد بريدك" وبيدهسها بـ AuthUnauthenticated، فالمستخدم
  /// ما بيشوف ولا رسالة: الـ spinner بيدور وبيوقف والشاشة زي ما هي.
  bool _suppressAuthEvents = false;

  /// طلب إذن الإشعارات مرة وحدة بعمر تشغيل التطبيق، بعد الدخول.
  bool _notificationPermissionRequested = false;

  void _checkInitialSession() {
    final user = _repository.currentUser;
    if (user != null && user.emailConfirmedAt != null) {
      _onSignedIn(user);
    } else {
      _currentUserId = null;
      emit(const AuthUnauthenticated());
    }
  }

  void _onAuthChange(supabase.AuthState data) {
    if (_suppressAuthEvents) return;

    if (data.event == supabase.AuthChangeEvent.passwordRecovery) {
      emit(const AuthPasswordRecovery());
      return;
    }

    final user = data.session?.user;
    if (user != null && user.emailConfirmedAt != null) {
      _onSignedIn(user);
      return;
    }

    _currentUserId = null;

    // حدث "خروج" بلا مستخدم ما بيلغي رسالة خطأ لسا المستخدم ما قراها —
    // الحالتين بيعنوا "مش مسجّل دخول"، بس وحدة فيهم بتحمل سبب. هاد
    // بيحمي رسالة "أكّد بريدك" حتى لو وصل الحدث بعد ما رجع signOut.
    if (state is AuthError) return;

    emit(const AuthUnauthenticated());
  }

  void _onSignedIn(supabase.User user) {
    _currentUserId = user.id;
    emit(AuthAuthenticated(user));
    _updateFcmToken(user.id);
    _requestNotificationPermissionOnce();
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _repository.signIn(email: email, password: password);

      final currentUser = _repository.currentUser;
      if (currentUser != null && currentUser.emailConfirmedAt == null) {
        // منسكّر الجلسة الناقصة، بس منمنع حدث الخروج من دهس الرسالة.
        _suppressAuthEvents = true;
        try {
          await _repository.signOut();
        } finally {
          _suppressAuthEvents = false;
        }
        _currentUserId = null;
        emit(AuthError(ErrorMessages.emailNotConfirmed));
      }
      // الحالة الناجحة بتوصل من `authStateChanges` عبر [_onAuthChange].
    } catch (e, stackTrace) {
      AppLogger.error('AuthCubit.signIn', e, stackTrace);
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
    } catch (e, stackTrace) {
      AppLogger.error('AuthCubit.signUp', e, stackTrace);
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  /// بتمسح رسالة الخطأ بس — بترجع للحالة الحقيقية للجلسة بدل ما تفترض
  /// إنه ما في مستخدم. الافتراض القديم كان بيطلّع مستخدم مسجّل دخول
  /// من التطبيق لو انمسح خطأ صار وهو داخل (مثلاً بعد فشل تغيير كلمة المرور).
  void clearError() {
    if (state is! AuthError) return;

    final user = _repository.currentUser;
    if (user != null && user.emailConfirmedAt != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    try {
      await _repository.signOut();
      _currentUserId = null;
    } catch (e, stackTrace) {
      AppLogger.error('AuthCubit.signOut', e, stackTrace);
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
    } catch (e, stackTrace) {
      AppLogger.error('AuthCubit.resetPassword', e, stackTrace);
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  /// بتستدعى من شاشة تعيين كلمة مرور جديدة (بعد فتح رابط الاستعادة).
  Future<void> updatePassword(String newPassword) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.updatePassword(newPassword);
      _onSignedIn(user);
    } catch (e, stackTrace) {
      AppLogger.error('AuthCubit.updatePassword', e, stackTrace);
      emit(AuthError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> _requestNotificationPermissionOnce() async {
    if (_notificationPermissionRequested) return;
    _notificationPermissionRequested = true;
    await NotificationService.requestPermission();
  }

  Future<void> _updateFcmToken(String userId) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _saveFcmToken(userId, fcmToken);
      }
    } catch (e) {
      AppLogger.warn('AuthCubit: FCM token for $userId', e);
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
      AppLogger.warn('AuthCubit: save FCM token for $userId', e);
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _tokenRefreshSubscription.cancel();
    return super.close();
  }
}
