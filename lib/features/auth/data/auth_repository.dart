// lib/features/auth/data/auth_repository.dart

import 'package:glow_up/core/constants/auth_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;

  bool get isSignedIn => currentUser != null;

  /// بث حالة الجلسة — الـ Cubit بيسمعله عشان يعرف لحظة بلحظة
  /// لو المستخدم سجّل دخول أو خرج (مفيد كمان لو انتهت صلاحية التوكن).
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  /// [fullName] بينحفظ بـ user metadata، والـ trigger يلي عملناه
  /// بقاعدة البيانات (on_auth_user_created) بيستخدمه تلقائيًا
  /// لتعبئة جدول trainers.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {UserMetadataKeys.fullName: fullName},
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    await _client.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  /// بتستدعى بعد ما يفتح المستخدم رابط الاستعادة — الجلسة المؤقتة
  /// (recovery session) هي يلي بتسمح بهاد التحديث بدون كلمة مرور قديمة.
  Future<User> updatePassword(String newPassword) async {
    final response = await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    return response.user!;
  }
}
