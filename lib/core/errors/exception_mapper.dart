import 'dart:async';
import 'dart:io';

import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exceptions/app_exception.dart';
import 'package:glow_up/core/errors/exceptions/auth_exception.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import 'package:glow_up/core/errors/exceptions/network_exception.dart';
import 'package:glow_up/core/errors/exceptions/storage_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// نقطة الدخول الوحيدة لتحويل أي خطأ (Supabase أو غيره) إلى رسالة نصية
/// جاهزة بالعربي، تُستخدم مباشرة بالـ Cubit:
///
/// ```dart
/// try {
///   await _repository.addClient(client);
///   emit(AddClientSuccess());
/// } catch (e) {
///   emit(AddClientError(ExceptionMapper.mapToMessage(e)));
/// }
/// ```
class ExceptionMapper {
  ExceptionMapper._();

  /// النقطة الوحيدة يلي بتستدعيها الـ Cubit — كل [catch (e)] يمرّ من هون.
  static String mapToMessage(Object error) {
    if (error is AppException) {
      // استثناء متوقّع أصلاً رميناه إحنا يدويًا (مثلاً من Validation)
      return error.message;
    }
    if (error is supabase.AuthException) {
      return _mapAuthException(error).message;
    }
    if (error is supabase.PostgrestException) {
      return _mapDatabaseException(error).message;
    }
    if (error is supabase.StorageException) {
      return _mapStorageException(error).message;
    }
    if (error is SocketException) {
      return NetworkException.noInternet().message;
    }
    if (error is TimeoutException) {
      return NetworkException.timeout().message;
    }
    return ErrorMessages.unexpected;
  }

  // ── Auth ─────────────────────────────────────────────────
  static AppAuthException _mapAuthException(supabase.AuthException e) {
    final msg = e.message.toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return AppAuthException.invalidCredentials();
    }
    if (msg.contains('already registered')) {
      return AppAuthException.emailAlreadyInUse();
    }
    if (msg.contains('password') && msg.contains('short')) {
      return AppAuthException.weakPassword();
    }
    if (msg.contains('email not confirmed')) {
      return AppAuthException.emailNotConfirmed();
    }
    if (msg.contains('user not found')) {
      return AppAuthException.invalidCredentials();
    }
    if (msg.contains('session') && msg.contains('expired')) {
      return AppAuthException.sessionExpired();
    }
    if (msg.contains('rate limit')) {
      return AppAuthException.emailRateLimitExceeded();
    }
    return AppAuthException.generic();
  }

  // ── Database (Postgrest) ────────────────────────────────
  static DatabaseException _mapDatabaseException(
    supabase.PostgrestException e,
  ) {
    switch (e.code) {
      case '23505': // unique_violation
        return DatabaseException.duplicateEntry();
      case '23503': // foreign_key_violation
        return DatabaseException.foreignKeyViolation();
      case 'PGRST116': // لا توجد نتيجة (single() ما لقى صف)
        return DatabaseException.recordNotFound();
      case '42501': // insufficient_privilege / RLS
        return DatabaseException.permissionDenied();
      default:
        return DatabaseException.generic();
    }
  }

  // ── Storage ──────────────────────────────────────────────
  static AppStorageException _mapStorageException(supabase.StorageException e) {
    switch (e.statusCode) {
      case '413':
        return AppStorageException.fileTooLarge();
      case '404':
        return AppStorageException.fileNotFound();
      default:
        return AppStorageException.generic();
    }
  }
}
