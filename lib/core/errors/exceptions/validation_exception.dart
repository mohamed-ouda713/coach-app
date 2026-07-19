
import 'package:glow_up/core/errors/error_messages.dart';

import 'app_exception.dart';

/// استثناء خاص بالتحقق من صحة البيانات المدخلة بالفورمات
/// (إضافة/تعديل عميلة، تسجيل دخول، إنشاء حساب...).
class ValidationException extends AppException {
  const ValidationException(super.message);

  factory ValidationException.requiredField() =>
      const ValidationException(ErrorMessages.requiredField);

  factory ValidationException.invalidEmail() =>
      const ValidationException(ErrorMessages.invalidEmail);

  factory ValidationException.invalidPhone() =>
      const ValidationException(ErrorMessages.invalidPhone);

  factory ValidationException.passwordTooShort() =>
      const ValidationException(ErrorMessages.passwordTooShort);

  factory ValidationException.generic() =>
      const ValidationException(ErrorMessages.validationGeneric);
}
