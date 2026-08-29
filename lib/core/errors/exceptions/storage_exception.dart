import 'package:glow_up/core/errors/error_messages.dart';

import 'app_exception.dart';

/// استثناء خاص برفع/جلب الصور من Supabase Storage (صور القياسات، البروفايل...).
///
/// ملاحظة: اسمه `AppStorageException` عشان ما يتعارض مع `StorageException`
/// الأصلية يلي بترجع من مكتبة supabase_flutter.
class AppStorageException extends AppException {
  const AppStorageException(super.message);

  factory AppStorageException.fileTooLarge() =>
      AppStorageException(ErrorMessages.fileTooLarge);

  factory AppStorageException.uploadFailed() =>
      AppStorageException(ErrorMessages.uploadFailed);

  factory AppStorageException.fileNotFound() =>
      AppStorageException(ErrorMessages.fileNotFound);

  factory AppStorageException.fileAlreadyExists() =>
      AppStorageException(ErrorMessages.fileAlreadyExists);

  factory AppStorageException.unsupportedFileType() =>
      AppStorageException(ErrorMessages.unsupportedFileType);

  factory AppStorageException.generic() =>
      AppStorageException(ErrorMessages.storageGeneric);
}
