

import 'package:glow_up/core/errors/error_messages.dart';


import 'app_exception.dart';

/// استثناء خاص بأخطاء قاعدة البيانات (Postgrest) — insert/update/delete/select.
class DatabaseException extends AppException {
  const DatabaseException(super.message);

  factory DatabaseException.duplicateEntry() =>
      const DatabaseException(ErrorMessages.duplicateEntry);

  factory DatabaseException.recordNotFound() =>
      const DatabaseException(ErrorMessages.recordNotFound);

  factory DatabaseException.foreignKeyViolation() =>
      const DatabaseException(ErrorMessages.foreignKeyViolation);

  factory DatabaseException.permissionDenied() =>
      const DatabaseException(ErrorMessages.permissionDenied);

  factory DatabaseException.generic() =>
      const DatabaseException(ErrorMessages.databaseGeneric);
}
