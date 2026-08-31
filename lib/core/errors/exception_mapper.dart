import 'dart:async';
import 'dart:io';

import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exceptions/app_exception.dart';
import 'package:glow_up/core/errors/exceptions/auth_exception.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import 'package:glow_up/core/errors/exceptions/network_exception.dart';
import 'package:glow_up/core/errors/exceptions/storage_exception.dart';
import 'package:glow_up/core/network/connectivity_service.dart';
import 'package:glow_up/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;
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
///
/// ترتيب الفحص مهم: أخطاء الشبكة بتنفحص **قبل** أخطاء Supabase، لأن
/// المكتبة بتغلّف فشل الاتصال بأنواعها الخاصة (مثلاً
/// `AuthRetryableFetchException` يلي بترث من `AuthException`). لو
/// فحصنا `AuthException` أول، كل انقطاع نت كان بيطلع كـ "خطأ أثناء
/// تسجيل الدخول" — وهاد بالضبط يلي كان بيصير قبل.
class ExceptionMapper {
  ExceptionMapper._();

  /// النقطة الوحيدة يلي بتستدعيها الـ Cubit — كل [catch (e)] يمرّ من هون.
  static String mapToMessage(Object error) => mapToException(error).message;

  /// نفس المنطق بس بترجع الاستثناء المصنّف — مفيدة لما نحتاج نفرّق
  /// بالسلوك (مثلاً نعرض زر "إعادة محاولة" لأخطاء الشبكة بس).
  static AppException mapToException(Object error) {
    // استثناء متوقّع أصلاً رميناه إحنا يدويًا (مثلاً من Validation)
    if (error is AppException) return error;

    final networkException = _asNetworkException(error);
    if (networkException != null) return networkException;

    if (error is supabase.AuthException) return _mapAuthException(error);
    if (error is supabase.PostgrestException) {
      return _mapDatabaseException(error);
    }
    if (error is supabase.StorageException) return _mapStorageException(error);

    // خطأ بتحويل صف من قاعدة البيانات لموديل (عمود ناقص أو نوع مختلف)
    if (error is TypeError || error is FormatException) {
      AppLogger.error('ExceptionMapper: malformed data', error);
      return DatabaseException.invalidData();
    }

    AppLogger.error('ExceptionMapper: unmapped ${error.runtimeType}', error);
    return _UnexpectedException();
  }

  // ── Network ──────────────────────────────────────────────
  //
  // بترجع null لو الخطأ مش خطأ شبكة أصلاً.
  static NetworkException? _asNetworkException(Object error) {
    if (error is TimeoutException) return NetworkException.timeout();

    if (error is SocketException) return _networkByReachability(error.message);

    // package:http بتغلّف SocketException بـ ClientException — وهاد يلي
    // بيوصل فعليًا من استدعاءات postgrest و storage.
    if (error is http.ClientException) {
      return _networkByReachability(error.message);
    }

    if (error is HandshakeException || error is TlsException) {
      return NetworkException.serverUnreachable();
    }

    // فشل اتصال متكرّر بطبقة المصادقة — دايمًا مشكلة شبكة، مش بيانات دخول.
    if (error is supabase.AuthRetryableFetchException) {
      return _networkByReachability(error.message);
    }

    // 5xx من أي طبقة = الخادم مش قادر يرد
    final statusCode = _statusCodeOf(error);
    if (statusCode != null && statusCode >= 500) {
      return statusCode == 503 || statusCode == 504
          ? NetworkException.serverUnreachable()
          : null; // 500/502 أخطاء منطق بالخادم — منخليها للطبقة المختصة
    }

    return null;
  }

  /// بتفرّق بين "ما في نت عندك" و"الخادم مش راد". بدون هالتفريق كل
  /// خطأ اتصال كان بيقول للمستخدم "تحقق من الشبكة" حتى لو شبكته تمام.
  static NetworkException _networkByReachability(String detail) {
    if (!ConnectivityService.isOnline) return NetworkException.noInternet();

    // فشل DNS بيصير كمان لما الجهاز متصل بشبكة بلا إنترنت فعلي
    // (كافيه بدون تسجيل دخول مثلاً) — فمنعامله كانقطاع نت.
    final lower = detail.toLowerCase();
    if (lower.contains('failed host lookup') ||
        lower.contains('nodename nor servname') ||
        lower.contains('no address associated')) {
      return NetworkException.noInternet();
    }
    return NetworkException.serverUnreachable();
  }

