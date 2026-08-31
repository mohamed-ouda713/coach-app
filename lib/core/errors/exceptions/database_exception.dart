import 'package:glow_up/core/errors/error_messages.dart';

import 'app_exception.dart';

/// استثناء خاص بأخطاء قاعدة البيانات (Postgrest) — insert/update/delete/select.
class DatabaseException extends AppException {
  const DatabaseException(super.message);

  factory DatabaseException.duplicateEntry() =>
      DatabaseException(ErrorMessages.duplicateEntry);

  factory DatabaseException.recordNotFound() =>
      DatabaseException(ErrorMessages.recordNotFound);

  factory DatabaseException.foreignKeyViolation() =>
      DatabaseException(ErrorMessages.foreignKeyViolation);

  factory DatabaseException.permissionDenied() =>
      DatabaseException(ErrorMessages.permissionDenied);

  factory DatabaseException.missingRequiredData() =>
      DatabaseException(ErrorMessages.missingRequiredData);

  factory DatabaseException.invalidData() =>
      DatabaseException(ErrorMessages.invalidData);

  factory DatabaseException.serverBusy() =>
      DatabaseException(ErrorMessages.serverBusy);

  factory DatabaseException.generic() =>
      DatabaseException(ErrorMessages.databaseGeneric);
}
