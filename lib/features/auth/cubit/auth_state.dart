// lib/features/auth/cubit/auth_state.dart

import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// لسا ما تحقّقنا من حالة الجلسة (أول لحظة فتح التطبيق).
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// عملية جارية: تسجيل دخول، إنشاء حساب، أو تسجيل خروج.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// فيه جلسة صالحة — المستخدم مسجّل دخول.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user.id];
}

/// مفيش جلسة — يظهر بعد تسجيل خروج، أو من البداية لو ما في جلسة محفوظة.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// فشلت عملية معيّنة (دخول/تسجيل/استرجاع كلمة مرور) — الرسالة جاهزة
/// بالعربي عبر ExceptionMapper.
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// نجح إرسال رابط استرجاع كلمة المرور — حالة منفصلة عشان شاشة F11
/// تعرف تنقل لشاشة "تم الإرسال" (F12) بدون ما تختلط بحالة تسجيل الدخول.
class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent();
}

class AuthSignUpEmailConfirmationRequired extends AuthState {
  const AuthSignUpEmailConfirmationRequired();
}

/// المستخدم دخل من رابط استعادة كلمة المرور (F12) — الجلسة صالحة مؤقتاً
/// بس القصد منها تعيين كلمة مرور جديدة بس، مش الدخول العادي عالتطبيق.
class AuthPasswordRecovery extends AuthState {
  const AuthPasswordRecovery();
}