  static int? _statusCodeOf(Object error) {
    if (error is supabase.AuthException) {
      return int.tryParse(error.statusCode ?? '');
    }
    if (error is supabase.StorageException) {
      return int.tryParse(error.statusCode ?? '');
    }
    if (error is supabase.PostgrestException) {
      return int.tryParse(error.code ?? '');
    }
    return null;
  }

  // ── Auth ─────────────────────────────────────────────────
  //
  // Supabase بترجع `code` منظّم (مثلاً `invalid_credentials`). المطابقة
  // عليه أدق بكتير من البحث بنص الرسالة: النص إنجليزي، بيتغيّر بين
  // إصدارات الخادم، وما بيغطي إلا الحالات يلي حزرناها.
  static AppAuthException _mapAuthException(supabase.AuthException e) {
    final byCode = _authFromCode(e.code);
    if (byCode != null) return byCode;

    final byMessage = _authFromMessage(e.message);
    if (byMessage != null) return byMessage;

    // ما لقينا تصنيف — نسجّله عشان نضيفه للجدول بدل ما يضيع بالرسالة العامة.
    AppLogger.error(
      'ExceptionMapper: unmapped auth code=${e.code} status=${e.statusCode}',
      e.message,
    );

    final statusCode = int.tryParse(e.statusCode ?? '');
    if (statusCode == 401 || statusCode == 403) {
      return AppAuthException.invalidCredentials();
    }
    if (statusCode == 429) return AppAuthException.tooManyAttempts();
    return AppAuthException.generic();
  }

  static AppAuthException? _authFromCode(String? code) {
    switch (code) {
      case 'invalid_credentials':
      case 'user_not_found':
      case 'invalid_grant':
        return AppAuthException.invalidCredentials();

      case 'email_exists':
      case 'user_already_exists':
      case 'identity_already_exists':
        return AppAuthException.emailAlreadyInUse();

      case 'weak_password':
        return AppAuthException.weakPassword();

      case 'same_password':
        return AppAuthException.samePassword();

      case 'email_not_confirmed':
      case 'provider_email_needs_verification':
        return AppAuthException.emailNotConfirmed();

      case 'session_expired':
      case 'session_not_found':
      case 'session_missing':
      case 'refresh_token_not_found':
      case 'refresh_token_already_used':
      case 'bad_jwt':
      case 'invalid_jwt':
      case 'no_authorization':
        return AppAuthException.sessionExpired();

      case 'over_email_send_rate_limit':
      case 'over_sms_send_rate_limit':
        return AppAuthException.emailRateLimitExceeded();

      case 'over_request_rate_limit':
        return AppAuthException.tooManyAttempts();

      case 'otp_expired':
      case 'flow_state_expired':
      case 'flow_state_not_found':
        return AppAuthException.resetLinkExpired();

      case 'signup_disabled':
      case 'email_provider_disabled':
      case 'provider_disabled':
        return AppAuthException.signUpDisabled();

      case 'user_banned':
        return AppAuthException.accountDisabled();

      case 'reauthentication_needed':
      case 'reauthentication_not_valid':
        return AppAuthException.reauthenticationNeeded();

      case 'validation_failed':
      case 'bad_json':
        return AppAuthException(ErrorMessages.validationGeneric);

      case 'request_timeout':
        return AppAuthException(ErrorMessages.requestTimeout);

      default:
        return null;
    }
  }

