

import 'package:glow_up/core/errors/error_messages.dart';


import 'app_exception.dart';

/// استثناء خاص بمشاكل الاتصال بالإنترنت أو انتهاء وقت الطلب (timeout).
class NetworkException extends AppException {
  const NetworkException(super.message);

  factory NetworkException.noInternet() =>
      const NetworkException(ErrorMessages.noInternet);

  factory NetworkException.timeout() =>
      const NetworkException(ErrorMessages.requestTimeout);

  factory NetworkException.serverUnreachable() =>
      const NetworkException(ErrorMessages.serverUnreachable);
}
