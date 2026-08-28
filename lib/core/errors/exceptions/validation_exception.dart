import 'package:glow_up/core/errors/error_messages.dart';

import 'app_exception.dart';

/// استثناء خاص بالتحقق من صحة البيانات المدخلة بالفورمات
/// (إضافة/تعديل عميلة، تسجيل دخول، إنشاء حساب...).
class ValidationException extends AppException {
  const ValidationException(super.message);

  factory ValidationException.requiredField() =>
      ValidationException(ErrorMessages.requiredField);

  factory ValidationException.invalidEmail() =>
      ValidationException(ErrorMessages.invalidEmail);

  factory ValidationException.invalidPhone() =>
      ValidationException(ErrorMessages.invalidPhone);

  factory ValidationException.passwordTooShort() =>
      ValidationException(ErrorMessages.passwordTooShort);

  factory ValidationException.generic() =>
      ValidationException(ErrorMessages.validationGeneric);
}
