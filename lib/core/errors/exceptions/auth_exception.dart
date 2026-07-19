



import 'package:glow_up/core/errors/error_messages.dart';

import 'app_exception.dart';

/// استثناء خاص بأخطاء تسجيل الدخول / إنشاء الحساب / الجلسة.
///
/// ملاحظة: اسمه `AppAuthException` مش `AuthException` عشان ما يتعارض
/// مع `AuthException` الأصلية يلي بترجع من مكتبة supabase_flutter.
class AppAuthException extends AppException {
  const AppAuthException(super.message);

  factory AppAuthException.invalidCredentials() =>
      const AppAuthException(ErrorMessages.invalidCredentials);

  factory AppAuthException.emailAlreadyInUse() =>
      const AppAuthException(ErrorMessages.emailAlreadyInUse);

  factory AppAuthException.weakPassword() =>
      const AppAuthException(ErrorMessages.weakPassword);

  factory AppAuthException.userNotFound() =>
      const AppAuthException(ErrorMessages.userNotFound);

  factory AppAuthException.emailNotConfirmed() =>
      const AppAuthException(ErrorMessages.emailNotConfirmed);

  factory AppAuthException.sessionExpired() =>
      const AppAuthException(ErrorMessages.sessionExpired);

  factory AppAuthException.generic() =>
      const AppAuthException(ErrorMessages.authGeneric);
}
