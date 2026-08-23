import 'package:glow_up/core/errors/error_messages.dart';

import 'app_exception.dart';

/// استثناء خاص بأخطاء تسجيل الدخول / إنشاء الحساب / الجلسة.
///
/// ملاحظة: اسمه `AppAuthException` مش `AuthException` عشان ما يتعارض
/// مع `AuthException` الأصلية يلي بترجع من مكتبة supabase_flutter.
class AppAuthException extends AppException {
  const AppAuthException(super.message);

  factory AppAuthException.invalidCredentials() =>
      AppAuthException(ErrorMessages.invalidCredentials);

  factory AppAuthException.emailAlreadyInUse() =>
      AppAuthException(ErrorMessages.emailAlreadyInUse);

  factory AppAuthException.weakPassword() =>
      AppAuthException(ErrorMessages.weakPassword);

  factory AppAuthException.emailNotConfirmed() =>
      AppAuthException(ErrorMessages.emailNotConfirmed);

  factory AppAuthException.sessionExpired() =>
      AppAuthException(ErrorMessages.sessionExpired);

  factory AppAuthException.emailRateLimitExceeded() =>
      AppAuthException(ErrorMessages.emailRateLimitExceeded);

  factory AppAuthException.generic() =>
      AppAuthException(ErrorMessages.authGeneric);
}