  /// احتياطي للخوادم القديمة يلي لسا ما بترجع `code`.
  static AppAuthException? _authFromMessage(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return AppAuthException.invalidCredentials();
    }
    if (msg.contains('already registered') ||
        msg.contains('already been registered')) {
      return AppAuthException.emailAlreadyInUse();
    }
    if (msg.contains('password') &&
        (msg.contains('short') || msg.contains('at least'))) {
      return AppAuthException.weakPassword();
    }
    if (msg.contains('new password should be different')) {
      return AppAuthException.samePassword();
    }
    if (msg.contains('email not confirmed') || msg.contains('not confirmed')) {
      return AppAuthException.emailNotConfirmed();
    }
    if (msg.contains('user not found')) {
      return AppAuthException.invalidCredentials();
    }
    if ((msg.contains('session') || msg.contains('token')) &&
        (msg.contains('expired') ||
            msg.contains('missing') ||
            msg.contains('not found'))) {
      return AppAuthException.sessionExpired();
    }
    if (msg.contains('rate limit') || msg.contains('too many requests')) {
      return AppAuthException.emailRateLimitExceeded();
    }
    if (msg.contains('signups not allowed') ||
        msg.contains('signup is disabled')) {
      return AppAuthException.signUpDisabled();
    }
    if (msg.contains('banned')) return AppAuthException.accountDisabled();
    if (msg.contains('expired') && msg.contains('link')) {
      return AppAuthException.resetLinkExpired();
    }
    return null;
  }

  // ── Database (Postgrest) ────────────────────────────────
  static DatabaseException _mapDatabaseException(
    supabase.PostgrestException e,
  ) {
    switch (e.code) {
      // ── أكواد PostgreSQL ──
      case '23505': // unique_violation
        return DatabaseException.duplicateEntry();
      case '23503': // foreign_key_violation
        return DatabaseException.foreignKeyViolation();
      case '23502': // not_null_violation
        return DatabaseException.missingRequiredData();
      case '23514': // check_violation
      case '22P02': // invalid_text_representation
      case '22007': // invalid_datetime_format
      case '22003': // numeric_value_out_of_range
        return DatabaseException.invalidData();
      case '42501': // insufficient_privilege / RLS
        return DatabaseException.permissionDenied();
      case '40001': // serialization_failure
      case '53300': // too_many_connections
      case '57014': // query_canceled
        return DatabaseException.serverBusy();

      // ── أكواد PostgREST ──
      case 'PGRST116': // لا توجد نتيجة (single() ما لقى صف)
        return DatabaseException.recordNotFound();
      case 'PGRST301': // JWT منتهي
        return DatabaseException(ErrorMessages.sessionExpired);
      case 'PGRST204': // عمود غير موجود بالـ payload
      case 'PGRST202': // دالة RPC غير موجودة
        return DatabaseException.invalidData();

      // ── أكواد HTTP بترجع مطرح code أحياناً ──
      case '401':
      case '403':
        return DatabaseException.permissionDenied();
      case '404':
        return DatabaseException.recordNotFound();
      case '409':
        return DatabaseException.duplicateEntry();
      case '429':
        return DatabaseException.serverBusy();
    }

    final msg = e.message.toLowerCase();
    if (msg.contains('jwt') && msg.contains('expired')) {
      return DatabaseException(ErrorMessages.sessionExpired);
    }
    if (msg.contains('row-level security') || msg.contains('permission')) {
      return DatabaseException.permissionDenied();
    }

    AppLogger.error(
      'ExceptionMapper: unmapped postgrest code=${e.code}',
      '${e.message} | details=${e.details} | hint=${e.hint}',
    );
    return DatabaseException.generic();
  }

  // ── Storage ──────────────────────────────────────────────
  static AppStorageException _mapStorageException(supabase.StorageException e) {
    switch (e.statusCode) {
      case '413':
        return AppStorageException.fileTooLarge();
      case '404':
        return AppStorageException.fileNotFound();
      case '409':
        return AppStorageException.fileAlreadyExists();
      case '415':
        return AppStorageException.unsupportedFileType();
      case '401':
      case '403':
        return AppStorageException(ErrorMessages.permissionDenied);
      case '429':
        return AppStorageException(ErrorMessages.serverBusy);
    }

    final msg = e.message.toLowerCase();
    if (msg.contains('exceeded the maximum allowed size') ||
        msg.contains('payload too large')) {
      return AppStorageException.fileTooLarge();
    }
    if (msg.contains('already exists') || msg.contains('duplicate')) {
      return AppStorageException.fileAlreadyExists();
    }
    if (msg.contains('not found')) return AppStorageException.fileNotFound();
    if (msg.contains('mime type') || msg.contains('invalid_mime_type')) {
      return AppStorageException.unsupportedFileType();
    }

    AppLogger.error(
      'ExceptionMapper: unmapped storage status=${e.statusCode}',
      '${e.message} | error=${e.error}',
    );
    return AppStorageException.generic();
  }
}

/// آخر خط دفاع — لما ما نعرف نصنّف الخطأ إطلاقًا.
class _UnexpectedException extends AppException {
  _UnexpectedException() : super(ErrorMessages.unexpected);
}
